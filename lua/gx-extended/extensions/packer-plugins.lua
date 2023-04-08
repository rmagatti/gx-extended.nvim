local M = {}

function M.setup(config)
	local lib = require("gx-extended.lib")
	lib.setup(config)

	lib.register({
		autocmd_pattern = { "plugins.lua" },
		match_to_url = function(line_string)
			local match = string.match(line_string, '.*/.*')
			local url = "https://github.com/" .. match

			return url
		end,
	})
end

return M
