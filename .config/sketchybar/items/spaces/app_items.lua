local app_icons = require("items.spaces.app_icons")

---@param space_name string
local add = function(space_name, app)
    local app_item_name = "space." .. space_name .. ".apps." .. app.bundle_id
    local app_item = sbar.add("item", app_item_name, 'left', {
        icon = {
            padding_left = 4,
            padding_right = 2,
            font = {
                size = 22
            }
        },
        label = {
            drawing = false
        }
    })
    data[space_name].items.apps[app.bundle_id] = app_item
    data[space_name].items.apps[app.bundle_id].app_name = app.name

    -- print(app.name)
    app_item:set({ icon = app_icons.get(app.name) })
end


local update = function(space_name)
    for _, app_item in pairs(data[space_name].items.apps) do
        local color = app_item.app_name == current_app_name and 0xddffffff or 0x44ffffff
        if not data[space_name].focused then color = 0x44ffffff end
        -- sbar.animate("tanh", 10, function()
        app_item:set({ icon = { color = color } })
        -- end)
    end
end

return {
    add = add,
    update = update,
}
