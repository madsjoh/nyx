-- App-specific tweaks.
local paths = require("hypr.nyx.paths")
local require_all = require("hypr.nyx.require_all")

require_all.files(paths.config_home .. "/hypr/nyx/apps", "hypr.nyx.apps")
