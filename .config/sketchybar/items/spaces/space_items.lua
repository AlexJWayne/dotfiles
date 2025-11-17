local spaces_order = {
    'A', 'R', 'S', 'T',
    'N', 'E', 'I', 'O',
    'Z', 'X', 'C',
}


---@param array string[]
---@param value string
local function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then return i end
    end
    return -1
end

---@return string[]
local sort_spaces = function()
    local keys = {}
    for k in pairs(data) do
        table.insert(keys, k)
    end
    table.sort(keys, function(k1, k2)
        return indexOf(spaces_order, k1) < indexOf(spaces_order, k2)
    end)
    return keys
end

---@param space_name string
---@return boolean
local has_apps = function(space_name)
    for _, _ in pairs(data[space_name].apps) do
        return true
    end
    return false
end

---@param space_name string
---@return boolean
local has_no_apps = function(space_name)
    return not has_apps(space_name)
end


---@param space_name string
local add = function(space_name)
    -- if has_no_apps(space_name) then return end
    data[space_name].items.space = sbar.add("item", "space." .. space_name, {
        label = {
            padding_left = -2
        }
    })
end

local update = function(space_name)
    -- if has_no_apps(space_name) then return end

    local space_item = data[space_name].items.space
    space_item:set({ label = space_name })
    animate(function()
        space_item:set({
            label = {
                color = data[space_name].focused and 0xffffffff or 0xaaffffff,
            }
        })
    end)
end

return {
    sort_spaces = sort_spaces,
    has_apps = has_apps,
    has_no_apps = has_no_apps,

    add = add,
    update = update,
}
