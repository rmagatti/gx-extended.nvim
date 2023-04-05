local user_clipboard = nil
local user_register = nil
local user_register_mode = nil

local logger = require("gx-extended.logger"):new({ log_level = vim.log.levels.INFO })

local M = {}

function M.setup(config)
	logger.log_level = config.log_level
end

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

local group = vim.api.nvim_create_augroup("gx-extended", {
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
	local events = options.event or { "BufEnter" }
	local autocmd_pattern = options.autocmd_pattern
	local pattern_to_match = options.pattern_to_match
	local match_to_url = options.match_to_url
	local yank_cmd = options.yank_cmd or 'normal! yi"'

	vim.api.nvim_create_autocmd(events, {
		pattern = autocmd_pattern,
		group = group,
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
          logger.debug("Opening URL: " .. url)
					vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
				end)
			end, {})
		end,
	})
end

function M.register_line(options)
	local events = options.event or { "BufEnter" }
	local autocmd_pattern = options.autocmd_pattern
	local match_to_url = options.match_to_url

	vim.api.nvim_create_autocmd(events, {
		pattern = autocmd_pattern,
		group = group,
		callback = function()
			vim.keymap.set("n", "gx", function()
				local line_string = vim.api.nvim_get_current_line()

				local success, url = pcall(match_to_url, line_string)

				if not url or not success then
					logger.info("Could not match custom gx-extended pattern, calling default gx")

					vim.cmd([[execute "normal \<Plug>NetrwBrowseX"]])
					return
				end

				vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
			end, {})
		end,
	})
end

return M
