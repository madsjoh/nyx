// SPDX-License-Identifier: MIT

use chrono::Datelike;

/// Returns (month title, weekday headers, 42 day cells) for the current month.
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
