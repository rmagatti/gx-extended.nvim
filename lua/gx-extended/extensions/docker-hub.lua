local M = {}

local match_to_url = function(line_string)
    -- Match: FROM user/repo:tag or FROM user/repo
    local user_image = string.match(line_string, "FROM%s+([%w._-]+/[%w._-]+)")

    if user_image then
        -- Remove tag if present
        user_image = user_image:gsub(":.*$", "")
        return "https://hub.docker.com/r/" .. user_image
    end

    -- Match: image: user/repo:tag in docker-compose
    user_image = string.match(line_string, "image:%s+([%w._-]+/[%w._-]+)")

    if user_image then
        user_image = user_image:gsub(":.*$", "")
        return "https://hub.docker.com/r/" .. user_image
    end

    -- Match official images: FROM nginx:tag or FROM nginx
    local official = string.match(line_string, "FROM%s+([^/:]+):")

    if not official then
        -- Match: FROM nginx (no tag)
        official = string.match(line_string, "FROM%s+([^/:]+)%s*$")
    end

    if official then
        return "https://hub.docker.com/_/" .. official
    end

    -- Match official images in docker-compose: image: nginx:tag
    official = string.match(line_string, "image:%s+([^/:]+):")

    if not official then
        official = string.match(line_string, "image:%s+([^/:]+)%s*$")
    end

    if official then
        return "https://hub.docker.com/_/" .. official
    end

    return nil
end

function M.setup(config)
    require("gx-extended.lib").register {
        patterns = { "**/Dockerfile*", "**/docker-compose.yml", "**/docker-compose.yaml" },
        name = "Docker Hub",
        match_to_url = match_to_url,
    }
end

return M
