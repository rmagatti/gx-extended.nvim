local M = {}

local match_to_url = function(line_string)
    -- Match: import ... from "package-name"
    local package_name = string.match(line_string, 'from%s+["\']([%w@_-][%w@/_-]*)["\']')

    if not package_name then
        -- Match: import "package-name"
        package_name = string.match(line_string, 'import%s+["\']([%w@_-][%w@/_-]*)["\']')
    end

    if not package_name then
        -- Match: require("package-name")
        package_name = string.match(line_string, 'require%(["\']([%w@_-][%w@/_-]*)["\']%)')
    end

    if not package_name then
        return nil
    end

    -- Skip relative imports (starting with . or /)
    if package_name:match("^%.") or package_name:match("^/") then
        return nil
    end

    -- Handle scoped packages (@org/package) - extract just the package part
    local scoped_package = string.match(package_name, "^(@[%w_-]+/[%w_-]+)")
    if scoped_package then
        package_name = scoped_package
    else
        -- For regular packages, get just the package name (not subpaths)
        package_name = string.match(package_name, "^([%w@_-]+)")
    end

    if not package_name then
        return nil
    end

    local url = "https://www.npmjs.com/package/" .. package_name

    return url
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "**/*.js", "**/*.jsx", "**/*.ts", "**/*.tsx", "**/*.mjs", "**/*.cjs" },
        name = "NPM Package Imports",
        match_to_url = match_to_url,
    }
end

return M
