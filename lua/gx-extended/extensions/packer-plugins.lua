local M = {}

function M.setup(config)
	local lib = require("gx-extended.lib")
	lib.setup(config)

	lib.register_legacy({
		autocmd_pattern = { "plugins.lua" },
		pattern_to_match = ".*/.*",
		match_to_url = function(yanked_string)
			return "https://github.com/" .. yanked_string
		end,
	})
end

return M
