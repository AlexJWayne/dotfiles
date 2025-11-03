local colors = require("colors")
local settings = require("settings")

-- local item_order = ""

local app_icons = {
    _default_ = "󰫈",
    ["1Password"] = "",
    ["Arc"] = "",
    ["Finder"] = "󰀶",
    ["GitHub Desktop"] = "",
    ["Graphite"] = "",
    ["Jira"] = "",
    ["Logic Pro"] = "󰎇",
    ["Microsoft Outlook"] = '󰇮',
    ["Microsoft Teams"] = '󰊻',
    ["Preview"] = "",
    ["PrusaSlicer"] = "󰹛",
    ["Safari"] = "󰀹",
    ["Spotify"] = "",
    ["System Settings"] = "",
    ["WezTerm"] = "",
    ["Zed"] = "󰅩",
}

local alpha_icons = {
    a = utf8.char(0xF0B08),
    b = utf8.char(0xF0B09),
    c = utf8.char(0xF0B0A),
    d = utf8.char(0xF0B0B),
    e = utf8.char(0xF0B0C),
    f = utf8.char(0xF0B0D),
    g = utf8.char(0xF0B0E),
    h = utf8.char(0xF0B0F),
    i = utf8.char(0xF0B10),
    j = utf8.char(0xF0B11),
    k = utf8.char(0xF0B12),
    l = utf8.char(0xF0B13),
    m = utf8.char(0xF0B14),
    n = utf8.char(0xF0B15),
    o = utf8.char(0xF0B16),
    p = utf8.char(0xF0B17),
    q = utf8.char(0xF0B18),
    r = utf8.char(0xF0B19),
    s = utf8.char(0xF0B1A),
    t = utf8.char(0xF0B1B),
    u = utf8.char(0xF0B1C),
    v = utf8.char(0xF0B1D),
    w = utf8.char(0xF0B1E),
    x = utf8.char(0xF0B1F),
    y = utf8.char(0xF0B20),
    z = utf8.char(0xF0B21),
}



---@type {
---    [string]: {
---        workspace: string,
---        focused: boolean,
---        items: {
---            space: unknown,
---            bracket: unknown,
---            padding: unknown,
---            apps: { [string]: unknown },
---        },
---        apps: { [string]: {
---            workspace: string,
---            name: string,
---            bundle_id: string,
---            pid: number,
---        } }[],
---    },
---}
local data = {}
local current_app_name = ""

print('--- Spaces Init ---')

