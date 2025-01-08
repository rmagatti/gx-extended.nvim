local M = {}

local match_to_url = function(line_string)
  -- PyPA package naming convention: 
  -- https://packaging.python.org/en/latest/specifications/name-normalization/#name-format
  local pkg = string.match(line_string, '[%w][%w._-]*[%w]')
  if not pkg then
    return nil
  end

  local url = "https://pypi.org/project/" .. pkg

  return url
end

function M.setup(config)
  require("gx-extended.lib").register {
    patterns = { "**/Pipfile", "**/requirements.txt" },
    name = "pypi.org",
    match_to_url = match_to_url,
  }
end

return M
