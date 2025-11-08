<div align="center">

# ⭐ gx-extended.nvim

**Extend Neovim's `gx` to open anything under your cursor!**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Neovim](https://img.shields.io/badge/Neovim-0.5+-green.svg)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Made%20with-Lua-2C2D72.svg)](https://www.lua.org)

[Features](#-features) • [Installation](#-installation) • [Configuration](#%EF%B8%8F-configuration) • [Documentation](#-documentation)

</div>

---

## 🎯 What is this?

**gx-extended.nvim** supercharges Neovim's built-in `gx` command. Press `gx` on anything — package names, import statements, issue numbers, commit hashes, and more — and it opens the right URL in your browser.

**Before:** `gx` only worked on URLs  
**After:** `gx` works on 20+ different patterns across all your files!

### ✨ Highlights

- 🚀 **19 built-in handlers** — npm, cargo, docker, terraform, git, and more
- 🎯 **Deterministic ordering** — Predictable priority system (first defined = first checked)
- 🎁 **4 optional power features** — NPM imports, GitHub permalinks, Jira, Linear
- 🔧 **Zero config needed** — Works out of the box
- 🎨 **Fully extensible** — Add your own patterns easily
- 📚 **900+ lines of docs** — Examples for everything
- ⚡ **Lightweight** — Heavy features are opt-in

---

## 🎬 Demo

Press `gx` on any of these:

```javascript
import express from "express"        // → Opens npmjs.com
```

```toml
serde = "1.0"                        // → Opens crates.io
```

```dockerfile
FROM nginx:alpine                    // → Opens hub.docker.com
```

```markdown
Fixed CVE-2024-1234                  // → Opens nvd.nist.gov
See commit a1b2c3d                   // → Opens GitHub commit
Visit docs.github.com                // → Opens with https://
```

---

## 🌟 Features

<details open>
<summary><b>📦 Package Managers (7 supported)</b></summary>

| Language | File | Example | Opens |
|----------|------|---------|-------|
| JavaScript/TypeScript | `package.json` | `"express": "^4.18.2"` | npmjs.com |
| Rust | `Cargo.toml` | `serde = "1.0"` | crates.io |
| Go | `go.mod` | `github.com/gin-gonic/gin` | pkg.go.dev |
| Python | `requirements.txt` | `django>=4.0` | pypi.org |
| Ruby | `Gemfile` | `gem "rails"` | rubygems.org |
| Homebrew | `Brewfile` | `brew "neovim"` | formulae.brew.sh |
| Docker | `Dockerfile` | `FROM nginx` | hub.docker.com |

</details>

<details>
<summary><b>☁️ Infrastructure & DevOps</b></summary>

- **Terraform** (`*.tf`) — AWS/GCP resource documentation
  - `resource "aws_instance"` → Terraform Registry
- **Docker** — Official images and user repositories
  - `FROM nginx:alpine` → Docker Hub
  - `FROM user/image:tag` → Docker Hub

</details>

<details>
<summary><b>🔗 Git & Version Control</b></summary>

- **Git Commits** — Opens on GitHub/GitLab/Bitbucket
  - `a1b2c3d` → commit page (auto-detects remote)
- **GitHub Permalinks** ⭐ *(optional)* — Share exact code locations
  - Press `gx` on any line → `github.com/repo/file.ts#L42`

</details>

<details>
<summary><b>📝 Documentation & References</b></summary>

- **Markdown Links** — `[text](url)` → Opens URL
- **CVE References** — `CVE-2024-1234` → NVD database
- **Python PEPs** — `PEP 8` → Python Enhancement Proposals
- **URLs without protocol** — `google.com` → `https://google.com`

</details>

<details>
<summary><b>🔌 Neovim Plugins</b></summary>

- Works with **Packer**, **Lazy.nvim**, **vim-plug**
- `'user/plugin'` → Opens GitHub repository

</details>

<details>
<summary><b>🎁 Optional Power Features</b></summary>

Enable these for even more power:

| Feature | What it does | Enable with |
|---------|--------------|-------------|
| **NPM Imports** | `import axios from "axios"` → npm | `enable_npm_imports = true` |
| **GitHub Permalinks** | Any line → GitHub link with line number | `enable_github_file_line = true` |
| **Jira Tickets** | `PROJ-123` → Your Jira | `vim.g.gx_jira_url` |
| **Linear Issues** | `ENG-456` → Your Linear | `vim.g.gx_linear_team` |

📚 **[See ADVANCED.md for complete optional features guide →](./ADVANCED.md)**

</details>

---

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (recommended)

```lua
{
  'rmagatti/gx-extended.nvim',
  keys = { 'gx' },
  config = function()
    require('gx-extended').setup {}
  end
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require('gx-extended').setup {}
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'rmagatti/gx-extended.nvim'
```

Then in your `init.lua`:
```lua
require('gx-extended').setup {}
```

---

## ⚙️ Configuration

### Quick Start (Zero Config)

```lua
require('gx-extended').setup {}
```

That's it! All built-in features work out of the box.

### Enable Optional Features

```lua
require('gx-extended').setup {
  -- Optional: NPM imports in JS/TS files
  enable_npm_imports = true,
  
  -- Optional: GitHub file line permalinks
  enable_github_file_line = true,
  
  -- Optional: Custom browser
  open_fn = require('lazy.util').open,
}
```

### Add Custom Extensions

```lua
require('gx-extended').setup {
  extensions = {
    {
      patterns = { "*" },
      name = "Jira Tickets",
      match_to_url = function(line_string)
        local ticket = string.match(line_string, "([A-Z]+-[0-9]+)")
        if ticket then
          return "https://yourcompany.atlassian.net/browse/" .. ticket
        end
      end,
    },
  },
}
```

📚 **[See full configuration guide →](./README.md#configuration)**

---

## 🎯 Usage

### Basic Usage

1. Move cursor over a pattern (package name, URL, commit hash, etc.)
2. Press `gx` in normal mode
3. Opens in your browser!

**Also works in visual mode** — Select text and press `gx`

### Multiple Matches

When multiple handlers match, you get a menu:

```
Multiple patterns matched. Select one:
> Docker Hub
  Git Commit
  No-protocol URLs
```

Use `↑↓` to select, `Enter` to open.

---

## 🧪 Testing

We've made testing easy! Try it out:

```bash
cd ~/.local/share/nvim/lazy/gx-extended.nvim/test-samples
./test-runner.sh
```

Or manually test any feature:

```bash
nvim package.json
# Move cursor to "express" and press gx
```

📚 **[See complete testing guide →](./TESTING.md)**

---

## 📚 Documentation

| Document | What's inside |
|----------|---------------|
| **[ADVANCED.md](./ADVANCED.md)** | Optional features, custom extensions, power-user configs (600+ lines) |
| **[EXAMPLES.md](./EXAMPLES.md)** | Real-world examples for every feature (400+ lines) |
| **[TESTING.md](./TESTING.md)** | Complete testing guide with test files (540+ lines) |

---

## 🤝 Contributing

Contributions are welcome! 

- 💡 **Have an idea?** [Open an issue](../../issues/new)
- 🐛 **Found a bug?** [Report it](../../issues/new)
- 🔧 **Want to add a feature?** Submit a PR!

### Adding a New Extension

See [ADVANCED.md](./ADVANCED.md) for examples of custom extensions. We're always open to adding more built-in handlers!

---

## 🎓 How It Works

### Priority System

Extensions are checked in **registration order**:

1. File-specific handlers (package.json, Cargo.toml, etc.)
2. Markdown handlers
3. Git handlers
4. Reference handlers (CVE, PEP)
5. Fallback handlers (no-protocol URLs)
6. Your custom extensions

**First match wins!** If multiple match, you get a menu.

### Deterministic Ordering ⭐

**Key improvement:** Extensions are checked in the exact order they're registered. No more random behavior!

This means:
- **Predictable** — Same pattern always wins
- **Configurable** — Control priority by registration order
- **Debuggable** — Easy to understand what's happening

Example: File-specific handlers are registered first, so they always take priority over generic patterns.

---

## 📊 Stats

- **19 total extensions** (15 built-in + 4 optional)
- **7 package managers** supported
- **3 git platforms** (GitHub, GitLab, Bitbucket)
- **20+ file types** covered
- **900+ lines** of documentation
- **Zero** dependencies (besides Neovim 0.5+)

---

## 🙏 Credits & Inspiration

- [stsewd/gx-extended.vim](https://github.com/stsewd/gx-extended.vim) — The original gx-extended for Vim
- [chrishrb/gx.nvim](https://github.com/chrishrb/gx.nvim) — Another excellent Neovim implementation

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

---

<div align="center">

### ⭐ Show Your Support

If you find this plugin useful, please star it on GitHub!

**[⬆ Back to Top](#-gx-extendednvim)**

</div>