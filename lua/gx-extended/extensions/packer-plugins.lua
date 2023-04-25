local M = {}

function M.setup(config)
	require("gx-extended.lib").register({
		patterns = { "plugins.lua" },
		match_to_url = function(line_string)
			local line = string.match(line_string, "[\"|'].*/.*[\"|']")
			local repo = vim.split(line, ":")[1]:gsub('"', "")
			local url = "https://github.com/" .. repo

			if not line or not repo then
				return nil
			end

			return url
		end,
	})
end

return M
