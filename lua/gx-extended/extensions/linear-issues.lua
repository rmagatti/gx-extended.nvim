local M = {}

local match_to_url = function(line_string)
    -- Match Linear issue pattern: TEAM-123
    -- Pattern: One or more uppercase letters, dash, one or more digits
    local issue = string.match(line_string, "([A-Z][A-Z0-9]*%-%d+)")

    if not issue or #issue > 20 then
        return nil
    end

    -- Get Linear team from config
    -- Priority: vim.g.gx_linear_team > LINEAR_TEAM env var
    local linear_team = vim.g.gx_linear_team or os.getenv("LINEAR_TEAM")

    if not linear_team then
        return nil
    end

    -- Remove any trailing slashes
    linear_team = linear_team:gsub("/$", "")

    -- If it's a full URL, use it directly, otherwise construct the URL
    local url
    if linear_team:match("^https?://") then
        url = linear_team .. "/issue/" .. issue
    else
        url = "https://linear.app/" .. linear_team .. "/issue/" .. issue
    end

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "*" },
        name = "Linear Issues",
        match_to_url = match_to_url,
    }
end

return M
