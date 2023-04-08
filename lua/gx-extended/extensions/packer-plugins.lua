local M = {}

function M.setup(config)
	local lib = require("gx-extended.lib")
	lib.setup(config)

	lib.register({
		autocmd_pattern = { "plugins.lua" },
		match_to_url = function(line_string)
			local line = string.match(line_string, '[\"|\'].*/.*[\"|\']')
			local repo = vim.split(line, ":")[1]:gsub('"', "")
			local url = "https://github.com/" .. repo

			return url
		end,
	})
end

return M
