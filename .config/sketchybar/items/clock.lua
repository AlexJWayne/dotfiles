local clock = sbar.add("item", 'clock', {
    icon = {
        padding_left = 12,
        padding_right = 12,
        font = {
            family = "SF Pro",
            size   = 14,
        }
    },
    label = {
        padding_right = 12,
        font = {
            family = "SF Pro",
        }
    },
    background = {
        color = 0x44000000,
    },

    -- position = "right", -- Laptop screen
    position = "center", -- Desktop screen
    update_freq = 10,
})

local function update()
    local date = string.gsub(os.date("%a %b %e"), "%s+", " ")
    local time = string.gsub(os.date("%I:%M"), "^0", "")
    clock:set({ icon = date, label = time })
end

clock:subscribe("routine", update)
clock:subscribe("forced", update)
