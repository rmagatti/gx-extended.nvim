local M = {}

function M.setup(config)
	local lib = require("gx-extended.lib")
	lib.setup(config)

	lib.register({
		autocmd_pattern = { "package.json" },
		match_to_url = function(line_string)
			local line = string.match(line_string, '".*":.*".*"')
			local pkg = vim.split(line, ":")[1]:gsub('"', "")
			local url = "https://www.npmjs.com/package/" .. pkg

			return url
		end,
	})
end

return M
