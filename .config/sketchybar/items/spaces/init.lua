require("items.spaces.globals")

local space_items = require("items.spaces.space_items")
local space_brackets = require("items.spaces.space_brackets")
local app_items = require("items.spaces.app_items")
local get_data = require("items.spaces.get_data")


print('--- Spaces Init ---')


local add_items = function()
    ---@diagnostic disable-next-line: lowercase-global
    do_animate = false
    local space_names = space_items.sort_spaces()
    for _, space_name in ipairs(space_names) do
        space_items.add(space_name)
        space_items.update(space_name)

        for _, app in pairs(data[space_name].apps) do
            app_items.add(space_name, app)
        end
        app_items.update(space_name)

        space_brackets.add(space_name)
        space_brackets.update(space_name)
    end
    ---@diagnostic disable-next-line: lowercase-global
    do_animate = true
end

local remove_all = function()
    for _, space in pairs(data) do
        local items = space.items
        for _, app in pairs(items.apps) do
            sbar.remove(app.name)
        end
        if items.space then sbar.remove(items.space.name) end
        if items.bracket then sbar.remove(items.bracket.name) end
        if items.apps_bracket then sbar.remove(items.apps_bracket.name) end
        if items.padding then sbar.remove(items.padding.name) end
    end
    ---@diagnostic disable-next-line: lowercase-global
    data = {}
end

local space_controller = sbar.add("item", "space.controller")
space_controller:subscribe("aerospace_workspace_change", function()
    get_data(function()
        for _, space_name in ipairs(space_items.sort_spaces()) do
            space_items.update(space_name)
            space_brackets.update(space_name)
            app_items.update(space_name)
        end
    end)
end)

space_controller:subscribe("space_windows_change", function()
    remove_all()
    get_data(add_items)
end)

space_controller:subscribe("moved_app_workspace", function()
    remove_all()
    get_data(add_items)
end)

space_controller:subscribe("front_app_switched", function(env)
    ---@diagnostic disable-next-line: lowercase-global
    current_app_name = env.INFO
    for space_name in pairs(data) do
        app_items.update(space_name)
    end
end)
