local logger = require("gx-extended.logger"):new({ log_level = vim.log.levels.INFO })

local M = {}

function M.setup(config)
  logger.log_level = config.log_level
end

local group = vim.api.nvim_create_augroup("gx-extended", {
  clear = true,
})

---The per_pattern table should look like this:
---local per_pattern = {
---	["*.tf"] = {
---		{
---			match_to_url = function() ... end,
---		},
---	},
---}
local per_pattern = {}

function M.register(options)
  local events = options.event or { "BufEnter" }
  local autocmd_pattern = options.autocmd_pattern
  local match_to_url = options.match_to_url

  -- Line up match_to_url functions for the same pattern so they are all executed when the autocmd is triggered
  for _, value in pairs(autocmd_pattern) do
    if not per_pattern[value] then
      per_pattern[value] = {}
    end

    table.insert(per_pattern[value], { match_to_url = match_to_url })
  end

  vim.api.nvim_create_autocmd(events, {
    pattern = autocmd_pattern,
    group = group,
    callback = function()
      vim.keymap.set("n", "gx", function()
        local line_string = vim.api.nvim_get_current_line()

        local success, url = nil, nil

        for _, ptrn in pairs(autocmd_pattern) do
          for _, value in pairs(per_pattern[ptrn]) do
            success, url = pcall(value.match_to_url, line_string)

            if success then
              vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
              return
            end
          end
        end

        if not success then
          logger.info("Could not match custom gx-extended pattern, calling default gx")

          vim.cmd([[execute "normal \<Plug>NetrwBrowseX"]])
          return
        end
      end, {})
    end,
  })
end

return M
