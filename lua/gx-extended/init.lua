local lib = require("gx-extended.lib")

local M = {
	config = {},
}

--- @class setup_options
--- @param config setup_options
function M.setup(config)
	M.config = vim.tbl_deep_extend("force", M.config, config or {})

	-- packer.nvim's plugins.lua support
	lib.register({
		autocmd_pattern = { "plugins.lua" },
		pattern_to_match = ".*/.*",
		match_to_url = function(yanked_string)
			return "https://github.com/" .. yanked_string
		end,
	})
end

M.register = lib.register

return M
