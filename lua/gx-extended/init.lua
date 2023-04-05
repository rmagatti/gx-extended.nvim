local M = {
	config = {
		log_level = vim.log.levels.INFO,
	},
}

--- @class setup_options
--- @param config setup_options
function M.setup(config)
	M.config = vim.tbl_deep_extend("force", M.config, config or {})
	local lib = require("gx-extended.lib")
	lib.setup(config)

  --- Setup builtin extensions
	require("gx-extended.extensions.package-json").setup(config)
	require("gx-extended.extensions.packer-plugins").setup(config)

	M.register = lib.register
end

return M