---@param t { [string]: any }
---@return string[]
local getKeysSorted = function(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    table.sort(keys)
    return keys
end

local get_has_apps = function(space_name)
    for _, _ in pairs(data[space_name].apps) do
        return true
    end
    return false
end

---@param callback fun()
local get_data = function(callback)
    sbar.exec("aerospace list-workspaces --all --json --format '%{workspace}%{workspace-is-focused}'", function(spaces)
        for _, space in ipairs(spaces) do
            local space_data                = data[space.workspace] or {
                items = { apps = {} },
            }
            data[space.workspace]           = space_data
            data[space.workspace].apps      = {}
            data[space.workspace].workspace = space.workspace
            data[space.workspace].focused   = space['workspace-is-focused']
        end

        sbar.exec("aerospace list-windows --all --json --format '%{app-bundle-id}%{app-name}%{workspace}%{app-pid}'",
            function(windows)
                for _, window in ipairs(windows) do
                    data[window.workspace].apps[window['app-name']] = {
                        workspace = window['workspace'],
                        name = window['app-name'],
                        bundle_id = window['app-bundle-id'],
                        pid = window['app-pid'],
                    }
                end

                callback()
            end)
    end)
end


---@param space_name string
local add_space_item = function(space_name)
    data[space_name].items.space = sbar.add("item", "space." .. space_name, 'left', {
        label = {
            padding_left = -3
        }
    })
end

---@param space_name string
local update_space_item = function(space_name)
    local space_item = data[space_name].items.space
    local has_apps = get_has_apps(space_name)
    space_item:set({ label = space_name .. (has_apps and "" or "") })
    sbar.animate("tanh", 10, function()
        space_item:set({
            label = {
                color = data[space_name].focused and 0xffffffff or 0x44ffffff,
            }
        })
    end)
end

---@param space_name string
local add_app_item = function(space_name, app)
    local app_item_name = "space." .. space_name .. ".apps." .. app.bundle_id
    local app_item = sbar.add("item", app_item_name, 'left', {
        icon = {
            padding_left = 0,
            padding_right = 0,
            font = {
                size = 20
            }
        }
    })
    data[space_name].items.apps[app.bundle_id] = app_item
    data[space_name].items.apps[app.bundle_id].app_name = app.name

    local alpha_icon = alpha_icons[app.name:sub(1, 1):lower()]
    -- print(app.name)
    local icon = app_icons[app.name] or alpha_icon or app_icons._default_
    app_item:set({ icon = icon })
end

local update_app_items = function(space_name)
    for _, app_item in pairs(data[space_name].items.apps) do
        local color = app_item.app_name == current_app_name and 0xddffffff or 0x44ffffff
        if not data[space_name].focused then color = 0x44ffffff end
        sbar.animate("tanh", 10, function()
            app_item:set({ icon = { color = color } })
        end)
    end
end

---@param space_name string
local add_space_bracket = function(space_name)
    local has_apps = get_has_apps(space_name)

    local space_bracket_name = "space." .. space_name .. ".bracket"
    local spaces_in_bracket = { '/space\\.' .. space_name .. ".*/" }
    local space_bracket = sbar.add(
        "bracket",
        space_bracket_name,
        spaces_in_bracket,
        {
            background = { color = has_apps and 0x44000000 or 0x00000000 },
        })
    data[space_name].items.bracket = space_bracket


    local space_padding = sbar.add("item", "space." .. space_name .. ".padding",
        { '/space\\.' .. space_name .. ".*/" },
        { width = 4 })
    data[space_name].items.padding = space_padding
end

---@param space_name string
local update_space_bracket = function(space_name)
    local has_apps = get_has_apps(space_name)
    local color = 0x00000000
    if has_apps then
        if data[space_name].focused then
            color = 0xaa000000
        else
            color = 0x44000000
        end
    end

    sbar.animate("tanh", 10, function()
        data[space_name].items.bracket:set({
            background = {
                color = color,
                border_color = has_apps and data[space_name].focused and 0xff2e81e6 or 0x00000000,
                border_width = 2

            }
        })
    end)
end


local add_items = function()
    local space_names = getKeysSorted(data)
    for _, space_name in ipairs(space_names) do
        add_space_item(space_name)
        update_space_item(space_name)

        for _, app in pairs(data[space_name].apps) do
            add_app_item(space_name, app)
        end
        update_app_items(space_name)

        add_space_bracket(space_name)
        update_space_bracket(space_name)
    end
end

local remove_all = function()
    for _, space in pairs(data) do
        local items = space.items
        for _, app in pairs(items.apps) do
            sbar.remove(app.name)
        end
        sbar.remove(items.space.name)
        sbar.remove(items.bracket.name)
        sbar.remove(items.padding.name)
    end
end


local space_controller = sbar.add("item", "space.controller")
space_controller:subscribe("aerospace_workspace_change", function()
    get_data(function()
        for _, space_name in ipairs(getKeysSorted(data)) do
            update_space_item(space_name)
            update_space_bracket(space_name)
            update_app_items(space_name)
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
    current_app_name = env.INFO
    for space_name in pairs(data) do
        update_app_items(space_name)
    end
end)


local foo = function()
    sbar.exec("aerospace list-workspaces --all", function(spaces)
        for space_name in spaces:gmatch("[^\r\n]+") do
            local space = sbar.add("item", "space." .. space_name, {
                icon = {
                    -- font = { family = settings.font.numbers },
                    string = string.sub(space_name, 3),

                    padding_left = 7,
                    padding_right = 3,
                    color = colors.white,
                    highlight_color = colors.red,
                },
                label = {
                    padding_right = 12,
                    color = colors.grey,
                    highlight_color = colors.white,
                    font = "sketchybar-app-font:Regular:16.0",
                    y_offset = -1,
                },
                padding_right = 1,
                padding_left = 1,
                background = {
                    color = colors.bg1,
                    border_width = 1,
                    height = 26,
                    border_color = colors.black,
                }
            })

            local space_bracket = sbar.add("bracket", { space.name }, {
                background = {
                    color = colors.transparent,
                    border_color = colors.bg2,
                    height = 28,
                    border_width = 2
                }
            })

            -- Padding space
            local space_padding = sbar.add("item", "space.padding." .. space_name, {
                script = "",
                width = settings.group_paddings,
            })

            space:subscribe("aerospace_workspace_change", function(env)
                local selected = env.FOCUSED_WORKSPACE == space_name
                local color = selected and colors.grey or colors.bg2
                space:set({
                    icon = { highlight = selected, },
                    label = { highlight = selected },
                    background = { border_color = selected and colors.black or colors.bg2 }
                })
                space_bracket:set({
                    background = { border_color = selected and colors.grey or colors.bg2 }
                })
            end)

            space:subscribe("mouse.clicked", function()
                sbar.exec("aerospace workspace " .. space_name)
            end)



            space:subscribe("space_windows_change", function()
                sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
                    print(windows)
                    local no_app = true
                    local icon_line = ""
                    for app in windows:gmatch("[^\r\n]+") do
                        no_app = false
                        local lookup = app_icons[app]
                        local icon = ((lookup == nil) and app_icons["default"] or lookup)
                        icon_line = icon_line .. " " .. icon
                    end

                    if (no_app) then
                        icon_line = " —"
                    end
                    sbar.animate("tanh", 10, function()
                        space:set({ label = icon_line })
                    end)
                end)
            end)

            item_order = item_order .. " " .. space.name .. " " .. space_padding.name
        end
        -- sbar.exec("sketchybar --reorder apple " .. item_order .. " front_app")
    end)
end
