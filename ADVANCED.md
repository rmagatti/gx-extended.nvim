# 🚀 Advanced Features

This guide covers advanced features and configurations for power users of gx-extended.nvim.

## 📋 Table of Contents

- [Optional Extensions](#optional-extensions)
- [Configuration Examples](#configuration-examples)
- [Custom Extensions](#custom-extensions)
- [Integration Examples](#integration-examples)
- [Performance Tips](#performance-tips)
- [Troubleshooting](#troubleshooting)

## 🎯 Optional Extensions

Some powerful extensions are **opt-in** to keep the default setup lightweight and avoid conflicts with your workflow.

### NPM Package Imports

Opens npm packages directly from JavaScript/TypeScript import statements.

**Enable it:**
```lua
require('gx-extended').setup {
  enable_npm_imports = true,
}
```

**Usage:**
```javascript
import express from "express"           // gx → https://www.npmjs.com/package/express
import { useState } from "react"         // gx → https://www.npmjs.com/package/react
import lodash from "lodash"              // gx → https://www.npmjs.com/package/lodash
const axios = require("axios")           // gx → https://www.npmjs.com/package/axios

// Scoped packages
import { Button } from "@mui/material"   // gx → https://www.npmjs.com/package/@mui/material

// Relative imports are ignored
import { utils } from "./utils"          // gx → (no match)
import Component from "../components"     // gx → (no match)
```

**Supported file types:** `.js`, `.jsx`, `.ts`, `.tsx`, `.mjs`, `.cjs`

---

### GitHub File Line Permalink

Creates a shareable permalink to the exact line you're viewing in your git repository.

**Enable it:**
```lua
require('gx-extended').setup {
  enable_github_file_line = true,
}
```

**Usage:**

When your cursor is on any line in a file within a git repository, press `gx` to generate a permalink.

**Example:**

File: `src/utils/parser.ts` (line 42)  
Result: `https://github.com/user/repo/blob/main/src/utils/parser.ts#L42`

**Supported platforms:**
- GitHub: `https://github.com/org/repo/blob/branch/path#L123`
- GitLab: `https://gitlab.com/org/repo/-/blob/branch/path#L123`
- Bitbucket: `https://bitbucket.org/org/repo/src/branch/path#lines-123`

**Use cases:**
- Share exact code locations with teammates
- Create precise bug reports
- Reference specific implementations in documentation
- Code reviews and discussions

**Note:** This handler works on **any line** in a git-tracked file, so it may conflict with other handlers. Consider the priority order when enabling this.

---

### Jira Tickets

Opens Jira tickets in your browser.

**Configuration options:**

1. **Environment variable:**
   ```bash
   export JIRA_URL="https://your-company.atlassian.net"
   ```

2. **Vim global variable:**
   ```lua
   vim.g.gx_jira_url = "https://your-company.atlassian.net"
   ```

3. **Explicit enable:**
   ```lua
   require('gx-extended').setup {
     enable_jira_tickets = true,
   }
   vim.g.gx_jira_url = "https://your-company.atlassian.net"
   ```

**Auto-enable:** If `JIRA_URL` env var or `vim.g.gx_jira_url` is set, the extension activates automatically.

**Usage:**
```txt
Fixes PROJ-123
Related to TEAM-456
See ticket ABC-789 for details
```

**Cursor on:** `PROJ-123` → Opens `https://your-company.atlassian.net/browse/PROJ-123`

---

### Linear Issues

Opens Linear issues in your browser.

**Configuration options:**

1. **Environment variable:**
   ```bash
   export LINEAR_TEAM="your-team"
   ```

2. **Vim global variable:**
   ```lua
   vim.g.gx_linear_team = "your-team"
   ```

3. **Explicit enable:**
   ```lua
   require('gx-extended').setup {
     enable_linear_issues = true,
   }
   vim.g.gx_linear_team = "your-team"
   ```

**Auto-enable:** If `LINEAR_TEAM` env var or `vim.g.gx_linear_team` is set, the extension activates automatically.

**Usage:**
```txt
Implements ENG-42
Closes DESIGN-123
```

**Cursor on:** `ENG-42` → Opens `https://linear.app/your-team/issue/ENG-42`

---

## ⚙️ Configuration Examples

### Complete Configuration

```lua
require('gx-extended').setup {
  -- Logging level
  log_level = vim.log.levels.INFO,  -- DEBUG, INFO, WARN, ERROR
  
  -- Custom open function (optional)
  open_fn = require('lazy.util').open,
  
  -- Optional extensions
  enable_npm_imports = true,
  enable_github_file_line = true,
  enable_jira_tickets = true,
  enable_linear_issues = true,
  
  -- Custom extensions (see below)
  extensions = {
    -- Your custom handlers here
  },
}

-- Configure issue trackers
vim.g.gx_jira_url = "https://yourcompany.atlassian.net"
vim.g.gx_linear_team = "your-team-slug"
```

---

### Minimal Configuration

```lua
require('gx-extended').setup {
  -- Uses all defaults, enables no optional extensions
}
```

---

### Power User Configuration

```lua
require('gx-extended').setup {
  log_level = vim.log.levels.DEBUG,
  open_fn = function(url)
    -- Custom open command
    vim.fn.system({ 'open', '-a', 'Google Chrome', url })
  end,
  
  enable_npm_imports = true,
  enable_github_file_line = true,
  enable_jira_tickets = true,
  
  extensions = {
    -- Custom internal documentation
    {
      patterns = { "**/*.md" },
      name = "Internal Wiki",
      match_to_url = function(line_string)
        local wiki_page = string.match(line_string, "%[%[(.-)%]%]")
        if wiki_page then
          return "https://wiki.company.com/page/" .. wiki_page
        end
      end,
    },
    
    -- Custom ticket system
    {
      patterns = { "*" },
      name = "Support Tickets",
      match_to_url = function(line_string)
        local ticket = string.match(line_string, "TICKET%-(%d+)")
        if ticket then
          return "https://support.company.com/ticket/" .. ticket
        end
      end,
    },
  },
}
```

---

## 🛠️ Custom Extensions

### Real-World Examples

#### 1. Organization-Specific GitHub Links

Open files from a specific GitHub organization with automatic branch detection.

```lua
{
  patterns = { "**/Projects/YourOrg/**" },
  name = "YourOrg GitHub",
  match_to_url = function(line_string)
    local row_col = vim.api.nvim_win_get_cursor(0)
    local relative_path = vim.fn.expand("%")
    
    -- Extract project name from path
    local proj_name = vim.fn.getcwd():match(".*/(.*)")
    
    -- Get current git branch
    local handle = io.popen("git rev-parse --abbrev-ref HEAD")
    local current_branch = handle and handle:read("*a"):gsub("%s+", "")
    if handle then handle:close() end
    
    return string.format(
      "https://github.com/YourOrg/%s/blob/%s/%s#L%d",
      proj_name,
      current_branch,
      relative_path,
      row_col[1]
    )
  end,
}
```

#### 2. Internal Terraform Modules

Open internal Terraform module documentation.

```lua
{
  patterns = { "**/*.tf" },
  name = "Internal Terraform Modules",
  match_to_url = function(line_string)
    -- Match: source = "s3::https://bucket/modules/module-name/v1.0.0.zip"
    local module_name = string.match(line_string, "s3::.*/modules/([^/]+)/")
    if module_name then
      return "https://github.com/yourcompany/terraform-modules/tree/master/modules/" .. module_name
    end
  end,
}
```

#### 3. Confluence Pages

Open Confluence pages by ID.

```lua
{
  patterns = { "*" },
  name = "Confluence",
  match_to_url = function(line_string)
    local page_id = string.match(line_string, "CONF%-(%d+)")
    if page_id then
      return "https://yourcompany.atlassian.net/wiki/spaces/TEAM/pages/" .. page_id
    end
  end,
}
```

#### 4. AWS Console Links

Open AWS resources directly in the console.

```lua
{
  patterns = { "**/*.tf", "**/*.yaml", "**/*.yml" },
  name = "AWS Console",
  match_to_url = function(line_string)
    -- Match EC2 instance ID
    local instance_id = string.match(line_string, "(i%-[a-f0-9]+)")
    if instance_id then
      return "https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:instanceId=" .. instance_id
    end
    
    -- Match S3 bucket
    local bucket = string.match(line_string, 'bucket[%s=:"]+"([%w%-]+)"')
    if bucket then
      return "https://s3.console.aws.amazon.com/s3/buckets/" .. bucket
    end
  end,
}
```

#### 5. GitHub Issues/PRs from Commit Messages

Parse git commit messages for issue/PR references.

```lua
{
  patterns = { "**/.git/COMMIT_EDITMSG", "**/COMMIT_EDITMSG" },
  name = "GitHub Issues from Commit",
  match_to_url = function(line_string)
    -- Match: Fixes #123, Closes #456, etc.
    local issue_num = string.match(line_string, "[Ff]ixes%s+#(%d+)")
      or string.match(line_string, "[Cc]loses%s+#(%d+)")
      or string.match(line_string, "[Rr]esolves%s+#(%d+)")
    
    if issue_num then
      local remote = vim.fn.system("git config --get remote.origin.url")
      local repo = string.match(remote, "github%.com[:/]([%w._-]+/[%w._-]+)")
      if repo then
        repo = repo:gsub("%.git$", "")
        return "https://github.com/" .. repo .. "/issues/" .. issue_num
      end
    end
  end,
}
```

#### 6. Docker Image Tags

Open specific Docker image tag pages.

```lua
{
  patterns = { "**/Dockerfile*", "**/docker-compose.yml" },
  name = "Docker Hub Tags",
  match_to_url = function(line_string)
    local image, tag = string.match(line_string, "FROM%s+([%w._-]+/[%w._-]+):([%w._-]+)")
    if image and tag then
      return "https://hub.docker.com/r/" .. image .. "/tags?name=" .. tag
    end
  end,
}
```

#### 7. Python Virtual Environment Packages

Open packages from requirements.txt with version-specific links.

```lua
{
  patterns = { "**/requirements*.txt" },
  name = "PyPI with Version",
  match_to_url = function(line_string)
    local pkg, version = string.match(line_string, "([%w_-]+)==([%d%.]+)")
    if pkg and version then
      return "https://pypi.org/project/" .. pkg .. "/" .. version .. "/"
    end
  end,
}
```

---

## 🔗 Integration Examples

### With Lazy.nvim

```lua
{
  'rmagatti/gx-extended.nvim',
  keys = { 'gx' },
  config = function()
    require('gx-extended').setup {
      open_fn = require('lazy.util').open,
      enable_npm_imports = true,
      enable_github_file_line = true,
    }
  end,
}
```

### With Custom Keybindings

```lua
require('gx-extended').setup {
  -- Don't set up default gx mapping
}

-- Custom keybindings
vim.keymap.set('n', 'gx', function()
  require('gx-extended.lib').run_match_to_urls()
end, { desc = 'Open URL under cursor' })

vim.keymap.set('v', 'gx', function()
  require('gx-extended.lib').run_match_to_urls()
end, { desc = 'Open selected URL' })

-- Alternative binding
vim.keymap.set('n', '<leader>go', function()
  require('gx-extended.lib').run_match_to_urls()
end, { desc = 'Go to URL' })
```

### With Telescope

Create a Telescope picker for all matching handlers:

```lua
local function telescope_gx()
  local line_string = vim.api.nvim_get_current_line()
  -- Get all matching handlers and their URLs
  -- Then show them in Telescope picker
end

vim.keymap.set('n', '<leader>fx', telescope_gx, { desc = 'Find URL handlers' })
```

---

## ⚡ Performance Tips

### 1. Use Specific Patterns

❌ **Bad:** Matches too broadly
```lua
patterns = { "*" }
```

✅ **Good:** Specific file patterns
```lua
patterns = { "**/*.tf", "**/*.tfvars" }
```

### 2. Order Matters

Put most-used handlers first:

```lua
require('gx-extended').setup {
  extensions = {
    { patterns = { "**/*.js" }, ... },      -- Used daily
    { patterns = { "**/*.md" }, ... },      -- Used often
    { patterns = { "**/Dockerfile" }, ... }, -- Used rarely
  },
}
```

### 3. Early Returns

In your `match_to_url` function:

```lua
match_to_url = function(line_string)
  -- Quick checks first
  if not line_string:match("pattern") then
    return nil
  end
  
  -- Expensive operations only if needed
  local result = expensive_operation()
  return result
end
```

### 4. Cache Git Commands

Git commands can be slow. Cache results:

```lua
local git_remote_cache = {}

local function get_git_remote()
  local cwd = vim.fn.getcwd()
  if not git_remote_cache[cwd] then
    git_remote_cache[cwd] = vim.fn.system("git config --get remote.origin.url")
  end
  return git_remote_cache[cwd]
end
```

---

## 🐛 Troubleshooting

### Debug Mode

Enable detailed logging:

```lua
require('gx-extended').setup {
  log_level = vim.log.levels.DEBUG,
}
```

Check logs with `:messages`

### Common Issues

#### Handler Not Triggering

1. **Check pattern matching:**
   ```lua
   -- This won't work (needs **)
   patterns = { "package.json" }
   
   -- This will work
   patterns = { "**/package.json" }
   ```

2. **Check file path:**
   ```vim
   :echo expand('%:p')
   ```

3. **Enable debug logging and check what patterns match**

#### Wrong Handler Selected

Handlers are checked in registration order. The **first** match wins.

**Solution:** Reorder your extensions or make patterns more specific.

#### Git Commands Failing

Some extensions require git. Check if you're in a git repository:

```bash
git rev-parse --is-inside-work-tree
```

#### Multiple Handlers Match

This is expected behavior. Use arrow keys to select the desired handler from the menu.

To skip the menu and always use the first match, you'd need to modify the plugin code.

---

## 📚 Additional Resources

- [Main README](./README.md) - Basic features and installation
- [Examples](./EXAMPLES.md) - Usage examples for all built-in handlers
- [GitHub Issues](https://github.com/rmagatti/gx-extended.nvim/issues) - Report bugs or request features

---

## 💡 Pro Tips

1. **Use with visual mode** - Select text and press `gx` to open selected content
2. **Combine handlers** - Layer multiple patterns for complex workflows
3. **Test patterns** - Use `:lua print(string.match("test", "pattern"))` to test patterns
4. **Share configs** - Keep your custom extensions in a separate file for easy sharing
5. **Version control** - Commit your gx-extended config to dotfiles for team consistency

---

## 🤝 Contributing

Have a useful custom extension? Share it!

1. Open an issue with your extension
2. If it's generally useful, we might add it as an optional built-in
3. Otherwise, we'll add it to this advanced guide as an example

---

**Happy browsing!** 🚀