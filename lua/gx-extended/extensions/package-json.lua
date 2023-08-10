local M = {}

local match_to_url = function(line_string)
  local line = string.match(line_string, '".*":.*".*"')
  local pkg, _ = vim.split(line, ":")[1]:gsub('"', "")

  if not pkg then
    return nil
  end

  local url = "https://www.npmjs.com/package/" .. pkg

  return url
end

function M.setup(config)
  require("gx-extended.lib").register {
    patterns = { "*package.json" },
    match_to_url = match_to_url,
  }
end

return M
