local awful = require("awful")
local xresources = require("beautiful.xresources")
local theme_assets = require("beautiful.theme_assets")
local theme = require("theme")
local dpi = xresources.apply_dpi

local square_size = dpi(0)

local widget = function(screen)
	return awful.widget.taglist({
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		style = {
			spacing = -5,
			squares_unsel = theme_assets.taglist_squares_unsel(
				square_size, theme.fg_normal
			),
			squares_sel = theme_assets.taglist_squares_sel(
				square_size, theme.fg_normal
			),
			font = "JetBrainsMono Nerd Font Bold 0",
		},
	})
end

return {
	widget = widget,
}
