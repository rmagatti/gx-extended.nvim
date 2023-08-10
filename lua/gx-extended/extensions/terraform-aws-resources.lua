local M = {}

function M.setup(config)
  require("gx-extended.lib").register {
    patterns = { "*.tf" },
    match_to_url = function(line_string)
      local resource_name = string.match(line_string, 'resource "aws_([^"]*)"')

      if not resource_name then
        return nil
      end

      local url = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/" .. resource_name

      return url
    end,
  }
end

return M
