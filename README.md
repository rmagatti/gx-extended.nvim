# ⭐ gx-extended.nvim

A Neovim plugin that extends the functionality of the gx mapping.
In Neovim, the `gx` mapping in normal mode allows you to navigate to the url under the cursor. This plugin extends that behaviour to more than just urls.

## 🎉 Built-in Features

- `package.json` - `gx` when cursor is under an npm dependency, navigates to _https://www.npmjs.com/package/[packageName]_
- `plugins.lua` - In packer.nvim's convention `plugins.lua` file, `gx` when cursor is under a plugin dependency, navigates to _https://github.com/[user/org]/[repo]_
- `*.tf` - In a [terraform](https://www.terraform.io/) file, `gx` when cursor is under a [terraform resource definition](https://developer.hashicorp.com/terraform/language/resources) navigates to _https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/[resourceName]_. This works for both AWS and Google Cloud resources.
- `Cargo.toml` - In a Cargo.toml file, gx on a line that contains a crate will take you to https://crates.io/crates/{{crate_name}}
- `PyPI` - In a `Pipfile` or `requirements.txt` file, `gx` on a line that contains a package spec will take you to https://pypi.org/project/{{package}}
- `*` - In any file, `gx` navigates to no-protocol-urls like `google.com`, `docs.google.com`, etc.

## 🚀 Showcase

Opening the registry docs for aws terraform resources

https://user-images.githubusercontent.com/2881382/230259520-c2e84260-4e79-47ff-9c40-62a5162b15c0.mov

## 📦 Installation

```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require('gx-extended').setup {}
  end
}
```

## ⚙️ Configuring

You can pass custom extensions to the `extensions` table. Each extension should have at least two properties:

1. `patterns`: a list of file glob patterns to run the autocommands for.
Example: `patterns = { '*/plugins/**.lua' }` matches any Lua file inside `plugins/` or its sub-directories. See `:help wildcards` for how file glob wildcards are expanded
   - **Important:** The plugin matches the glob on the file path of the current file now; meaning for example that setting `plugins.lua` won't match correctly but `*plugins.lua` will.
2. `match_to_url`: a function to run the match and return the composed url to be used by the `gx` command
3. `name`: the name to be shown in a picker in case of handler/extension conflicts

The following is an example of hitting `gx` on a terraform file on a line where an aws resource is defined and opening your browser directly on the terraform registry documentation for the specific resource.

```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require("gx-extended").setup {
      extensions = {
      -- Do not create this extension, the terraform resource setup is already built-into the plugin. This is merely an example of a user-defined extension.
        {
          patterns = { "*.tf" },
          match_to_url = function(line_string)
            -- Hint: `:help lua-patterns`
            local resource_name = string.match(line_string, 'resource "aws_([^"]*)"')
            local url = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/" .. resource_name

            return url
          end,
        }
      },
    }
  end
}
```

By default, gx-extended uses netrw to open urls. You can pass a custom open
function to config to change this behaviour. For example, if you use
`lazy.nvim`, you can configure gx-extended to use its `open` function:

```lua
return { 'rmagatti/gx-extended.nvim',
  keys = { 'gx' },
  opts = {
    open_fn = require'lazy.util'.open,
  }
}
```
### Inspiration/Alternatives

https://github.com/stsewd/gx-extended.vim
