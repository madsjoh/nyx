{ colors }:
''
# Main background, empty for terminal default, need to be empty if you want transparent background
theme[main_bg]="${colors.background}"

# Main text color
theme[main_fg]="${colors.foreground}"

# Title color for boxes
theme[title]="${colors.foreground}"

# Highlight color for keyboard shortcuts
theme[hi_fg]="${colors.accent}"

# Background color of selected item in processes box
theme[selected_bg]="${colors.color8}"

# Foreground color of selected item in processes box
theme[selected_fg]="${colors.accent}"

# Color of inactive/disabled text
theme[inactive_fg]="${colors.color8}"

# Color of text appearing on top of graphs, i.e uptime and current network graph scaling
theme[graph_text]="${colors.foreground}"

# Background color of the percentage meters
theme[meter_bg]="${colors.color8}"

# Misc colors for processes box including mini cpu graphs, details memory graph and details status text
theme[proc_misc]="${colors.foreground}"

# CPU, Memory, Network, Proc box outline colors
theme[cpu_box]="${colors.color5}"
theme[mem_box]="${colors.color2}"
theme[net_box]="${colors.color1}"
theme[proc_box]="${colors.accent}"

# Box divider line and small boxes line color
theme[div_line]="${colors.color8}"

# Temperature graph color (Green -> Yellow -> Red)
theme[temp_start]="${colors.color2}"
theme[temp_mid]="${colors.color3}"
theme[temp_end]="${colors.color1}"

# CPU graph colors (Teal -> Lavender)
theme[cpu_start]="${colors.color6}"
theme[cpu_mid]="${colors.color4}"
theme[cpu_end]="${colors.color5}"

# Mem/Disk free meter (Mauve -> Lavender -> Blue)
theme[free_start]="${colors.color5}"
theme[free_mid]="${colors.color4}"
theme[free_end]="${colors.color6}"

# Mem/Disk cached meter (Sapphire -> Lavender)
theme[cached_start]="${colors.color4}"
theme[cached_mid]="${colors.color6}"
theme[cached_end]="${colors.color5}"

# Mem/Disk available meter (Peach -> Red)
theme[available_start]="${colors.color3}"
theme[available_mid]="${colors.color1}"
theme[available_end]="${colors.color1}"

# Mem/Disk used meter (Green -> Sky)
theme[used_start]="${colors.color2}"
theme[used_mid]="${colors.color6}"
theme[used_end]="${colors.color4}"

# Download graph colors (Peach -> Red)
theme[download_start]="${colors.color3}"
theme[download_mid]="${colors.color1}"
theme[download_end]="${colors.color1}"

# Upload graph colors (Green -> Sky)
theme[upload_start]="${colors.color2}"
theme[upload_mid]="${colors.color6}"
theme[upload_end]="${colors.color4}"

# Process box color gradient for threads, mem and cpu usage (Sapphire -> Mauve)
theme[process_start]="${colors.color6}"
theme[process_mid]="${colors.color4}"
theme[process_end]="${colors.color5}"
''
