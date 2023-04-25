local logger = require("gx-extended.logger"):new({ log_level = vim.log.levels.INFO })

local M = {}

local registry = {}

local function run_match_to_urls()
	local line_string = vim.api.nvim_get_current_line()
	local url, matched_pattern = nil, nil

	local current_file = vim.fn.expand("%:t")

	for file_pattern, _ in pairs(registry) do
		local match = string.match(current_file, file_pattern)

		if match then
			logger.debug(
				"Found match for current file pattern",
				{ current_file = current_file, file_pattern = file_pattern, match = match }
			)

			matched_pattern = file_pattern
		end
	end

	if matched_pattern then
		for _, pattern_value in ipairs(registry[matched_pattern]) do
			logger.debug("pattern_value", pattern_value)

			local pcall_succeeded, _return = pcall(pattern_value.match_to_url, line_string)
			url = pcall_succeeded and _return or nil

			logger.debug("match_to_url called", {
				line_string = line_string,
				success = pcall_succeeded,
				url = url,
				pattern_value = pattern_value,
			})

			if url then
				vim.api.nvim_call_function("netrw#BrowseX", { url, 0 })
				break
			end
		end
	end

	if not url then
		logger.debug("Could not match custom gx-extended pattern, calling default gx")

		vim.cmd([[execute "normal \<Plug>NetrwBrowseX"]])
		return
	end
end

function M.setup(config)
	logger.set_log_level(config.log_level)

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
