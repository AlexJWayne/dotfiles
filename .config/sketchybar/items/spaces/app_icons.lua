local default = "󰫈"

local apps = {
    ["1Password"] = "",
    ["Arc"] = "",
    ["Finder"] = "󰀶",
    ["GitHub Desktop"] = "",
    ["Graphite"] = "",
    ["Jira"] = "",
    ["Logic Pro"] = "󰎇",
    ["Microsoft Excel"] = '󱎏',
    ["Microsoft Outlook"] = '󰇮',
    ["Microsoft Teams"] = '󰊻',
    ["Numbers"] = "",
    ["Preview"] = "",
    ["PrusaSlicer"] = "󰹛",
    ["Safari"] = "󰀹",
    ["Spotify"] = "",
    ["Slack"] = "",
    ["System Settings"] = "",
    ["WezTerm"] = "",
    ["Zed"] = "󰅩",
}

local letters = {
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

return {
    get =
    ---@param app_name string
    ---@return string
        function(app_name)
            return apps[app_name] or letters[string.lower(app_name:sub(1, 1))] or default
        end,
}
