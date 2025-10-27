-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.window_decorations = 'RESIZE'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
-- config.tab_bar_at_bottom = true
config.font_size = 15
config.tab_max_width = 24

config.colors = {
    background = "#222222"
}


wezterm.on(
    'format-tab-title',
    function(tab)
        return "  " .. tab.active_pane.title .. "  " -- two spaces on each side
    end
)

-- Finally, return the configuration to wezterm:
return config
