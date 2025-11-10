local M = {}

local match_to_url = function(line_string)
    -- Match: github.com/user/repo v1.2.3
    local pkg = string.match(line_string, "([%w%.%-_/]+)%s+v[%d%.]+")

    if not pkg then
        -- Match: require github.com/user/repo
        pkg = string.match(line_string, "require%s+([%w%.%-_/]+)")
    end

    if not pkg then
        -- Match: import "github.com/user/repo"
        pkg = string.match(line_string, 'import%s+"([%w%.%-_/]+)"')
    end

    if not pkg then
        -- Match standalone package path (common in go.sum)
        pkg = string.match(line_string, "^([%w%.%-_]+/[%w%.%-_/]+)")
    end

    if not pkg then
        return nil
    end

    local url = "https://pkg.go.dev/" .. pkg

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "**/go.mod", "**/go.sum" },
        name = "Go Packages",
        match_to_url = match_to_url,
    }
end

return M
