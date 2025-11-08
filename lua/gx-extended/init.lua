local M = {
    config = {
        log_level = vim.log.levels.INFO,
        extensions = {},
        legacy_extensions = {},
        -- Optional extension flags
        enable_npm_imports = false,
        enable_github_file_line = false,
        enable_jira_tickets = false,
        enable_linear_issues = false,
    },
}

function M.setup(config)
    --- Merge the user-provided configuration with the default configuration.
    M.config = vim.tbl_deep_extend("force", M.config, config or {})
    local lib = require "gx-extended.lib"
    lib.setup(M.config)

    --- Setup builtin extensions
    --- File-specific handlers (highest priority)
    require("gx-extended.extensions.package-json").setup(config)
    require("gx-extended.extensions.cargo-toml").setup(config)
    require("gx-extended.extensions.go-packages").setup(config)
    require("gx-extended.extensions.ruby-gems").setup(config)
    require("gx-extended.extensions.brewfile").setup(config)
    require("gx-extended.extensions.docker-hub").setup(config)
    require("gx-extended.extensions.pypi-packages").setup(config)
    require("gx-extended.extensions.packer-plugins").setup(config)
    require("gx-extended.extensions.terraform-aws-resources").setup(config)
    require("gx-extended.extensions.terraform-google-resources").setup(config)

    --- Optional: NPM imports in JS/TS files
    if M.config.enable_npm_imports then
        require("gx-extended.extensions.npm-imports").setup(config)
    end

    --- Markdown-specific handlers
    require("gx-extended.extensions.markdown-links").setup(config)

    --- Git-related handlers
    require("gx-extended.extensions.git-commit").setup(config)

    --- Optional: GitHub file line permalinks
    if M.config.enable_github_file_line then
        require("gx-extended.extensions.github-file-line").setup(config)
    end

    --- Generic reference handlers
    require("gx-extended.extensions.cve").setup(config)
    require("gx-extended.extensions.python-pep").setup(config)

    --- Optional: Issue tracking systems (require configuration)
    if M.config.enable_jira_tickets or vim.g.gx_jira_url or os.getenv("JIRA_URL") then
        require("gx-extended.extensions.jira-tickets").setup(config)
    end

    if M.config.enable_linear_issues or vim.g.gx_linear_team or os.getenv("LINEAR_TEAM") then
        require("gx-extended.extensions.linear-issues").setup(config)
    end

    --- Fallback handlers (lowest priority)
    require("gx-extended.extensions.no-protocol-urls").setup(config)

    --- Setup user extensions
    require("gx-extended.extensions.user-extensions").setup(config)

    --- Expose the register function from gx-extended.lib.
    M.register = lib.register
end

return M
