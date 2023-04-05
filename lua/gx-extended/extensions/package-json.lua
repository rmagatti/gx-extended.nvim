local M = {}

function M.setup(config)
	local lib = require("gx-extended.lib")
	lib.setup(config)

	lib.register_line({
		autocmd_pattern = { "package.json" },
		match_to_url = function(line_string)
			local line = string.match(line_string, '".*":.*".*"')
			local pkg = vim.split(line, ":")[1]:gsub('"', "")
			local url = pkg and "https://www.npmjs.com/package/" .. pkg or nil

			return url
		end,
	})
end

return M
