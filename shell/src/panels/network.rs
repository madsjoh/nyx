// SPDX-License-Identifier: MIT

use super::run;

/// Returns visible Wi-Fi networks as (ssid, signal) pairs, strongest first.
pub fn list() -> Vec<(String, i32)> {
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

pub fn connect(ssid: &str) {
    let _ = run("nmcli", &["dev", "wifi", "connect", ssid]);
}
