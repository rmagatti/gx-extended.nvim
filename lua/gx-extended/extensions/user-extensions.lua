local lib = require("gx-extended.lib")

local M = {}

function M.setup(config)
	local logger = require("gx-extended.logger"):new({ log_level = config.log_level })

	local registration_success, _ = pcall(function()
		for _, registration in pairs(config.extensions) do
			local success, _ = pcall(lib.register, registration)

			if not success then
				logger.warn("Failed to register gx-extended autocmd for " .. registration.patterns)
			end
		end
	end)

	if not registration_success then
		logger.warn("Did not register user extensions")
	end
end

return M
