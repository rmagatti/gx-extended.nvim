local M = {}

local match_to_url = function(line_string)
    -- Match PEP 123, PEP-123, or PEP 123 patterns
    local pep = string.match(line_string, "PEP[%s%-]?(%d+)")

    if not pep then
        return nil
    end

    -- Pad with zeros to 4 digits
    pep = string.format("%04d", tonumber(pep))
    local url = "https://peps.python.org/pep-" .. pep .. "/"

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "*" },
        name = "Python PEP",
        match_to_url = match_to_url,
    }
end

return M
