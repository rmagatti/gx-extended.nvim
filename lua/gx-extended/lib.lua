local logger = require("gx-extended.logger"):new { log_level = vim.log.levels.INFO }

local M = {}

local registry = {}

-- override with config.open_fn
local function open_fn(url)
  vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
end

local function run_match_to_urls()
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

  local keep_going = true
  for _, matched_pattern in ipairs(matched_patterns) do
    if keep_going then
      for _, extension in ipairs(registry[matched_pattern]) do
        logger.debug("pattern_value", extension)

        local pcall_succeeded, _return = pcall(extension.match_to_url, line_string)
        url = pcall_succeeded and _return or nil

        logger.debug("match_to_url called", {
          line_string = line_string,
          success = pcall_succeeded,
          url = url or "nil",
          extension = extension,
        })

        if url ~= nil and url ~= "nil" then
          logger.debug("opening url", { url = url, success = pcall_succeeded })
          open_fn(url)
          keep_going = false
          break
        end
      end
    end
  end

  if not url then
    logger.debug "Could not match custom gx-extended pattern, calling default gx"

    vim.cmd [[execute "normal \<Plug>NetrwBrowseX"]]
    return
  end
end

function M.setup(config)
  logger.set_log_level(config.log_level)

  if config.open_fn then
    open_fn = config.open_fn
  end
  vim.keymap.set("n", "gx", run_match_to_urls, {})
end

function M.register(options)
  local patterns = options.patterns
  local match_to_url = options.match_to_url

  for _, pattern in ipairs(patterns) do
    if not registry[pattern] then
      registry[pattern] = {}
    end

    table.insert(registry[pattern], {
      match_to_url = match_to_url,
    })
  end

  logger.debug("registering", {
    patterns = patterns,
    match_to_url = match_to_url,
    registry = registry,
  })
end

return M
