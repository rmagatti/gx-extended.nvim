local logger = require("gx-extended.logger"):new { log_level = vim.log.levels.INFO }

local M = {}

---@type table<string, table<string, RegistrationSpec[]>>
local registry = {}

-- override with config.open_fn
---@param url string
local function open_fn(url)
  logger.debug("built-in open_fn called", url)
  vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
end

---@param url string | nil
local open = function(url)
  if url and url ~= "nil" then
    logger.debug("opening url", url)
    open_fn(url)
  else
    logger.info("url is nil, not opening", url)
  end
end

local function run_match_to_urls()
  logger.debug { registry = registry }

  local line_string = vim.api.nvim_get_current_line()
  local url = nil

  ---@class Match
  ---@field filetype string
  ---@field file_glob string

  ---@type Match[]
  local matches = {}
  local current_file = vim.fn.expand "%:p"

  for filetype, globs in pairs(registry) do
    if filetype == "*" or filetype == vim.bo.filetype then
      for file_glob, _ in pairs(globs) do
        local file_pattern = vim.fn.glob2regpat(file_glob)
        local match = vim.fn.matchstr(current_file, file_pattern)

        if match ~= "" or file_pattern == ".*" then
          logger.debug(
            "Found match for current file pattern",
            { current_file = current_file, file_pattern = file_pattern, match = match }
          )
          table.insert(matches, { filetype = filetype, file_glob = file_glob })
        end
      end
    end
  end

  logger.debug { matches = matches }

  ---@param registration RegistrationSpec
  ---@return string | nil
  local call_match_to_url = function(registration)
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
      logger.debug("url is not nil, returning", url)
      return url
    end
    logger.debug "url is nil, returning nil"
    return nil
  end

  local try_open = function(registration)
    local succeeded_url = call_match_to_url(registration)
    logger.debug("try_open", { pcall_succeeded = pcall_succeeded, succeeded_url = succeeded_url })

    if succeeded_url then
      logger.debug("try_open succeeded, opening", { succeeded_url = succeeded_url })
      open(succeeded_url)
    end
  end

  ---@type RegistrationSpec[]
  local matched_registrations = {}

  for _, match in ipairs(matches) do
    ---@type RegistrationSpec[]
    local registrations = registry[match.filetype][match.file_glob]
    for _, registration in ipairs(registrations) do
      table.insert(matched_registrations, registration)
    end
  end

  if #matched_registrations > 1 then
    logger.debug("More than 1 handler registered, showing select menu", { registration = matched_registrations })

    ---@class SucceededRegistration
    ---@field registration RegistrationSpec
    ---@field url string

    ---@type SucceededRegistration[]
    local succeeded_urls = {}
    for _, registration in ipairs(matched_registrations) do
      local succeeded_url = call_match_to_url(registration)

      logger.debug("succeeded_url", { succeeded_url = succeeded_url })

      if succeeded_url then
        local succeeded_registration = { registration = registration, url = succeeded_url }
        logger.debug("adding to succeeded_urls", succeeded_registration)
        table.insert(succeeded_urls, succeeded_registration)
      end
    end

    if #succeeded_urls == 0 then
      logger.info "No registrations succeeded"
      return
    end

    if #succeeded_urls == 1 then
      logger.debug("Only 1 registration succeeded, opening", { succeeded_url = succeeded_urls[1] })
      open(succeeded_urls[1].url)
      return
    end

    vim.ui.select(succeeded_urls, {
      prompt = "Multiple patterns matched. Select one:",
      format_item = function(item)
        return item.registration.name or vim.inspect(item.registration.patterns)
      end,
      ---@param succeeded_url SucceededRegistration
    }, function(succeeded_url)
      logger.debug("Selected", { succeeded_url = succeeded_url })
      if not succeeded_url then
        logger.debug "No registration selected"
        return
      end

      open(succeeded_url.url)
    end)
  else
    try_open(matched_registrations[1])
  end
end

--- Sets up the URL opener module.
---@class config table The configuration options.
---@field log_level number The log level for the logger module.
---@field open_fn fun(url: string) A function to open the URL.
function M.setup(config)
  ---@diagnostic disable-next-line: missing-parameter
  logger.set_log_level(config.log_level)

  if config.open_fn then
    open_fn = config.open_fn
    logger.debug "open_fn was overridden"
  end
  vim.keymap.set("n", "gx", run_match_to_urls, {})
  vim.keymap.set("v", "gx", run_match_to_urls, {})
end

---@class RegistrationSpec
---@field filetypes string[] The enumeration of supported filetypes
---@field patterns string[] A glob file pattern to match against the current file. See `:help glob()`.
---@field match_to_url fun(line_string: string): string | nil A function that takes the current line string and returns a url or nil.
---@field name string | nil A name to show in the select menu when multiple handlers are registered. This will be made required later on.

---@param options RegistrationSpec
function M.register(options)
  local filetypes = options.filetypes or { "*" }
  local patterns = options.patterns or { "*" }
  local match_to_url = options.match_to_url
  local name = options.name

  for _, filetype in ipairs(filetypes) do
    if not registry[filetype] then
      registry[filetype] = {}
    end
    for _, pattern in ipairs(patterns) do
      if not registry[filetype][pattern] then
        registry[filetype][pattern] = {}
      end
      table.insert(registry[filetype][pattern], {
        match_to_url = match_to_url,
        name = name,
      })
    end
  end

  logger.debug("registering", {
    name = name,
    filetypes = filetypes,
    patterns = patterns,
    match_to_url = match_to_url,
    registry = registry,
  })
end

return M
