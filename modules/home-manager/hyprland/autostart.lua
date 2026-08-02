o.launch_on_start("hypridle")
o.launch_on_start("mako")
o.launch_on_start("waybar")
o.launch_on_start("fcitx5 --disable notificationitem")
o.exec_on_start("killall -q swaybg 2>/dev/null || true; sleep 0.1; swaybg -i ~/.local/state/nyx/current/background -m fill")
o.exec_on_start("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

o.exec_on_start("systemctl --user import-environment $(env | cut -d'=' -f 1)")
o.exec_on_start("dbus-update-activation-environment --systemd --all")
