local space_items = require("items.spaces.space_items")

---@param space_name string
local add_space_bracket = function(space_name)
    local has_apps = space_items.has_apps(space_name)
    local space_bracket_name = "space." .. space_name .. ".bracket"
    local spaces_in_bracket = { '/space\\.' .. space_name .. ".*/" }
    local space_bracket = sbar.add(
        "bracket",
        space_bracket_name,
        spaces_in_bracket,
        {
            blur_radius = 10,
            background = {
                color = has_apps and 0x88000000 or 0x00000000,
                border_width = 2,
            }
        })
    data[space_name].items.bracket = space_bracket
end


local add_apps_bracket = function(space_name)
    local apps_bracket_name = "space." .. space_name .. ".apps_bracket"
    local apps_in_bracket = { '/space\\.' .. space_name .. "\\.apps\\..*/" }
    local apps_bracket = sbar.add("bracket", apps_bracket_name, apps_in_bracket, {
        background = {
            border_width = 2,
        }
    })
    data[space_name].items.apps_bracket = apps_bracket
end

local add_space_padding = function(space_name)
    local big_space = space_name == "C" or space_name == "T" or space_name == "O"


    local space_padding_name = "space." .. space_name .. ".padding"
    local space_padding = sbar.add(
        "item",
        space_padding_name,
        { width = big_space and 32 or 4 }
    )
    data[space_name].items.padding = space_padding
end

---@param space_name string
local add = function(space_name)
    add_space_bracket(space_name)

    if space_items.has_apps(space_name) then
        add_apps_bracket(space_name)
    end

    add_space_padding(space_name)
end

---@param space_name string
local update = function(space_name)
    local has_apps = space_items.has_apps(space_name)
    -- if not has_apps then return end


    local space_color = 0x00000000
    if has_apps then
        if data[space_name].focused then
            space_color = 0xff2e81e6
        else
            space_color = 0x44000000
        end
    end

    local apps_color = 0x00000000
    if has_apps and data[space_name].focused then
        apps_color = 0xff06264f
    end

    local border_color = 0x00000000
    if has_apps then
        if data[space_name].focused then
            border_color = 0xff2e81e6
        else
            border_color = 0x44888888
        end
    end

    animate(function()
        data[space_name].items.bracket:set({
            background = {
                color = space_color,
                border_color = border_color,
            }
        })

        if (data[space_name].items.apps_bracket) then
            data[space_name].items.apps_bracket:set({
                background = {
                    color = apps_color,
                    border_color = data[space_name].focused and border_color or 0x00000000,
                }
            })
        end
    end)
end


return {
    add = add,
    update = update,
}
