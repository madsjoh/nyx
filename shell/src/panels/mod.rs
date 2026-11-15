// SPDX-License-Identifier: MIT

pub mod audio;
pub mod clock;
pub mod network;
pub mod power;
pub mod weather;

use std::process::Command;

/// Which overlay panel a bar widget toggles.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PanelKind {
    Clock,
    Weather,
    Network,
    Audio,
    Power,
}

/// Run a shell command and return its trimmed standard output on success.
pub(crate) fn run(cmd: &str, args: &[&str]) -> Option<String> {
    let out = Command::new(cmd).args(args).output().ok()?;
    if out.status.success() {
        Some(String::from_utf8_lossy(&out.stdout).trim().to_string())
    } else {
        None
    }
}
