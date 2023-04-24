local M = {}

local logger = require("gx-extended.logger"):new({ log_level = vim.log.levels.DEBUG })

local match_to_url = function(line_string)
  local line = string.match(line_string, '".*":.*".*"')
  local pkg, _ = vim.split(line, ":")[1]:gsub('"', "")

  local url = "https://www.npmjs.com/package/" .. pkg

  logger.info({ pkg = pkg, line = line, url = url })

  return url
end

function M.setup(config)
  local lib = require("gx-extended.lib")
  lib.setup(config)

  lib.register({
    autocmd_pattern = { "package.json" },
    match_to_url = match_to_url,
  })
end

return M
