{ colors }:
''
add_newline = true
scan_timeout = 10

format = """
[░▒▓](${colors.color15})\
$os\
[](bg:${colors.accent} fg:${colors.color15})\
$directory\
[](fg:${colors.accent} bg:${colors.color8})\
$git_branch\
$git_status\
[](fg:${colors.color8} bg:${colors.color0})\
$nodejs\
$bun\
$rust\
$golang\
$php\
[](fg:${colors.color0} bg:${colors.background})\
$time\
[ ](fg:${colors.background})\
\n$character"""

right_format = "$status"

[character]
success_symbol = "[❯](bold ${colors.color2})"
error_symbol = "[❯](bold ${colors.color1})"

[directory]
style = "fg:${colors.color15} bg:${colors.accent}"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:${colors.color8}"
format = '[[ $symbol $branch ](fg:${colors.accent} bg:${colors.color8})]($style)'

[git_status]
style = "bg:${colors.color8}"
format = '[[($all_status$ahead_behind )](fg:${colors.accent} bg:${colors.color8})]($style)'

[nodejs]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[bun]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[rust]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[golang]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[php]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[time]
disabled = false
time_format = "%R"
style = "bg:${colors.background}"
format = '[[  $time ](fg:${colors.color15} bg:${colors.background})]($style)'

[os]
style = "bg:${colors.color15} fg:${colors.background}"
format = "[ $symbol ]($style)"
disabled = false

[os.symbols]
NixOS = ""

[status]
symbol = " "
style = "bold ${colors.color1}"
''
