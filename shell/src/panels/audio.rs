// SPDX-License-Identifier: MIT

use super::run;

/// Returns the current output volume as a percentage and mute state.
pub fn state() -> (i32, bool) {
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
