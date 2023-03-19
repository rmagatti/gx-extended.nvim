local user_clipboard = nil
local user_register = nil
local user_register_mode = nil

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
function M.run_bypassing_clipboard(fn)
	snapshot_and_clean()
	local to_return = fn()
	restore_snapshot()

	return to_return
end

M.autocmd_group = vim.api.nvim_create_augroup("gx-extended", {
	clear = false,
})

return M
