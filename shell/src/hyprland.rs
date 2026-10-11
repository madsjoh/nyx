use std::io::{Read, Write};
use std::os::unix::net::UnixStream;

/// Minimal Hyprland IPC client over the command socket.
pub struct Hyprland {
    socket: String,
}

impl Hyprland {
    pub fn connect() -> Option<Self> {
        let signature = std::env::var("HYPRLAND_INSTANCE_SIGNATURE").ok()?;
        let runtime = std::env::var("XDG_RUNTIME_DIR").unwrap_or_else(|_| "/tmp".into());
        Some(Self {
            socket: format!("{runtime}/hypr/{signature}/.socket.sock"),
        })
    }

    fn request(&self, command: &str) -> Option<String> {
        let mut stream = UnixStream::connect(&self.socket).ok()?;
        stream.write_all(command.as_bytes()).ok()?;
        let mut buf = String::new();
        stream.read_to_string(&mut buf).ok()?;
        Some(buf)
    }

    /// Returns sorted workspace ids and the active workspace id.
    pub fn workspaces(&self) -> Option<(Vec<i64>, i64)> {
        let raw = self.request("j/workspaces")?;
        let workspaces: serde_json::Value = serde_json::from_str(&raw).ok()?;
        let mut ids = Vec::new();
        for workspace in workspaces.as_array()? {
            if let Some(id) = workspace.get("id").and_then(|v| v.as_i64()) {
                if id > 0 {
                    ids.push(id);
                }
            }
        }
        ids.sort_unstable();

        let active = self
            .request("j/activeworkspace")
            .and_then(|s| serde_json::from_str::<serde_json::Value>(&s).ok())
            .and_then(|v| v.get("id").and_then(|id| id.as_i64()))
            .unwrap_or(-1);

        Some((ids, active))
    }
}

pub fn format_workspaces(ids: &[i64], active: i64) -> String {
    ids.iter()
        .map(|id| {
            if *id == active {
                format!("[{id}]")
            } else {
                id.to_string()
            }
        })
        .collect::<Vec<_>>()
        .join(" ")
}
