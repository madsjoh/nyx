use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "kebab-case", default)]
pub struct Config {
    pub bar: BarConfig,
    pub launcher: LauncherConfig,
    pub panel: PanelConfig,
    pub colors: Colors,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "kebab-case", default)]
pub struct BarConfig {
    pub height: i32,
    pub corner_radius: i32,
    pub spacing: i32,
    pub text_size: i32,
    pub font_family: String,
    pub logo: String,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "kebab-case", default)]
pub struct LauncherConfig {
    pub width: i32,
    pub corner_radius: i32,
    pub text_size: i32,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "kebab-case", default)]
pub struct PanelConfig {
    pub width: i32,
    pub corner_radius: i32,
    pub text_size: i32,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "kebab-case")]
#[allow(dead_code)]
pub struct Colors {
    pub accent: String,
    pub cursor: String,
    pub foreground: String,
    pub background: String,
    pub selection_foreground: String,
    pub selection_background: String,
    pub color0: String,
    pub color1: String,
    pub color2: String,
    pub color3: String,
    pub color4: String,
    pub color5: String,
    pub color6: String,
    pub color7: String,
    pub color8: String,
    pub color9: String,
    pub color10: String,
    pub color11: String,
    pub color12: String,
    pub color13: String,
    pub color14: String,
    pub color15: String,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            bar: BarConfig::default(),
            launcher: LauncherConfig::default(),
            panel: PanelConfig::default(),
            colors: Colors {
                accent: "#7aa2f7".into(),
                cursor: "#c0caf5".into(),
                foreground: "#a9b1d6".into(),
                background: "#1a1b26".into(),
                selection_foreground: "#c0caf5".into(),
                selection_background: "#7aa2f7".into(),
                color0: "#32344a".into(),
                color1: "#f7768e".into(),
                color2: "#9ece6a".into(),
                color3: "#e0af68".into(),
                color4: "#7aa2f7".into(),
                color5: "#ad8ee6".into(),
                color6: "#449dab".into(),
                color7: "#787c99".into(),
                color8: "#444b6a".into(),
                color9: "#ff7a93".into(),
                color10: "#b9f27c".into(),
                color11: "#ff9e64".into(),
                color12: "#7da6ff".into(),
                color13: "#bb9af7".into(),
                color14: "#0db9d7".into(),
                color15: "#acb0d0".into(),
            },
        }
    }
}

impl Default for BarConfig {
    fn default() -> Self {
        Self {
            height: 26,
            corner_radius: 0,
            spacing: 8,
            text_size: 12,
            font_family: "JetBrainsMono Nerd Font".into(),
            logo: "\u{ef86}".into(),
        }
    }
}

impl Default for LauncherConfig {
    fn default() -> Self {
        Self {
            width: 640,
            corner_radius: 12,
            text_size: 16,
        }
    }
}

impl Default for PanelConfig {
    fn default() -> Self {
        Self {
            width: 380,
            corner_radius: 12,
            text_size: 13,
        }
    }
}

impl Config {
    pub fn load() -> Config {
        let path = std::env::var("NYX_SHELL_CONFIG")
            .unwrap_or_else(|_| format!("{}/.config/nyx/shell.json", home_dir()));

        match std::fs::read_to_string(&path) {
            Ok(text) => serde_json::from_str(&text).unwrap_or_else(|err| {
                log::warn!("failed to parse config {path}: {err}; using defaults");
                Config::default()
            }),
            Err(err) => {
                log::warn!("could not read config {path}: {err}; using defaults");
                Config::default()
            }
        }
    }

    pub fn color(&self, hex: &str) -> slint::Color {
        let hex = hex.trim_start_matches('#');
        let value = u32::from_str_radix(hex, 16).unwrap_or(0xffffff);
        let (r, g, b) = ((value >> 16) as u8, (value >> 8) as u8, value as u8);
        slint::Color::from_rgb_u8(r, g, b)
    }
}

fn home_dir() -> String {
    std::env::var("HOME").unwrap_or_else(|_| "/tmp".into())
}
