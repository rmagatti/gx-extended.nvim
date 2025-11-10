local M = {}

-- Cache git remote URL per git root to avoid repeated git calls
local remote_cache = {}

local function get_git_remote()
    -- Get git root to use as cache key
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+", "")

    if not git_root or git_root == "" then
        return nil
    end

    -- Check cache
    if remote_cache[git_root] then
        return remote_cache[git_root]
    end

    -- Get git remote URL
    local remote = vim.fn.system("git config --get remote.origin.url")

    if not remote or remote == "" then
        remote_cache[git_root] = false -- Cache negative result
        return nil
    end

    remote = remote:gsub("%s+", "")

    -- Cache the result
    remote_cache[git_root] = remote
    return remote
end

local match_to_url = function(line_string)
    -- Match 7-40 character hex strings (git SHA) with word boundaries, not preceded by '#'
    local sha
    for s in string.gmatch(line_string, "%f[%w]%x%x%x%x%x%x%x+%f[%W]") do
        if #s >= 7 and #s <= 40 then
            -- Check that the match is not preceded by '#'
            local start_pos = line_string:find(s, 1, true)
            if start_pos == 1 or line_string:sub(start_pos - 1, start_pos - 1) ~= "#" then
                sha = s
                break
            end
        end
    end

    if not sha then
        return nil
    end

    -- Get cached git remote URL
    local remote = get_git_remote()

    if not remote then
        return nil
    end

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
