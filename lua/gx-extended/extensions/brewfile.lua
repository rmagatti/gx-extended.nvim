local M = {}

local match_to_url = function(line_string)
    -- Match brew "package"
    local brew = string.match(line_string, 'brew%s+"([^"]+)"')
    if brew then
        return "https://formulae.brew.sh/formula/" .. brew
    end

    -- Match cask "package"
    local cask = string.match(line_string, 'cask%s+"([^"]+)"')
    if cask then
        return "https://formulae.brew.sh/cask/" .. cask
    end

    return nil
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "**/Brewfile" },
        name = "Homebrew",
        match_to_url = match_to_url,
    }
end

return M
