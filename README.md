# ⭐ gx-extended.nvim

A Neovim plugin that extends the functionality of the gx mapping.
In Neovim, the `gx` mapping in normal mode allows you to navigate to the url under the cursor. This plugin extends that behaviour to more than just urls.

## 🎉 Built-in Features

### 📦 Package Managers

- **npm** (`package.json`) - Opens npm package pages
  - `"express": "^4.18.2"` → https://www.npmjs.com/package/express

- **Cargo** (`Cargo.toml`) - Opens Rust crate pages
  - `serde = "1.0"` → https://crates.io/crates/serde

- **Go** (`go.mod`, `go.sum`) - Opens Go package documentation
  - `github.com/gin-gonic/gin v1.9.0` → https://pkg.go.dev/github.com/gin-gonic/gin

- **Python** (`Pipfile`, `requirements.txt`) - Opens PyPI package pages
  - `django>=4.0` → https://pypi.org/project/django

- **Ruby** (`Gemfile`, `*.gemspec`) - Opens RubyGems pages
  - `gem "rails"` → https://rubygems.org/gems/rails

- **Homebrew** (`Brewfile`) - Opens Homebrew formula/cask pages
  - `brew "neovim"` → https://formulae.brew.sh/formula/neovim
  - `cask "visual-studio-code"` → https://formulae.brew.sh/cask/visual-studio-code

### 🔌 Plugin Managers

- **Packer/Lazy/Plug** (`plugins.lua`, `*plugins*.lua`) - Opens GitHub repo for Neovim plugins
  - `'rmagatti/gx-extended.nvim'` → https://github.com/rmagatti/gx-extended.nvim

### ☁️ Infrastructure & DevOps

- **Terraform** (`*.tf`) - Opens Terraform Registry documentation
  - AWS resources: `resource "aws_instance" "example"` → https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  - GCP resources: `resource "google_compute_instance" "example"` → https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance

- **Docker** (`Dockerfile`, `docker-compose.yml`) - Opens Docker Hub pages
  - `FROM nginx:latest` → https://hub.docker.com/_/nginx
  - `FROM user/custom-image` → https://hub.docker.com/r/user/custom-image

### 🔗 Git & Version Control

- **Git Commits** - Opens commit pages on GitHub, GitLab, or Bitbucket
  - `a1b2c3d` → https://github.com/user/repo/commit/a1b2c3d
  - Works with 7-40 character commit hashes
  - Automatically detects your git remote

### 📝 Documentation & References

- **Markdown Links** (`*.md`, `*.markdown`) - Opens links in Markdown files
  - `[Example](https://example.com)` → https://example.com

- **CVE References** - Opens CVE database entries
  - `CVE-2024-1234` → https://nvd.nist.gov/vuln/detail/CVE-2024-1234

- **Python PEPs** - Opens Python Enhancement Proposals
  - `PEP 8` → https://peps.python.org/pep-0008/

### 🌐 General

- **URLs without protocol** - Automatically adds https://
  - `google.com` → https://google.com
  - `docs.github.com` → https://docs.github.com

### 🎁 Optional Features

These powerful features are **opt-in** to keep the default setup lightweight:

- **NPM Imports** (`*.js`, `*.ts`) - Opens npm packages from import statements
  - `import express from "express"` → https://www.npmjs.com/package/express
  - Enable: `enable_npm_imports = true`

- **GitHub File Line Permalinks** - Creates shareable links to exact file lines
  - Press `gx` on any line → https://github.com/org/repo/blob/branch/file.ts#L42
  - Enable: `enable_github_file_line = true`

- **Jira Tickets** - Opens Jira issues (requires configuration)
  - `PROJ-123` → https://your-company.atlassian.net/browse/PROJ-123
  - Configure: `vim.g.gx_jira_url` or `JIRA_URL` env var

- **Linear Issues** - Opens Linear issues (requires configuration)
  - `ENG-456` → https://linear.app/your-team/issue/ENG-456
  - Configure: `vim.g.gx_linear_team` or `LINEAR_TEAM` env var

📚 **See [ADVANCED.md](./ADVANCED.md) for detailed configuration and more examples**

## 🚀 Showcase
</text>

<old_text line=96>
## ⚙️ Configuration

### Basic Setup

```lua
require('gx-extended').setup {
  -- Default log level (vim.log.levels: TRACE, DEBUG, INFO, WARN, ERROR)
  log_level = vim.log.levels.INFO,
}
```

Opening the registry docs for aws terraform resources

