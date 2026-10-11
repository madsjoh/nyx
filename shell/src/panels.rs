use std::process::Command;

use chrono::Datelike;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PanelKind {
    Clock,
    Weather,
    Network,
    Audio,
    Power,
}

fn run(cmd: &str, args: &[&str]) -> Option<String> {
    let out = Command::new(cmd).args(args).output().ok()?;
    if out.status.success() {
        Some(String::from_utf8_lossy(&out.stdout).trim().to_string())
    } else {
        None
    }
}

/// Returns (title, weekdays, 42 day cells) for the current month.
pub fn calendar() -> (String, Vec<String>, Vec<String>) {
    let now = chrono::Local::now();
    let title = now.format("%B %Y").to_string();
    let weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
        .iter()
        .map(|s| s.to_string())
        .collect();

    let first = now.date_naive().with_day(1).unwrap();
    let offset = first.weekday().num_days_from_monday() as usize;
    let days_in_month = days_in_month(now.year(), now.month());

    let mut cells = vec![String::new(); 42];
    for day in 1..=days_in_month {
        cells[offset + (day as usize) - 1] = day.to_string();
    }
    (title, weekdays, cells)
}

fn days_in_month(year: i32, month: u32) -> u32 {
    match month {
        1 | 3 | 5 | 7 | 8 | 10 | 12 => 31,
        4 | 6 | 9 | 11 => 30,
        2 => {
            if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
                29
            } else {
                28
            }
        }
        _ => 30,
    }
}

pub fn weather() -> (String, String, Vec<String>) {
    let location = run("curl", &["-fsS", "--max-time", "5", "wttr.in/?format=%l"])
        .unwrap_or_default();
    let current = run("curl", &["-fsS", "--max-time", "5", "wttr.in/?format=%c+%t"])
        .unwrap_or_default();
    (location, current, Vec::new())
}

pub fn networks() -> Vec<(String, i32)> {
    let Some(raw) = run("nmcli", &["-t", "-f", "ssid,signal", "dev", "wifi", "list"]) else {
        return Vec::new();
    };
    let mut result: Vec<(String, i32)> = raw
        .lines()
        .filter_map(|line| {
            let mut parts = line.split(':');
            let ssid = parts.next()?.to_string();
            let signal = parts.next().unwrap_or("0").parse::<i32>().ok()?;
            if ssid.is_empty() {
                None
            } else {
                Some((ssid, signal))
            }
        })
        .collect();
    result.sort_by(|a, b| b.1.cmp(&a.1));
    result.truncate(15);
    result
}

pub fn connect_wifi(ssid: &str) {
    let _ = run("nmcli", &["dev", "wifi", "connect", ssid]);
}

pub fn audio_state() -> (i32, bool) {
    let volume = run("wpctl", &["get-volume", "@DEFAULT_AUDIO_SINK@"])
        .and_then(|s| {
            s.split_whitespace()
                .last()
                .and_then(|v| v.parse::<f32>().ok())
        })
        .map(|v| (v * 100.0).round() as i32)
        .unwrap_or(0);
    let muted = run("wpctl", &["get-mute", "@DEFAULT_AUDIO_SINK@"])
        .map(|s| s == "Muted")
        .unwrap_or(false);
    (volume, muted)
}

pub fn set_volume(volume: i32) {
    let _ = run("wpctl", &["set-volume", "@DEFAULT_AUDIO_SINK@", &format!("{}%", volume)]);
}

pub fn toggle_mute() {
    let _ = run("wpctl", &["set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
}

pub fn battery_info() -> String {
    let entries = match std::fs::read_dir("/sys/class/power_supply") {
        Ok(entries) => entries,
        Err(_) => return String::new(),
    };
    let mut batteries: Vec<_> = entries
        .flatten()
        .map(|e| e.path())
        .filter(|p| {
            p.file_name()
                .and_then(|n| n.to_str())
                .map(|n| n.starts_with("BAT"))
                .unwrap_or(false)
        })
        .collect();
    batteries.sort();
    let Some(battery) = batteries.first() else {
        return "No battery".to_string();
    };
    let capacity = std::fs::read_to_string(battery.join("capacity"))
        .ok()
        .and_then(|s| s.trim().parse::<i32>().ok())
        .unwrap_or(0);
    let status = std::fs::read_to_string(battery.join("status"))
        .map(|s| s.trim().to_string())
        .unwrap_or_default();
    format!("Battery {capacity}% ({status})")
}

pub fn run_power_action(action: &str) {
    let (cmd, args): (&str, &[&str]) = match action {
        "lock" => ("loginctl", &["lock-session"]),
        "logout" => ("hyprctl", &["dispatch", "exit"]),
        "suspend" => ("systemctl", &["suspend"]),
        "reboot" => ("systemctl", &["reboot"]),
        "shutdown" => ("systemctl", &["poweroff"]),
        _ => return,
    };
    let _ = Command::new(cmd).args(args).spawn();
}
