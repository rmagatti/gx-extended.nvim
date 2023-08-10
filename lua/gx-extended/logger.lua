local L = {}
local plugin_name = "gx-extended"

---Function that handles vararg printing, so logs are consistent.
local function to_print(...)
  local args = { ... }
  if #args == 1 and type(...) == "table" then
    return vim.inspect(...)
  else
    local to_return = ""

    for _, value in ipairs(args) do
      to_return = vim.fn.join({ to_return, vim.inspect(value) }, " ")
    end

    return to_return
  end
end

function L:new(obj_and_config)
  obj_and_config = obj_and_config or {}

  self = vim.tbl_deep_extend("force", self, obj_and_config)
  self.__index = function(_, index)
    if type(self[index]) == "function" then
      return function(...)
        -- Make it so any call to logger with "." dot access for a function results in the syntactic sugar of ":" colon access
        self[index](self, ...)
      end
    else
      return self[index]
    end
  end

  setmetatable(obj_and_config, self)

  return obj_and_config
end

--- Sets the log level for the logger instance
--- @param log_level string|number: The log level to set. Can be a string or a vim.log.levels enum value.
function L:set_log_level(log_level)
  self.log_level = log_level
end

--- Writes a debug message to vim.notify, if the current log level is "debug".
--- @param ... string|table: The message(s) to print.
function L:debug(...)
  if self.log_level == "debug" or self.log_level == vim.log.levels.DEBUG then
    vim.notify(vim.fn.join({ plugin_name .. " DEBUG:", to_print(...) }, " "), vim.log.levels.DEBUG)
  end
end

--- Writes a debug message to vim.notify, if the current log level is "debug".
--- @param ... string|table: The message(s) to print.
function L:info(...)
  local valid_values = { "info", "debug", vim.log.levels.DEBUG, vim.log.levels.INFO }

  if vim.tbl_contains(valid_values, self.log_level) then
    vim.notify(vim.fn.join({ plugin_name .. " INFO:", to_print(...) }, " "), vim.log.levels.INFO)
  end
end

--- Writes a debug message to vim.notify, if the current log level is "debug".
--- @param ... string|table: The message(s) to print.
function L:warn(...)
  local valid_values = { "info", "debug", "warn", vim.log.levels.DEBUG, vim.log.levels.INFO, vim.log.levels.WARN }

  if vim.tbl_contains(valid_values, self.log_level) then
    vim.notify(vim.fn.join({ plugin_name .. " WARN:", to_print(...) }, " "), vim.log.levels.WARN)
  end
end

--- Writes a debug message to vim.notify, if the current log level is "debug".
--- @param ... string|table: The message(s) to print.
function L:error(...)
  vim.notify(vim.fn.join({ plugin_name .. " ERROR:", to_print(...) }, " "), vim.log.levels.ERROR)
end

return L
