// SPDX-License-Identifier: MIT

use std::process::Command;

#[derive(Debug, Clone, Default)]
pub struct Status {
    pub cpu: String,
    pub battery: String,
    pub network: String,
    pub bluetooth: String,
    pub audio: String,
    pub weather: String,
}

fn run(cmd: &str, args: &[&str]) -> Option<String> {
    let out = Command::new(cmd).args(args).output().ok()?;
    if out.status.success() {
        Some(String::from_utf8_lossy(&out.stdout).trim().to_string())
    } else {
        None
    }
}

pub struct StatusPoller {
    prev_idle: u64,
    prev_total: u64,
}

impl StatusPoller {
    pub fn new() -> Self {
        Self {
            prev_idle: 0,
            prev_total: 0,
        }
    }

    pub fn poll(&mut self) -> Status {
        Status {
            cpu: self.cpu(),
            battery: self.battery(),
            network: self.network(),
            bluetooth: self.bluetooth(),
            audio: self.audio(),
            weather: self.weather(),
        }
    }

    fn cpu(&mut self) -> String {
        let Ok(content) = std::fs::read_to_string("/proc/stat") else {
            return String::new();
        };
        let Some(line) = content.lines().find(|l| l.starts_with("cpu ")) else {
            return String::new();
        };
        let values: Vec<u64> = line
            .split_whitespace()
            .skip(1)
            .filter_map(|v| v.parse().ok())
            .collect();
        if values.len() < 4 {
            return String::new();
        }
        let idle = values[3] + values.get(4).copied().unwrap_or(0);
        let total: u64 = values.iter().sum();
        let d_idle = idle.saturating_sub(self.prev_idle);
        let d_total = total.saturating_sub(self.prev_total);
        self.prev_idle = idle;
        self.prev_total = total;
        if d_total == 0 {
            return String::new();
        }
        let usage = 100.0 * (d_total - d_idle) as f64 / d_total as f64;
        format!("󰍛 {usage:.0}%")
    }

    fn battery(&self) -> String {
        let Ok(entries) = std::fs::read_dir("/sys/class/power_supply") else {
            return String::new();
        };
        let mut batteries: Vec<_> = entries
            .flatten()
            .map(|e| e.path())
            .filter(|p| p.file_name().and_then(|n| n.to_str()).map(|n| n.starts_with("BAT")).unwrap_or(false))
            .collect();
        batteries.sort();
        let Some(battery) = batteries.first() else {
            return String::new();
        };
        let capacity = std::fs::read_to_string(battery.join("capacity"))
            .ok()
            .and_then(|s| s.trim().parse::<i32>().ok())
            .unwrap_or(0);
        let charging = std::fs::read_to_string(battery.join("status"))
            .map(|s| s.trim() == "Charging")
            .unwrap_or(false);
        let icon = if charging {
            "󰂆"
        } else if capacity >= 80 {
            "󰂅"
        } else if capacity >= 40 {
            "󰂂"
        } else {
            "󰁹"
        };
        format!("{icon} {capacity}%")
    }

    fn network(&self) -> String {
        if let Some(ssid) = run("nmcli", &["-t", "-f", "active,ssid", "dev", "wifi"])
            .and_then(|s| {
                s.lines().find_map(|l| {
                    let mut parts = l.split(':');
                    let active = parts.next()?;
                    let ssid = parts.next().unwrap_or("");
                    if active == "yes" && !ssid.is_empty() {
                        Some(ssid.to_string())
                    } else {
                        None
                    }
                })
            })
        {
            return format!("󰤨 {ssid}");
        }
        if run("nmcli", &["-t", "-f", "name,type", "connection", "show", "--active"])
            .map(|s| s.lines().any(|l| l.split(':').nth(1) == Some("ethernet") || l.split(':').nth(1) == Some("802-3-ethernet")))
            .unwrap_or(false)
        {
            return "󰀂".to_string();
        }
        "󰤮".to_string()
    }

    fn bluetooth(&self) -> String {
        let connected = run("bluetoothctl", &["devices", "Connected"])
            .map(|s| s.lines().filter(|l| !l.trim().is_empty()).count())
            .unwrap_or(0);
        if connected > 0 {
            "󰂱".to_string()
        } else {
            "󰂲".to_string()
        }
    }

    fn audio(&self) -> String {
        let muted = run("wpctl", &["get-mute", "@DEFAULT_AUDIO_SINK@"])
            .map(|s| s == "Muted")
            .unwrap_or(false);
        let volume = run("wpctl", &["get-volume", "@DEFAULT_AUDIO_SINK@"])
            .and_then(|s| s.split_whitespace().last().and_then(|v| v.parse::<f32>().ok()))
            .map(|v| (v * 100.0).round() as i32)
            .unwrap_or(0);

        let icon = if muted {
            ""
        } else if volume >= 66 {
            ""
        } else if volume >= 33 {
            ""
        } else {
            ""
        };
        format!("{icon} {volume}%")
    }

    fn weather(&self) -> String {
        run("curl", &["-fsS", "--max-time", "5", "wttr.in/?format=%c+%t"]).unwrap_or_default()
    }
}
