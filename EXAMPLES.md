# 📚 Examples

This document provides practical examples of using gx-extended.nvim with various file types and patterns.

## 📦 Package Managers

### npm (package.json)

**File: `package.json`**
```json
{
  "dependencies": {
    "express": "^4.18.2",
    "lodash": "^4.17.21",
    "axios": "^1.4.0"
  }
}
```

**Cursor on:**
- `"express"` → Opens https://www.npmjs.com/package/express
- `"lodash"` → Opens https://www.npmjs.com/package/lodash
- `"axios"` → Opens https://www.npmjs.com/package/axios

---

### Rust (Cargo.toml)

**File: `Cargo.toml`**
```toml
[dependencies]
serde = "1.0"
tokio = { version = "1.28", features = ["full"] }
reqwest = "0.11"
```

**Cursor on:**
- `serde` → Opens https://crates.io/crates/serde
- `tokio` → Opens https://crates.io/crates/tokio
- `reqwest` → Opens https://crates.io/crates/reqwest

---

### Go (go.mod)

**File: `go.mod`**
```go
module example.com/myapp

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/spf13/cobra v1.7.0
    golang.org/x/sync v0.3.0
)
```

**Cursor on:**
- `github.com/gin-gonic/gin` → Opens https://pkg.go.dev/github.com/gin-gonic/gin
- `github.com/spf13/cobra` → Opens https://pkg.go.dev/github.com/spf13/cobra
- `golang.org/x/sync` → Opens https://pkg.go.dev/golang.org/x/sync

---

### Python (requirements.txt)

**File: `requirements.txt`**
```txt
django>=4.2.0
requests==2.31.0
numpy
pandas>=2.0.0,<3.0.0
```

**Cursor on:**
- `django` → Opens https://pypi.org/project/django
- `requests` → Opens https://pypi.org/project/requests
- `numpy` → Opens https://pypi.org/project/numpy
- `pandas` → Opens https://pypi.org/project/pandas

---

### Python (Pipfile)

**File: `Pipfile`**
```toml
[packages]
flask = "*"
sqlalchemy = ">=1.4"
pytest = {version = ">=7.0"}
```

**Cursor on:**
- `flask` → Opens https://pypi.org/project/flask
- `sqlalchemy` → Opens https://pypi.org/project/sqlalchemy
- `pytest` → Opens https://pypi.org/project/pytest

---

### Ruby (Gemfile)

**File: `Gemfile`**
```ruby
source 'https://rubygems.org'

gem 'rails', '~> 7.0'
gem 'pg', '>= 1.1'
gem 'puma', '~> 5.0'
gem 'redis', '~> 4.0'
```

**Cursor on:**
- `'rails'` → Opens https://rubygems.org/gems/rails
- `'pg'` → Opens https://rubygems.org/gems/pg
- `'puma'` → Opens https://rubygems.org/gems/puma
- `'redis'` → Opens https://rubygems.org/gems/redis

---

### Homebrew (Brewfile)

**File: `Brewfile`**
```ruby
brew "neovim"
brew "git"
brew "ripgrep"
cask "visual-studio-code"
cask "docker"
cask "slack"
```

**Cursor on:**
- `brew "neovim"` → Opens https://formulae.brew.sh/formula/neovim
- `brew "git"` → Opens https://formulae.brew.sh/formula/git
- `cask "visual-studio-code"` → Opens https://formulae.brew.sh/cask/visual-studio-code
- `cask "docker"` → Opens https://formulae.brew.sh/cask/docker

---

## 🔌 Plugin Managers

### Neovim Plugins

**File: `lua/plugins.lua`** (Packer)
```lua
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-telescope/telescope.nvim'
  use 'folke/tokyonight.nvim'
end)
```

**Cursor on:**
- `'wbthomason/packer.nvim'` → Opens https://github.com/wbthomason/packer.nvim
- `'neovim/nvim-lspconfig'` → Opens https://github.com/neovim/nvim-lspconfig
- `'nvim-telescope/telescope.nvim'` → Opens https://github.com/nvim-telescope/telescope.nvim

**File: `lua/plugins/init.lua`** (Lazy)
```lua
return {
  'rmagatti/gx-extended.nvim',
  'hrsh7th/nvim-cmp',
  'nvim-treesitter/nvim-treesitter',
}
```

**Cursor on any plugin** → Opens corresponding GitHub repository

---

## ☁️ Infrastructure & DevOps

### Terraform

**File: `main.tf`**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "logs" {
  bucket = "my-logs-bucket"
}

resource "google_compute_instance" "default" {
  name         = "test-instance"
  machine_type = "e2-medium"
}
```

**Cursor on:**
- `"aws_instance"` → Opens https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
- `"aws_s3_bucket"` → Opens https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
- `"google_compute_instance"` → Opens https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance

---

### Docker

**File: `Dockerfile`**
```dockerfile
FROM nginx:alpine
FROM node:18-slim
FROM postgres:15
FROM redis:7-alpine
FROM ubuntu:22.04
```

**Cursor on:**
- `nginx:alpine` → Opens https://hub.docker.com/_/nginx
- `node:18-slim` → Opens https://hub.docker.com/_/node
- `postgres:15` → Opens https://hub.docker.com/_/postgres

**File: `docker-compose.yml`**
```yaml
services:
  web:
    image: nginx:latest
  app:
    image: myuser/myapp:v1
  db:
    image: postgres:15
