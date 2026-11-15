// SPDX-License-Identifier: MIT

use std::process::Command;

/// Returns a human-readable battery summary.
pub fn battery() -> String {
    let Ok(entries) = std::fs::read_dir("/sys/class/power_supply") else {
        return String::new();
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

pub fn run_action(action: &str) {
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
