local M = {}

local match_to_url = function(line_string)
    -- Match CVE-YYYY-NNNNN pattern
    local cve = string.match(line_string, "(CVE%-%d%d%d%d%-%d+)")

    if not cve or #cve > 20 then
        return nil
    end

    local url = "https://nvd.nist.gov/vuln/detail/" .. cve

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "*" },
        name = "CVE Database",
        match_to_url = match_to_url,
    }
end

return M
