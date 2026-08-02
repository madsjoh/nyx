-- Shared helpers for Nyx Hyprland Lua configuration.

o = o or {}

local function shell_quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function command_from(value, description)
  if type(value) ~= "table" then
    return value
  end

  if value.focus and value.launch then
    return o.launch_sole(value.focus, value.launch)
  elseif value.launch then
    return o.launch(value.launch)
  end

  return value
end

function o.bind(keys, description, dispatcher, options)
  local opts = options or {}

  if description then
    opts.description = description
  end

  dispatcher = command_from(dispatcher, description)

  if type(dispatcher) == "string" then
    dispatcher = hl.dsp.exec_cmd(dispatcher)
  end

  hl.bind(keys, dispatcher, opts)
end

function o.launch(command)
  return "uwsm-app -- " .. command
end

function o.exec_on_start(command)
  hl.on("hyprland.start", function()
    hl.exec_cmd(command)
  end)
end

function o.launch_on_start(command)
  o.exec_on_start(o.launch(command))
end

function o.launch_sole(match, command)
  return "hyprctl dispatch exec '" .. shell_quote(o.launch(command)) .. "' && hyprctl dispatch focuswindow " .. shell_quote(match)
end

function o.bind_toggle(keys, description, toggle, options)
  local paths = require("hypr.nyx.paths")
  local toggle_cmd = "nyx-toggle-run " .. toggle
  o.bind(keys, description, toggle_cmd, options)
end

function o.notify(message)
  return "notify-send -u low " .. shell_quote(message)
end

function o.window(match, rules)
  rules.match = rules.match or {}

  if type(match) == "string" then
    rules.match.class = match
  else
    for key, value in pairs(match) do
      rules.match[key] = value
    end
  end

  hl.window_rule(rules)
end

function o.cycle_background()
  local paths = require("hypr.nyx.paths")
  local bg_dir = paths.state_home .. "/nyx/current/backgrounds"
  local bg_link = paths.state_home .. "/nyx/current/background"

  local handle = io.popen("ls \"" .. bg_dir .. "\" | sort -R | head -1")
  if not handle then return end
  local bg = handle:read("*l")
  handle:close()
  if not bg or bg == "" then return end

  hl.exec_cmd("ln -sfn \"" .. bg_dir .. "/" .. bg .. "\" \"" .. bg_link .. "\"")
  hl.exec_cmd("pkill swaybg 2>/dev/null")
  hl.exec_cmd("swaybg -i \"" .. bg_link .. "\" -m fill &")
end
