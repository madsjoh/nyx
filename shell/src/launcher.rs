use std::path::PathBuf;
use std::process::Command;

#[derive(Debug, Clone)]
pub struct App {
    pub name: String,
    pub exec: String,
}

impl App {
    fn matches(&self, query: &str) -> bool {
        let query = query.to_lowercase();
        self.name.to_lowercase().contains(&query)
    }
}

fn data_dirs() -> Vec<PathBuf> {
    let mut dirs = Vec::new();

    if let Some(home) = std::env::var_os("HOME") {
        dirs.push(PathBuf::from(home).join(".local/share/applications"));
    }

    let xdg = std::env::var("XDG_DATA_DIRS")
        .unwrap_or_else(|_| "/usr/local/share:/usr/share".to_string());
    for dir in xdg.split(':').filter(|d| !d.is_empty()) {
        dirs.push(PathBuf::from(dir).join("applications"));
    }

    dirs
}

fn parse_desktop(path: &std::path::Path) -> Option<App> {
    let content = std::fs::read_to_string(path).ok()?;

    let mut in_entry = false;
    let mut name: Option<String> = None;
    let mut exec: Option<String> = None;
    let mut hidden = false;
    let mut no_display = false;

    for line in content.lines() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        if let Some(key) = line.strip_prefix('[') {
            in_entry = key.starts_with("Desktop Entry");
            continue;
        }
        if !in_entry {
            continue;
        }
        if let Some((key, value)) = line.split_once('=') {
            match key {
                "Name" => name = Some(value.to_string()),
                "Exec" => exec = Some(value.to_string()),
                "Hidden" => hidden = value.eq_ignore_ascii_case("true"),
                "NoDisplay" => no_display = value.eq_ignore_ascii_case("true"),
                _ => {}
            }
        }
    }

    if hidden || no_display {
        return None;
    }
    let name = name.filter(|n| !n.is_empty())?;
    let exec = exec.filter(|e| !e.is_empty())?;

    Some(App { name, exec })
}

pub fn load_apps() -> Vec<App> {
    let mut apps = Vec::new();
    for dir in data_dirs() {
        let Ok(entries) = std::fs::read_dir(&dir) else {
            continue;
        };
        for entry in entries.flatten() {
            let path = entry.path();
            if path.extension().map(|e| e == "desktop").unwrap_or(false) {
                if let Some(app) = parse_desktop(&path) {
                    if !apps.iter().any(|existing: &App| existing.name == app.name) {
                        apps.push(app);
                    }
                }
            }
        }
    }
    apps.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));
    apps
}

pub fn search<'a>(apps: &'a [App], query: &str) -> Vec<&'a App> {
    let query = query.trim();
    if query.is_empty() {
        return apps.iter().take(64).collect();
    }
    apps.iter().filter(|app| app.matches(query)).take(64).collect()
}

fn strip_field_codes(exec: &str) -> String {
    let mut out = String::with_capacity(exec.len());
    let mut chars = exec.chars().peekable();
    while let Some(ch) = chars.next() {
        if ch == '%' {
            // Skip the field code character (e.g. %f, %u, %i, %c, %k).
            chars.next();
            continue;
        }
        out.push(ch);
    }
    out
}

pub fn launch(app: &App) {
    let command = strip_field_codes(&app.exec);
    let _ = Command::new("sh").arg("-c").arg(command).spawn();
}

/// Requests forwarded from Slint callbacks to the event loop.
#[derive(Default)]
pub struct Commands {
    pub show_launcher: bool,
    pub activate: Option<usize>,
}

