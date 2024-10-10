local M = {}

local match_to_url = function(line_string)
  local line = string.match(line_string, '.*=.*')
  local pkg, _ = vim.split(line, "=")[1]:gsub('"', "")
  -- Trim pkg so no spaces are included
  pkg = pkg:gsub("^%s*(.-)%s*$", "%1")

  if not pkg then
    return nil
  end

  local url = "https://crates.io/crates/" .. pkg

  return url
end

function M.setup(config)
  require("gx-extended.lib").register {
    patterns = { "**/Cargo.toml" },
    name = "crates.io",
    match_to_url = match_to_url,
  }
end

return M
