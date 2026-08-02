local paths = require("hypr.nyx.paths")
local require_all = require("hypr.nyx.require_all")

local toggles_dir = paths.state_home .. "/nyx/toggles/hypr"
package.path = toggles_dir .. "/?.lua;" .. package.path

require_all.files(toggles_dir, nil, { reload = true })