https://user-images.githubusercontent.com/2881382/230259520-c2e84260-4e79-47ff-9c40-62a5162b15c0.mov

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'rmagatti/gx-extended.nvim',
  keys = { 'gx' },
  config = function()
    require('gx-extended').setup {}
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require('gx-extended').setup {}
  end
}
```

## ⚙️ Configuration

### Basic Setup

```lua
require('gx-extended').setup {
  -- Default log level (vim.log.levels: TRACE, DEBUG, INFO, WARN, ERROR)
  log_level = vim.log.levels.INFO,
}
```

### Custom Open Function

By default, gx-extended uses netrw to open URLs. You can override this with a custom function:

```lua
-- Using lazy.nvim's open function
require('gx-extended').setup {
  open_fn = require('lazy.util').open,
}

-- Using a custom shell command
require('gx-extended').setup {
  open_fn = function(url)
    vim.fn.system({ 'open', url })  -- macOS
    -- vim.fn.system({ 'xdg-open', url })  -- Linux
    -- vim.fn.system({ 'start', url })  -- Windows
  end,
}
```

### Adding Custom Extensions

Extensions are checked in the order they're registered. Built-in extensions are registered first, followed by user extensions.

```lua
require('gx-extended').setup {
  extensions = {
    {
      patterns = { "*.tf" },
      name = "Custom Terraform",
      match_to_url = function(line_string)
        -- Custom pattern matching logic
        local resource_name = string.match(line_string, 'resource "custom_([^"]*)"')
        if resource_name then
          return "https://example.com/docs/" .. resource_name
        end
        return nil
      end,
    },
    -- Add more custom extensions...
  },
}
```

### Extension Properties

Each extension must have:

1. **`patterns`** (required) - Array of file glob patterns
   - Example: `{ "*.lua", "**/config/**/*.lua" }`
   - Uses Vim's glob patterns (`:help wildcards`)
   - Must start with `*` or `**` to match correctly

2. **`match_to_url`** (required) - Function that receives the current line and returns a URL or nil
   - Receives: `line_string` (string) - The full text of the current line
   - Returns: `url` (string | nil) - The URL to open, or nil if no match

3. **`name`** (recommended) - Display name shown when multiple handlers match
   - Used in the selection menu
   - Makes it easier to identify which handler will be used

### Example: Jira Ticket Handler

```lua
require('gx-extended').setup {
  extensions = {
    {
      patterns = { "*" },  -- Works in any file
      name = "Jira Tickets",
      match_to_url = function(line_string)
        local ticket = string.match(line_string, "([A-Z][A-Z0-9]+%-%d+)")
        if ticket and #ticket < 20 then
          return "https://your-company.atlassian.net/browse/" .. ticket
        end
        return nil
      end,
    },
  },
}
```

## 🎯 How It Works

### Priority System

Extensions are checked in **registration order**:

1. **Built-in file-specific extensions** (package.json, Cargo.toml, etc.)
2. **Built-in markdown extensions** (markdown links)
3. **Built-in git extensions** (commit hashes)
4. **Built-in reference extensions** (CVE, PEP)
5. **Built-in fallback extensions** (no-protocol URLs)
6. **Your custom extensions**

The first extension that returns a URL wins! If multiple extensions match and return URLs, you'll be shown a selection menu.

### Multiple Matches

When multiple handlers match the same line:

```
Multiple patterns matched. Select one:
> Docker Hub
  Git Commit
  No-protocol URLs
```

Use arrow keys to select the desired handler.

## 🔧 Tips & Tricks

### Debugging

Enable debug logging to see which handlers are being triggered:

```lua
require('gx-extended').setup {
  log_level = vim.log.levels.DEBUG,
}
```

### Visual Mode

`gx` also works in visual mode! Select text and press `gx` to open it.

### Handler Order

To prioritize your custom handlers over built-ins, they'll need to be more specific in their pattern matching, as they're registered after built-ins. Alternatively, you can use the exposed `register` function:

```lua
local gx = require('gx-extended')
gx.setup {}

-- Register additional handlers after setup
gx.register {
  patterns = { "*" },
  name = "My High Priority Handler",
  match_to_url = function(line_string)
    -- Your logic here
  end,
}
```

## 🤝 Contributing

Contributions are welcome! If you have ideas for new built-in extensions or improvements, please:

1. Open an issue to discuss your idea
2. Submit a PR with your changes
3. Include examples and documentation

## 📚 Documentation

- [ADVANCED.md](./ADVANCED.md) - Optional features, custom extensions, and power-user configurations
- [EXAMPLES.md](./EXAMPLES.md) - Real-world usage examples for all handlers

## 📄 License

MIT

## 🙏 Inspiration & Alternatives

- [stsewd/gx-extended.vim](https://github.com/stsewd/gx-extended.vim) - The original gx-extended for Vim
- [chrishrb/gx.nvim](https://github.com/chrishrb/gx.nvim) - Another excellent gx implementation

## ⭐ Show Your Support

If you find this plugin useful, please consider giving it a star on GitHub!