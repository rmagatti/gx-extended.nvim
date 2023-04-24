local logger = require("gx-extended.logger"):new({ log_level = vim.log.levels.DEBUG })

local M = {}

---The per_pattern table should look like this:
---local per_pattern = {
---	["*.tf"] = { {
---			match_to_url = function() ... end,
---	} },
---}
local per_pattern = {}

local group = vim.api.nvim_create_augroup("gx-extended", {
  clear = true,
})

function M.setup(config)
  logger.log_level = config.log_level

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    group = group,
    callback = function()
      vim.keymap.set("n", "gx", function()
        local line_string = vim.api.nvim_get_current_line()
        local success, url = nil, nil

        for _, ptrn in ipairs(autocmd_pattern) do
          for _, value in ipairs(per_pattern[ptrn]) do
            logger.debug({
              autocmd_pattern = autocmd_pattern,
              per_pattern = per_pattern[ptrn],
            })

            success, url = pcall(value.match_to_url, line_string)

            if url then
              -- vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })

              logger.info({
                line_string = line_string,
                success = success,
                url = url,
              })
              break
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

function M.register(options)
  local events = options.event or { "FileType" }
  local autocmd_pattern = options.autocmd_pattern
  local match_to_url = options.match_to_url

  logger.debug({
    events = events,
    autocmd_pattern = autocmd_pattern,
    match_to_url = match_to_url,
    per_pattern = per_pattern,
  })

  -- Line up match_to_url functions for the same pattern so they are all executed when the autocmd is triggered
  for _, value in pairs(autocmd_pattern) do
    if not per_pattern[value] then
      per_pattern[value] = {}
    end

    table.insert(per_pattern[value], { match_to_url = match_to_url })
  end
end

return M
