local M = {}

local match_to_url = function(line_string)
    -- Match 7-40 character hex strings (git SHA)
    local sha = string.match(line_string, "(%x%x%x%x%x%x%x+)")

    if not sha or #sha < 7 or #sha > 40 then
        return nil
    end

    -- Get git remote URL
    local remote = vim.fn.system("git config --get remote.origin.url")

    if not remote or remote == "" then
        return nil
    end

    remote = remote:gsub("%s+", "")

    -- GitHub
    local repo = remote:match("github%.com[:/]([%w._-]+/[%w._-]+)")
    if repo then
        repo = repo:gsub("%.git$", "")
        return "https://github.com/" .. repo .. "/commit/" .. sha
    end

    -- GitLab
    repo = remote:match("gitlab%.com[:/]([%w._-]+/[%w._-]+)")
    if repo then
        repo = repo:gsub("%.git$", "")
        return "https://gitlab.com/" .. repo .. "/-/commit/" .. sha
    end

    -- Bitbucket
    repo = remote:match("bitbucket%.org[:/]([%w._-]+/[%w._-]+)")
    if repo then
        repo = repo:gsub("%.git$", "")
        return "https://bitbucket.org/" .. repo .. "/commits/" .. sha
    end

    return nil
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "*" },
        name = "Git Commit",
        match_to_url = match_to_url,
    }
end

return M