```

**Cursor on:**
- `image: nginx:latest` → Opens https://hub.docker.com/_/nginx
- `image: myuser/myapp:v1` → Opens https://hub.docker.com/r/myuser/myapp
- `image: postgres:15` → Opens https://hub.docker.com/_/postgres

---

## 🔗 Git & Version Control

### Git Commit Hashes

**Any file in a git repository:**
```txt
Fixed bug in a1b2c3d
See commit abc123def456 for details
Reverts 7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b
```

**Cursor on:**
- `a1b2c3d` → Opens GitHub/GitLab/Bitbucket commit page
- `abc123def456` → Opens commit page
- `7a8b9c...` → Opens commit page

**Supported platforms:**
- GitHub: `https://github.com/user/repo/commit/HASH`
- GitLab: `https://gitlab.com/user/repo/-/commit/HASH`
- Bitbucket: `https://bitbucket.org/user/repo/commits/HASH`

---

## 📝 Documentation & References

### Markdown Links

**File: `README.md`**
```markdown
Check out [the documentation](https://example.com/docs)
Visit [our website](https://mysite.com)
See [GitHub](https://github.com/user/repo)
Also check www.example.com
```

**Cursor on:**
- `[the documentation](https://example.com/docs)` → Opens https://example.com/docs
- `[our website](https://mysite.com)` → Opens https://mysite.com
- `[GitHub](https://github.com/user/repo)` → Opens https://github.com/user/repo

---

### CVE References

**Any file:**
```txt
Security fix for CVE-2024-1234
Addresses CVE-2023-12345 vulnerability
Related to CVE-2022-0001
```

**Cursor on:**
- `CVE-2024-1234` → Opens https://nvd.nist.gov/vuln/detail/CVE-2024-1234
- `CVE-2023-12345` → Opens https://nvd.nist.gov/vuln/detail/CVE-2023-12345
- `CVE-2022-0001` → Opens https://nvd.nist.gov/vuln/detail/CVE-2022-0001

---

### Python PEPs

**Any file (often in comments or docs):**
```python
# Following PEP 8 style guide
# See PEP-484 for type hints
# Implements PEP 3156 (asyncio)
```

**Cursor on:**
- `PEP 8` → Opens https://peps.python.org/pep-0008/
- `PEP-484` → Opens https://peps.python.org/pep-0484/
- `PEP 3156` → Opens https://peps.python.org/pep-3156/

---

## 🌐 General URLs

### URLs Without Protocol

**Any file:**
```txt
Visit google.com for search
Check docs.github.com for documentation
See example.org for more info
Read blog.rust-lang.org
```

**Cursor on:**
- `google.com` → Opens https://google.com
- `docs.github.com` → Opens https://docs.github.com
- `example.org` → Opens https://example.org
- `blog.rust-lang.org` → Opens https://blog.rust-lang.org

---

## 🎯 Advanced Examples

### Multiple Matches

**File: `Dockerfile` with commit reference:**
```dockerfile
# Fixed in commit a1b2c3d
FROM nginx:alpine
```

When cursor is on `nginx`:
```
Multiple patterns matched. Select one:
> Docker Hub
  Git Commit
  No-protocol URLs
```

Use arrow keys to select the desired handler.

---

### Custom Extensions

**Your config:**
```lua
require('gx-extended').setup {
  extensions = {
    {
      patterns = { "*" },
      name = "JIRA Tickets",
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

**Any file:**
```txt
Fixes PROJ-123
Relates to TEAM-456
```

**Cursor on:**
- `PROJ-123` → Opens https://yourcompany.atlassian.net/browse/PROJ-123
- `TEAM-456` → Opens https://yourcompany.atlassian.net/browse/TEAM-456

---

## 💡 Tips

1. **Visual Mode**: Select text and press `gx` to open selected URLs
2. **Debug Mode**: Enable `log_level = vim.log.levels.DEBUG` to see what's happening
3. **Priority**: Handlers are checked in registration order (file-specific → general)
4. **Patterns**: Use `**` for recursive matching: `**/package.json` matches any `package.json`

---

## 🐛 Troubleshooting

### Handler not triggering?

1. Check if the file path matches the pattern
   - Pattern `package.json` won't match
   - Pattern `**/package.json` will match
   
2. Enable debug logging:
   ```lua
   require('gx-extended').setup {
     log_level = vim.log.levels.DEBUG,
   }
   ```

3. Check the logs (`:messages`) to see which handlers are being tested

### Wrong handler selected?

If the wrong handler is being picked, check the registration order in your config. Earlier handlers have priority.

---

## 📚 More Examples

Want to add more examples? Open a PR or issue on [GitHub](https://github.com/rmagatti/gx-extended.nvim)!