# 🧪 Testing Guide for gx-extended.nvim

This guide will help you thoroughly test all features of gx-extended.nvim.

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Testing Built-in Extensions](#testing-built-in-extensions)
- [Testing Optional Extensions](#testing-optional-extensions)
- [Testing Pattern Ordering](#testing-pattern-ordering)
- [Testing Custom Extensions](#testing-custom-extensions)
- [Troubleshooting](#troubleshooting)
- [Test Files](#test-files)

---

## 🚀 Quick Start

### 1. Restart Neovim

After updating your config:

```vim
:qa
# Then restart Neovim
```

Or reload your config:

```vim
:luafile ~/.config/nvim/init.lua
```

### 2. Open Test Files

Navigate to the test-samples directory:

```bash
cd ~/Projects/gx-extended.nvim/test-samples
nvim .
```

### 3. Enable Debug Logging (Optional)

To see what's happening behind the scenes:

```lua
require('gx-extended').setup {
  log_level = vim.log.levels.DEBUG,
}
```

Then check logs with:
```vim
:messages
```

---

## 📦 Testing Built-in Extensions

### 1. Package Managers

#### NPM (package.json)

**File:** `test-samples/package.json`

1. Open the file: `:e test-samples/package.json`
2. Move cursor to line with `"express"`
3. Press `gx`
4. **Expected:** Opens https://www.npmjs.com/package/express

**Test these lines:**
- ✅ `"express"` → npmjs.com/package/express
- ✅ `"axios"` → npmjs.com/package/axios
- ✅ `"react"` → npmjs.com/package/react

#### Cargo (Cargo.toml)

**File:** `test-samples/Cargo.toml`

1. Open the file: `:e test-samples/Cargo.toml`
2. Move cursor to line with `serde`
3. Press `gx`
4. **Expected:** Opens https://crates.io/crates/serde

**Test these lines:**
- ✅ `serde` → crates.io/crates/serde
- ✅ `tokio` → crates.io/crates/tokio
- ✅ `axum` → crates.io/crates/axum

#### Go Modules (go.mod)

**File:** `test-samples/go.mod`

1. Open the file: `:e test-samples/go.mod`
2. Move cursor to line with `github.com/gin-gonic/gin`
3. Press `gx`
4. **Expected:** Opens https://pkg.go.dev/github.com/gin-gonic/gin

**Test these lines:**
- ✅ `github.com/gin-gonic/gin` → pkg.go.dev
- ✅ `github.com/spf13/cobra` → pkg.go.dev
- ✅ `golang.org/x/sync` → pkg.go.dev

#### Homebrew (Brewfile)

**File:** `test-samples/Brewfile`

1. Open the file: `:e test-samples/Brewfile`
2. Move cursor to line with `brew "neovim"`
3. Press `gx`
4. **Expected:** Opens https://formulae.brew.sh/formula/neovim

**Test these lines:**
- ✅ `brew "neovim"` → formulae.brew.sh/formula/neovim
- ✅ `cask "visual-studio-code"` → formulae.brew.sh/cask/visual-studio-code
- ✅ `brew "git"` → formulae.brew.sh/formula/git

#### Docker (Dockerfile)

**File:** `test-samples/Dockerfile`

1. Open the file: `:e test-samples/Dockerfile`
2. Move cursor to line with `FROM nginx:alpine`
3. Press `gx`
4. **Expected:** Opens https://hub.docker.com/_/nginx

**Test these lines:**
- ✅ `FROM nginx:alpine` → hub.docker.com/_/nginx
- ✅ `FROM node:18-slim` → hub.docker.com/_/node
- ✅ `FROM hashicorp/terraform:latest` → hub.docker.com/r/hashicorp/terraform

### 2. Documentation & References

#### Markdown Links

**File:** `test-samples/README.md`

1. Open the file: `:e test-samples/README.md`
2. Move cursor to `[GitHub](https://github.com)`
3. Press `gx`
4. **Expected:** Opens https://github.com

**Test these lines:**
- ✅ `[GitHub](https://github.com)` → github.com
- ✅ `[NPM Registry](https://www.npmjs.com)` → npmjs.com

#### CVE References

**File:** `test-samples/README.md`

Move cursor to lines with CVE references:
- ✅ `CVE-2024-1234` → nvd.nist.gov/vuln/detail/CVE-2024-1234
- ✅ `CVE-2023-12345` → nvd.nist.gov/vuln/detail/CVE-2023-12345

#### Python PEP References

**File:** `test-samples/README.md`

Move cursor to lines with PEP references:
- ✅ `PEP 8` → peps.python.org/pep-0008/
- ✅ `PEP-484` → peps.python.org/pep-0484/
- ✅ `PEP 3156` → peps.python.org/pep-3156/

#### Git Commit Hashes

**File:** `test-samples/README.md`

**Prerequisites:** Must be in a git repository with a remote

Move cursor to lines with commit hashes:
- ✅ `a1b2c3d` → github.com/user/repo/commit/a1b2c3d
- ✅ `abc123def456` → github.com/user/repo/commit/abc123def456

**Note:** This only works if:
1. You're in a git repository
2. The repository has a remote URL set
3. The remote is GitHub/GitLab/Bitbucket

#### URLs Without Protocol

**File:** `test-samples/README.md`

Move cursor to lines with no-protocol URLs:
- ✅ `google.com` → https://google.com
- ✅ `docs.github.com` → https://docs.github.com
- ✅ `blog.rust-lang.org` → https://blog.rust-lang.org

---

## 🎁 Testing Optional Extensions

### NPM Imports (if enabled)

**File:** `test-samples/test.ts`

**Enable in config:**
```lua
require('gx-extended').setup {
  enable_npm_imports = true,
}
```

**Test:**
1. Open: `:e test-samples/test.ts`
2. Move cursor to `import express from "express"`
3. Press `gx`
4. **Expected:** Opens https://www.npmjs.com/package/express

**Test these lines:**
- ✅ `import axios from "axios"` → npmjs.com/package/axios
- ✅ `import { Button } from "@mui/material"` → npmjs.com/package/@mui/material
- ✅ `const fs = require("fs")` → npmjs.com/package/fs
- ❌ `import { utils } from "./utils"` → Should NOT match (relative import)

### GitHub File Line Permalinks (if enabled)

**File:** Any file in a git repository

**Enable in config:**
```lua
require('gx-extended').setup {
  enable_github_file_line = true,
}
```

**Test:**
1. Open any file: `:e test-samples/test.ts`
2. Move cursor to line 15
3. Press `gx`
4. **Expected:** Opens https://github.com/org/repo/blob/branch/test-samples/test.ts#L15

**Note:** This generates a permalink to the exact line you're on!

### Jira Tickets (if configured)

**Configure:**
```bash
export JIRA_URL="https://yourcompany.atlassian.net"
```

Or in Neovim:
```lua
vim.g.gx_jira_url = "https://yourcompany.atlassian.net"
```

**Test:**
1. Open: `:e test-samples/README.md`
2. Move cursor to `PROJ-123`
3. Press `gx`
4. **Expected:** Opens https://yourcompany.atlassian.net/browse/PROJ-123

### Linear Issues (if configured)

**Configure:**
```bash
export LINEAR_TEAM="your-team"
```

Or in Neovim:
```lua
vim.g.gx_linear_team = "your-team"
```

**Test:**
1. Open: `:e test-samples/README.md`
2. Move cursor to `ENG-456`
3. Press `gx`
4. **Expected:** Opens https://linear.app/your-team/issue/ENG-456

---

## 🔄 Testing Pattern Ordering

This tests that the ordering fix works correctly.

### Test Priority

**File:** `test-samples/test.ts`

With `enable_npm_imports = true`, on a line like:
```typescript
import express from "express"  // CVE-2024-1234
```

**Expected behavior:**
1. NPM imports handler should check first (file-specific)
2. CVE handler should check second (generic)
3. You should get a choice menu if both match

**To test:**
1. Move cursor to the word `express`
2. Press `gx`
3. **Expected:** Opens npm page (because NPM imports has higher priority)
4. Move cursor to `CVE-2024-1234`
5. Press `gx`
6. **Expected:** Opens CVE database

### Test Multiple Matches

**File:** Create a test file with conflicting patterns

**Example:**
```bash
echo "CVE-2024-1234 a1b2c3d" > test-multi.txt
nvim test-multi.txt
```

Move cursor to `a1b2c3d`:
- If you see a selection menu with "Git Commit" and other options → ✅ Working!
- If it opens one without asking → Check your config

---

## 🛠️ Testing Custom Extensions

### Test Your Own Extension

Add a simple test extension to your config:

```lua
require('gx-extended').setup {
  extensions = {
    {
      patterns = { "**/test-*.txt" },
      name = "My Test Handler",
      match_to_url = function(line_string)
        local word = string.match(line_string, "TEST%-(%d+)")
        if word then
          return "https://example.com/test/" .. word
        end
      end,
    },
  },
}
```

**Test:**
1. Create file: `echo "TEST-123" > test-custom.txt`
2. Open: `nvim test-custom.txt`
3. Move cursor to `TEST-123`
4. Press `gx`
5. **Expected:** Opens https://example.com/test/123

---

## 🐛 Troubleshooting

### Nothing Happens When I Press gx

**Check:**
1. Is the keybinding set?
   ```vim
   :nmap gx
   ```
   Should show: `n  gx  * <Lua function>`

2. Is the plugin loaded?
   ```vim
   :lua print(vim.inspect(require('gx-extended')))
   ```

3. Enable debug logging:
   ```lua
   require('gx-extended').setup { log_level = vim.log.levels.DEBUG }
   ```
   Then check `:messages`

### Wrong URL Opens

**Check pattern priority:**
1. More specific patterns should come first
2. Check `:messages` with debug logging enabled
3. See which handler matched

### Pattern Not Matching

**Common issues:**
1. Pattern needs `**` prefix: `**/package.json` not `package.json`
2. Check file path: `:echo expand('%:p')`
3. Test pattern with: `:lua print(vim.fn.glob2regpat("**/package.json"))`

### Git Commands Failing

**For GitHub File Line & Commit handlers:**
1. Are you in a git repo?
   ```bash
   git rev-parse --is-inside-work-tree
   ```

2. Do you have a remote?
   ```bash
   git config --get remote.origin.url
   ```

3. Check the remote format is supported (GitHub/GitLab/Bitbucket)

---

## 📁 Test Files Reference

All test files are in `test-samples/`:

| File | Tests | Extensions |
|------|-------|------------|
| `package.json` | npm packages | package-json |
| `test.ts` | NPM imports, git, CVE, PEP, URLs | npm-imports (optional), git-commit, cve, python-pep, no-protocol-urls |
| `Cargo.toml` | Rust crates | cargo-toml |
| `go.mod` | Go packages | go-packages |
| `Dockerfile` | Docker images | docker-hub |
| `README.md` | All reference types | markdown-links, cve, python-pep, git-commit, no-protocol-urls |
| `Brewfile` | Homebrew formulae/casks | brewfile |

---

## ✅ Testing Checklist

Use this checklist to ensure everything works:

### Built-in Extensions
- [ ] package.json (npm)
- [ ] Cargo.toml (Rust)
- [ ] go.mod (Go)
- [ ] Brewfile (Homebrew)
- [ ] Dockerfile (Docker)
- [ ] Markdown links
- [ ] CVE references
- [ ] Python PEP references
- [ ] Git commit hashes
- [ ] URLs without protocol
- [ ] Neovim plugins (if you have a plugins.lua)

### Optional Extensions (if enabled)
- [ ] NPM imports in TypeScript/JavaScript
- [ ] GitHub file line permalinks
- [ ] Jira tickets (if configured)
- [ ] Linear issues (if configured)

### Pattern Ordering
- [ ] File-specific handlers work
- [ ] Generic handlers work
- [ ] Multiple matches show selection menu
- [ ] Priority order is correct

### Edge Cases
- [ ] Relative imports are ignored (npm-imports)
- [ ] Very long commit hashes work
- [ ] Scoped npm packages work (@org/package)
- [ ] Official vs user Docker images both work

---

## 🎯 Quick Smoke Test

Run this 2-minute test to verify everything works:

1. Open `test-samples/package.json`
2. Press `gx` on `"express"` → Should open npm
3. Open `test-samples/test.ts`
4. Press `gx` on `import axios` → Should open npm (if enabled)
5. Press `gx` on any line → Should open GitHub permalink (if enabled)
6. Open `test-samples/README.md`
7. Press `gx` on `CVE-2024-1234` → Should open CVE database
8. Press `gx` on `google.com` → Should open https://google.com

If all 8 pass → ✅ Everything works!

---

## 📊 Expected Results Summary

| Pattern | File Type | Expected URL |
|---------|-----------|--------------|
| `"express": "^4.18.2"` | package.json | https://www.npmjs.com/package/express |
| `import axios from "axios"` | *.ts, *.js | https://www.npmjs.com/package/axios |
| `serde = "1.0"` | Cargo.toml | https://crates.io/crates/serde |
| `github.com/gin-gonic/gin` | go.mod | https://pkg.go.dev/github.com/gin-gonic/gin |
| `brew "neovim"` | Brewfile | https://formulae.brew.sh/formula/neovim |
| `FROM nginx:alpine` | Dockerfile | https://hub.docker.com/_/nginx |
| `[Link](https://example.com)` | *.md | https://example.com |
| `CVE-2024-1234` | * | https://nvd.nist.gov/vuln/detail/CVE-2024-1234 |
| `PEP 8` | * | https://peps.python.org/pep-0008/ |
| `a1b2c3d` | * (in git repo) | https://github.com/user/repo/commit/a1b2c3d |
| `google.com` | * | https://google.com |
| Any line | * (in git repo) | https://github.com/user/repo/blob/branch/file#L42 |

---

## 🎓 Advanced Testing

### Test with Different Browsers

Set a custom open function:

```lua
require('gx-extended').setup {
  open_fn = function(url)
    vim.fn.system({ 'open', '-a', 'Google Chrome', url })
  end,
}
```

### Test Performance

Time how long handlers take:

```lua
local start = vim.loop.hrtime()
-- Press gx here
local elapsed = (vim.loop.hrtime() - start) / 1e6
print(string.format("Took %.2f ms", elapsed))
```

### Test with Large Files

Create a large test file to ensure performance:

```bash
for i in {1..1000}; do echo "import package$i from 'package$i'"; done > large-test.ts
```

---

## 🆘 Getting Help

If you encounter issues:

1. Check `:messages` with debug logging enabled
2. Verify your pattern matching with `:echo expand('%:p')`
3. Test git commands manually if using git-related handlers
4. Open an issue on GitHub with:
   - Your config
   - The test file content
   - Output of `:messages`
   - Expected vs actual behavior

---

**Happy testing! 🎉**