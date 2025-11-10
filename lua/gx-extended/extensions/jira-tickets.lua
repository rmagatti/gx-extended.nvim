local M = {}

local match_to_url = function(line_string)
    -- Match Jira ticket pattern: PROJECT-123
    -- Pattern: At least 2 uppercase letters/digits, dash, one or more digits
    local ticket = string.match(line_string, "([A-Z][A-Z0-9]+%-%d+)")

    if not ticket or #ticket > 20 then
        return nil
    end

    -- Get Jira URL from config
    -- Priority: vim.g.gx_jira_url > JIRA_URL env var
    local jira_url = vim.g.gx_jira_url or os.getenv("JIRA_URL")

    if not jira_url then
        return nil
    end

    -- Remove trailing slash if present
    jira_url = jira_url:gsub("/$", "")

    local url = jira_url .. "/browse/" .. ticket

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "*" },
        name = "Jira Tickets",
        match_to_url = match_to_url,
    }
end

return M
