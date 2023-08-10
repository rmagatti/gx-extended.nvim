local M = {
  config = {
    log_level = vim.log.levels.INFO,
    extensions = {},
    legacy_extensions = {},
  },
}

function M.setup(config)
  --- Merge the user-provided configuration with the default configuration.
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
  local lib = require("gx-extended.lib")
  lib.setup(M.config)

  --- Setup builtin extensions
  require("gx-extended.extensions.package-json").setup(config)
  require("gx-extended.extensions.packer-plugins").setup(config)
  require("gx-extended.extensions.terraform-aws-resources").setup(config)
  require("gx-extended.extensions.no-protocol-urls").setup(config)

  --- Setup user extensions
  require("gx-extended.extensions.user-extensions").setup(config)

  --- Expose the register function from gx-extended.lib.
  M.register = lib.register
end

return M
