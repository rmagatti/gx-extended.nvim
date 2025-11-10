local M = {}

-- Cache git info per buffer to avoid repeated git calls
local function get_git_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local filepath = vim.fn.expand("%:p")

    -- Check if cache exists and is for the current file
    if vim.b[bufnr].gx_git_cache and vim.b[bufnr].gx_git_cache.filepath == filepath then
        return vim.b[bufnr].gx_git_cache
    end

    -- Check if we're in a git repository
    local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true")
    if not is_git_repo then
        vim.b[bufnr].gx_git_cache = {
            is_git_repo = false,
            filepath = filepath,
        }
        return vim.b[bufnr].gx_git_cache
    end

    -- Get the git remote URL
    local remote = vim.fn.system("git config --get remote.origin.url 2>/dev/null")
    if not remote or remote == "" then
        vim.b[bufnr].gx_git_cache = {
            is_git_repo = false,
            filepath = filepath,
        }
        return vim.b[bufnr].gx_git_cache
    end
    remote = remote:gsub("%s+", "")

    -- Get git root
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+", "")
    if not git_root or git_root == "" then
        vim.b[bufnr].gx_git_cache = {
            is_git_repo = false,
            filepath = filepath,
        }
        return vim.b[bufnr].gx_git_cache
    end

    -- Get current branch
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("%s+", "")
    if not branch or branch == "" then
        branch = "main" -- fallback
    end

    -- Cache the info
    vim.b[bufnr].gx_git_cache = {
        is_git_repo = true,
        remote = remote,
        git_root = git_root,
        branch = branch,
        filepath = filepath,
    }

    return vim.b[bufnr].gx_git_cache
end

local match_to_url = function(line_string)
    -- This extension works differently - it doesn't match on line content
    -- Instead, it always returns a URL if we're in a git repo

    -- Get cached git info for this buffer
    local info = get_git_info()
    if not info.is_git_repo then
        return nil
    end

    local remote = info.remote
    local git_root = info.git_root
    local branch = info.branch
    local filepath = info.filepath

    -- Calculate relative path
    local relative_path = filepath:gsub("^" .. vim.pesc(git_root) .. "/", "")

    -- Get current line number
    local line_number = vim.api.nvim_win_get_cursor(0)[1]

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
