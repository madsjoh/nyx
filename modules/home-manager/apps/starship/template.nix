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
$bun\
$c\
$cmake\
$cobol\
$conda\
$cpp\
$crystal\
$dart\
$dotnet\
$elixir\
$elm\
$erlang\
$fennel\
$fortran\
$gleam\
$golang\
$gradle\
$haskell\
$haxe\
$helm\
$java\
$julia\
$kotlin\
$lua\
$maven\
$meson\
$mojo\
$nim\
$nodejs\
$ocaml\
$odin\
$perl\
$php\
$pixi\
$pulumi\
$purescript\
$python\
$raku\
$red\
$rlang\
$ruby\
$rust\
$scala\
$solidity\
$spack\
$swift\
$typst\
$vlang\
$xmake\
$zig\
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

[bun]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[c]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[cmake]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[cobol]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[conda]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[cpp]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[crystal]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[dart]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[dotnet]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[elixir]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[elm]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[erlang]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[fennel]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[fortran]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[gleam]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[golang]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[gradle]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[haskell]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[haxe]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[helm]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[java]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[julia]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[kotlin]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[lua]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[maven]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[meson]
symbol = "󰔷"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[mojo]
symbol = "󰈸"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[nim]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[nodejs]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[ocaml]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[odin]
symbol = "󰟢"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[perl]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[php]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[pixi]
symbol = "󰏗"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[pulumi]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[purescript]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[python]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[raku]
symbol = "󱖊"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[red]
symbol = "󱍼"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[rlang]
symbol = "󰟔"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[ruby]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[rust]
symbol = "󱘗"
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[scala]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[solidity]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[spack]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[swift]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[typst]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[vlang]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[xmake]
symbol = ""
style = "bg:${colors.color0}"
format = '[[ $symbol ($version) ](fg:${colors.accent} bg:${colors.color0})]($style)'

[zig]
symbol = ""
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
