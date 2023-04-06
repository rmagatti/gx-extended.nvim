# ⭐ GX Extended

A Neovim plugin that extends the functionality of the gx command.

## 🚀 Showcase

[Insert showcase here, if applicable.]

## 📦 Installation

```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require('gx-extended').setup {}
  end
}
```

## ⚙️  Configuring
You can pass custom extensions to the `extensions` table. Each extension should have at least two properties:
1. autocmd_pattern, a list of file patterns to run the autocomands for
2. match_to_url, a function to run the match and return the composed url to be used by the `gx` command

The following is an example of hitting `gx` on a terraform file on a line where an aws resource is defined and opening your browser directly on the terraform registry documentation for the specific resource.
```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require("gx-extended").setup {
      extensions = {
        {
          autocmd_pattern = { "*.tf" },
          match_to_url = function(line_string)
            local resource_name = string.match(line_string, 'resource "aws_([^"]*)"')
            local url = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/" .. resource_name

            return url
          end,
        },
      },
    }
  end
```

## TODOs
- Implement `visual` mode
