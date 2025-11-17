local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
    height = 40,
    color = colors.bar.bg,
    sticky = true,
    padding_right = 8,
    padding_left = 8,
    blur_radius = 0,
    topmost = "window",
    -- y_offset = 32, -- Put under notch
})
