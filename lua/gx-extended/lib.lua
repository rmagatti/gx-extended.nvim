local logger = require("gx-extended.logger"):new { log_level = vim.log.levels.INFO }

local M = {}

local registry = {}

-- override with config.open_fn
local function open_fn(url)
  vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
end

local function run_match_to_urls()
  logger.debug({ registry = registry })

  local line_string = vim.api.nvim_get_current_line()
  local url, matched_patterns = nil, {}

  local current_file = vim.fn.expand "%"

  for file_glob, _ in pairs(registry) do
    local file_pattern = vim.fn.glob2regpat(file_glob)
    local match = vim.fn.matchstr(current_file, file_pattern)

    if match ~= "" then
      logger.debug(
        "Found match for current file pattern",
        { current_file = current_file, file_pattern = file_pattern, match = match }
      )

      table.insert(matched_patterns, file_glob)
    end
  end

  logger.debug({ matched_patterns = matched_patterns })


  local keep_going = true
  for _, matched_pattern in ipairs(matched_patterns) do
    if keep_going then
      local registrations = registry[matched_pattern]

      -- TODO: This makes me have to select every time I hit gx. Select only when the result of more than one match_to_url is not nil instead!
      local try_open = function(registration)
        logger.debug("pattern_value", registration)

        local pcall_succeeded, _return = pcall(registration.match_to_url, line_string)
        url = pcall_succeeded and _return or nil

        logger.debug("match_to_url called", {
          line_string = line_string,
          success = pcall_succeeded,
          url = url or "nil",
          extension = registration,
        })

        if url and url ~= "nil" then
          logger.debug("opening url", { url = url, success = pcall_succeeded })
          open_fn(url)
          keep_going = false
        end
      end

      if #registrations > 1 then
        logger.debug("More than 1 handler registered, showing select menu", { registration = registrations })

        local options = {}
        for _, registration in ipairs(registrations) do
          table.insert(options, registration)
        end

        vim.ui.select(options, {
          prompt = "Multiple patterns matched. Select one:",
          format_item = function(item)
            return item.name
          end
        }, function(registration)
          logger.debug("selected", { registration = registration })
          try_open(registration)
        end)
      else
        try_open(registrations[1])
      end
    end
  end
end

function M.setup(config)
  logger.set_log_level(config.log_level)

  if config.open_fn then
    open_fn = config.open_fn
  end
  vim.keymap.set("n", "gx", run_match_to_urls, {})
end

---@class RegistrationSpec
---@field patterns string[] A glob file pattern to match against the current file. See `:help glob()`.
---@field match_to_url fun(line_string: string): string | nil A function that takes the current line string and returns a url or nil.
---@field name string | nil A name to show in the select menu when multiple handlers are registered. This will be made required later on.

---@param options RegistrationSpec
function M.register(options)
  local patterns = options.patterns
  local match_to_url = options.match_to_url
  local name = options.name

  for _, pattern in ipairs(patterns) do
    if not registry[pattern] then
      registry[pattern] = {}
    end

    table.insert(registry[pattern], {
      match_to_url = match_to_url,
      name = name,
    })
  end

  logger.debug("registering", {
    patterns = patterns,
    match_to_url = match_to_url,
    registry = registry,
  })
end

return M
