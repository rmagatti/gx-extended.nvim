local user_clipboard = nil
local user_register = nil
local user_register_mode = nil
local logger = require("gx-extended.logger")

local M = {}

--- Saves the current state of the clipboard and register, and clears the clipboard for later use.
local function snapshot_and_clean()
	user_clipboard = vim.o.clipboard
	user_register = vim.fn.getreg('"')
	user_register_mode = vim.fn.getregtype('"')

	vim.o.clipboard = nil
end

--- Restores the previously saved state of the clipboard and register.
local function restore_snapshot()
	vim.fn.setreg('"', user_register, user_register_mode)
	vim.o.clipboard = user_clipboard
end

--- Runs a function with the clipboard disabled, and restores the previous clipboard state afterwards.
--- @param fn function: The function to run without the clipboard.
--- @return any: The return value of the function.
local function run_bypassing_clipboard(fn)
	snapshot_and_clean()
	local to_return = fn()
	restore_snapshot()

	return to_return
end

local autocmd_group = vim.api.nvim_create_augroup("gx-extended", {
	clear = false,
})

--- @class register_options
--- @field event table | nil: (Optional) The name of the event to attach the autocmd to (e.g. "BufRead"). Defaults to {"BufEnter"}.
--- @field autocmd_pattern string: The pattern to match for the autocmd (e.g. "*.txt").
--- @field pattern_to_match string: The pattern to match in the yanked text (e.g. "^%w+/%w+").
--- @field match_to_url function: The pattern to match in the yanked text (e.g. "^%w+/%w+").
--- @field yank_cmd string: The pattern to match in the yanked text (e.g. "^%w+/%w+").
--- Registers an autocmd that opens GitHub URLs in the netrw file explorer.
--- @param options register_options: A table containing the following keys:
function M.register(options)
	local event = options.event or { "BufEnter" }
	local autocmd_pattern = options.autocmd_pattern
	local pattern_to_match = options.pattern_to_match
	local match_to_url = options.match_to_url
	local yank_cmd = options.yank_cmd or 'normal! yi"'

	vim.api.nvim_create_autocmd(event, {
		pattern = autocmd_pattern,
		group = autocmd_group,
		callback = function()
			vim.keymap.set({ "n", "v" }, "gx", function()
				run_bypassing_clipboard(function()
					vim.cmd(yank_cmd)
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

					local url = match_to_url(yanked_string)
					print(url)
					vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
				end)
			end, {})
		end,
	})
end

return M
