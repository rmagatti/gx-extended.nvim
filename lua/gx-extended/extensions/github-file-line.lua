local M = {}

local match_to_url = function(line_string)
    -- This extension works differently - it doesn't match on line content
    -- Instead, it always returns a URL if we're in a git repo

    -- Check if we're in a git repository
    local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true")
    if not is_git_repo then
        return nil
    end

    -- Get the git remote URL
    local remote = vim.fn.system("git config --get remote.origin.url 2>/dev/null")
    if not remote or remote == "" then
        return nil
    end

    remote = remote:gsub("%s+", "")

    -- Get current file path relative to git root
    local filepath = vim.fn.expand("%:p")
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+", "")

    if not git_root or git_root == "" then
        return nil
    end

    -- Calculate relative path
    local relative_path = filepath:gsub("^" .. vim.pesc(git_root) .. "/", "")

    -- Get current line number
    local line_number = vim.api.nvim_win_get_cursor(0)[1]

    -- Get current branch
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("%s+", "")
    if not branch or branch == "" then
        branch = "main" -- fallback
    end

    -- Parse different git remote formats
    local org, repo

    -- GitHub/GitLab/Bitbucket patterns
    -- SSH: git@github.com:user/repo.git
    org, repo = remote:match("git@[^:]+:([^/]+)/(.+)")

    if not org then
        -- HTTPS: https://github.com/user/repo.git
        org, repo = remote:match("https?://[^/]+/([^/]+)/(.+)")
    end

    if not org or not repo then
        return nil
    end

    -- Remove .git suffix
    repo = repo:gsub("%.git$", "")

    -- Construct URL based on platform
    local url

    if remote:match("github%.com") then
        url = string.format("https://github.com/%s/%s/blob/%s/%s#L%d",
            org, repo, branch, relative_path, line_number)
    elseif remote:match("gitlab%.com") then
        url = string.format("https://gitlab.com/%s/%s/-/blob/%s/%s#L%d",
            org, repo, branch, relative_path, line_number)
    elseif remote:match("bitbucket%.org") then
        url = string.format("https://bitbucket.org/%s/%s/src/%s/%s#lines-%d",
            org, repo, branch, relative_path, line_number)
    else
        return nil
    end

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "*" },
        name = "GitHub File Line Permalink",
        match_to_url = match_to_url,
    }
end

return M
