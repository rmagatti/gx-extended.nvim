local M = {}

function M.setup(config)
	local lib = require("gx-extended.lib")
	lib.setup(config)

	lib.register({
		autocmd_pattern = { "*" },
		match_to_url = function(line_string)
			local domain, rest = string.match(line_string, '([%w-_]+%.%w+%.?%w*%.?%w*)/?(.*)')
      local url = "https://" .. domain .. "/" .. rest

			return url
		end,
	})
end

return M
