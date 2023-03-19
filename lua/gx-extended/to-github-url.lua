local lib = require("gx-extended.lib")
local logger = require("gx-extended.logger")

local M = {}

--- @class register_options
--- @field event table | nil: (Optional) The name of the event to attach the autocmd to (e.g. "BufRead"). Defaults to {"BufEnter"}.
--- @field autocmd_pattern string: The pattern to match for the autocmd (e.g. "*.txt").
--- @field pattern_to_match string: The pattern to match in the yanked text (e.g. "^%w+/%w+").
--- Registers an autocmd that opens GitHub URLs in the netrw file explorer.
--- @param options register_options: A table containing the following keys:
function M.register(options)
	local event = options.event or { "BufEnter" }
	local autocmd_pattern = options.autocmd_pattern
	local pattern_to_match = options.pattern_to_match

	vim.api.nvim_create_autocmd(event, {
		pattern = autocmd_pattern,
		group = lib.autocmd_group,
		callback = function()
			vim.keymap.set("n", "gx", function()
				lib.run_bypassing_clipboard(function()
					vim.cmd([[normal! yi"]])
					local yanked_string = vim.fn.getreg('"')

					-- This condition handles the case where the right pattern is not found
					if not string.match(yanked_string, pattern_to_match) then
						local line_string = vim.api.nvim_get_current_line()
						-- Not a great match, but it's good enough for now
						local match = line_string:match("(https?%S+)")

						if not match then
							logger.info("No URL found on current line")
							return
						end

						vim.api.nvim_call_function("netrw#BrowseX", { match, 0 })

						return
					end

					local github_url = "https://github.com/" .. yanked_string
					vim.api.nvim_call_function("netrw#BrowseX", { github_url, 0 })
				end)
			end, {})
		end,
	})
end

return M
