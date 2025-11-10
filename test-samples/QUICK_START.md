# 🚀 Quick Start Testing Guide

## TL;DR - 2 Minute Test

```bash
cd ~/Projects/gx-extended.nvim/test-samples
./test-runner.sh
# Or manually:
nvim package.json
# Move cursor to "express" and press gx
```

## One-Liners for Each Feature

| Test | Command | Action |
|------|---------|--------|
| NPM packages | `nvim package.json` | Cursor on `"express"` → `gx` |
| NPM imports | `nvim test.ts` | Cursor on `import axios` → `gx` |
| Rust crates | `nvim Cargo.toml` | Cursor on `serde` → `gx` |
| Go packages | `nvim go.mod` | Cursor on `github.com/gin-gonic/gin` → `gx` |
| Docker images | `nvim Dockerfile` | Cursor on `FROM nginx` → `gx` |
| Homebrew | `nvim Brewfile` | Cursor on `brew "neovim"` → `gx` |
| CVE refs | `nvim README.md` | Cursor on `CVE-2024-1234` → `gx` |
| PEP refs | `nvim README.md` | Cursor on `PEP 8` → `gx` |
| Git commits | `nvim README.md` | Cursor on `a1b2c3d` → `gx` |
| URLs | `nvim README.md` | Cursor on `google.com` → `gx` |
| Markdown links | `nvim README.md` | Cursor on `[Link](url)` → `gx` |
| File permalink | `nvim README.md` | Any line → `gx` (if enabled) |

## Automated Test

```bash
cd ~/Projects/gx-extended.nvim/test-samples
./test-runner.sh
```

## Debug Mode

In your config:
```lua
require('gx-extended').setup {
  log_level = vim.log.levels.DEBUG,
}
```

Then check: `:messages` in Neovim

## Expected Results

✅ = Should work
❌ = Should NOT match

| Pattern | Result |
|---------|--------|
| `"express"` in package.json | ✅ → npmjs.com |
| `import axios from "axios"` | ✅ → npmjs.com (if enabled) |
| `import { utils } from "./utils"` | ❌ Ignored (relative) |
| `serde = "1.0"` | ✅ → crates.io |
| `CVE-2024-1234` | ✅ → nvd.nist.gov |
| `PEP 8` | ✅ → peps.python.org |
| `a1b2c3d` (in git repo) | ✅ → github.com commit |
| Any line (in git repo) | ✅ → github.com permalink (if enabled) |
| `google.com` | ✅ → https://google.com |

## Troubleshooting One-Liners

```bash
# Check if gx is mapped
nvim -c 'nmap gx' -c 'q'

# Check if plugin is loaded
nvim -c 'lua print(vim.inspect(require("gx-extended")))' -c 'q'

# Check git remote (for git features)
git config --get remote.origin.url

# Check if in git repo
git rev-parse --is-inside-work-tree
```

## Full Documentation

- Comprehensive guide: `../TESTING.md`
- All features: `../README.md`
- Advanced config: `../ADVANCED.md`
- Usage examples: `../EXAMPLES.md`

---

**Happy testing! 🎉**
