local M = {}

function M.setup(config)
	require("gx-extended.lib").register({
		autocmd_pattern = { "*" },
		match_to_url = function(line_string)
			local pattern_with_http_s = "(https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)"
			local pattern_without_http_s = "([a-zA-Z0-9_/%-%.~@\\+#]+%.[a-zA-Z0-9_/%-%.~@\\+#%=?&]+)"

			local url = string.match(line_string, pattern_with_http_s)

			-- Validate that it starts with a valid-ish domain
			if url and not string.match(url, "https?://%S+%.%S+%.[%w%.]+/?.*") then
				return nil
			end

			if not url then
				url = string.match(line_string, pattern_without_http_s)
				-- Validate that it starts with a valid-ish domain
				if not string.match(url, "%S+%.%S+%.[%w%.]+/?.*") then
					return nil
				end

				if url then
					url = "https://" .. url
				end
			end

			return url
		end,
	})
end

return M
