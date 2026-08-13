{ colors }:
''
add_newline = true
scan_timeout = 10
format = "$directory$git_branch$git_status$character"
right_format = "$cmd_duration$status$time"

[character]
success_symbol = "[❯](bold ${colors.color2})"
error_symbol = "[❯](bold ${colors.color1})"

[directory]
style = "${colors.accent}"
truncation_length = 3

[git_branch]
symbol = " "
style = "${colors.color13}"

[git_status]
style = "${colors.color3}"

[cmd_duration]
style = "${colors.color8}"

[status]
symbol = "✖"
style = "bold ${colors.color1}"

[time]
disabled = false
style = "${colors.color8}"
format = "[$time]($style)"
''
