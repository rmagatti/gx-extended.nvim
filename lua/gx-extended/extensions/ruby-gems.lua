local M = {}

local match_to_url = function(line_string)
    -- Match: gem "package-name" or gem 'package-name'
    local gem = string.match(line_string, "gem%s+['\"]([%w_-]+)['\"]")

    if not gem then
        -- Match: spec.add_dependency "package-name"
        gem = string.match(line_string, "spec%.add_dependency%s+['\"]([%w_-]+)['\"]")
    end

    if not gem then
        -- Match: spec.add_development_dependency "package-name"
        gem = string.match(line_string, "spec%.add_development_dependency%s+['\"]([%w_-]+)['\"]")
    end

    if not gem then
        return nil
    end

    local url = "https://rubygems.org/gems/" .. gem

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "**/Gemfile", "**/*.gemspec" },
        name = "RubyGems",
        match_to_url = match_to_url,
    }
end

return M
