// SPDX-License-Identifier: MIT

use super::run;

/// Returns (location, current conditions, forecast rows) from wttr.in.
pub fn report() -> (String, String, Vec<String>) {
    let location = run("curl", &["-fsS", "--max-time", "5", "wttr.in/?format=%l"])
        .unwrap_or_default();
    let current = run("curl", &["-fsS", "--max-time", "5", "wttr.in/?format=%c+%t"])
        .unwrap_or_default();
    (location, current, Vec::new())
}
