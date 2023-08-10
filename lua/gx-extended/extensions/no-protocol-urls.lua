local M = {}

function M.setup(config)
  require("gx-extended.lib").register {
    patterns = { "*" },
    match_to_url = function(line_string)
      local patterns_with_http_s = "(https?://[a-zA-Z0-9_/%-.~@#+=?&%%A-Fa-f]+)"
      local patterns_without_http_s = "([a-zA-Z0-9_/%-.~@#+%%A-Fa-f]+%.[a-zA-Z0-9_/%-.~@#+%%A-Fa-f%=?&]+)"

      local url = string.match(line_string, patterns_with_http_s)

      -- Validate that it starts with a valid-ish domain
      if url and not string.match(url, "https?://%S+%.%S+%.[%w%.]+/?.*") then
        return nil
      end

      if not url then
        url = string.match(line_string, patterns_without_http_s)
        -- Validate that it starts with a valid-ish domain
        if not string.match(url, "%S+%.%S+%.[%w%.]+/?.*") then
          return nil
        end

        if url then
          url = "https://" .. url
        end
      end

      return url
    end,
  }
end

return M
