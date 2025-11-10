local M = {}

local match_to_url = function(line_string)
    -- Match [text](url) pattern
    local url = string.match(line_string, "%[.-%]%((.-)%)")

    if not url then
        return nil
    end

    -- Handle www. URLs by adding https://
    if url:match("^www%.") then
        url = "https://" .. url
    end

    -- Only return if it looks like a valid URL
    if url:match("^https?://") or url:match("^www%.") then
        return url
    end

    return nil
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "**/*.md", "**/*.markdown" },
        name = "Markdown Links",
        match_to_url = match_to_url,
    }
end

return M
