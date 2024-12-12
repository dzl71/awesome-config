local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local widget_utils = require("widgets.utils")

-- =================================
--		defining util functios
-- =================================

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- ======================================
--     defining small widgets presets
-- ======================================

local keyboard_layout = widget_utils.widget_base("#f8c8dc")
keyboard_layout:inject_info(
	wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		{
			widget = wibox.container.margin,
			wibox.widget.textbox("󰌌 "),
			right = -10
		},
		awful.widget.keyboardlayout:new(),
	})
)

local date_and_time = widget_utils.widget_base("#c3b1e1")
date_and_time:inject_info(awful.widget.textclock("%T %a %d.%m.%Y", 1)
)

-- ======================
--		load widgets
-- ======================

local corner = require("widgets.corner")
local taglist = require("widgets.taglist").widget
local wifi = require("widgets.wifi").widget
local temperature = require("widgets.temperature").widget
local ram = require("widgets.ram").widget
local cpu = require("widgets.cpu").widget
local volume = require("widgets.volume").widget
local brightness = require("widgets.brightness").widget
local battery = require("widgets.battery").widget

-- ==================================
--		configuring the screen
-- ==================================


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	for i = 1, 10 do
		awful.tag.add(
			i,
			{
				index = i,
				screen = s,
				layout = awful.layout.layouts[1],
				master_count = 1,
			})
	end


	-- Create a promptbox for each screen
	-- s.mypromptbox = awful.widget.prompt()

	-- ============================
	--		defining the bar
	-- ============================

	-- Create the wibox
	s.mywibox = awful.wibar({
		border_width = 5,
		position = "top",
		screen = s,
		fg = "#ffffff",
		height = 35,
		bg = "#00000000",
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		-- Left widgets
		{
			layout = wibox.layout.fixed.horizontal,
			corner.left({ right = -15 }),
			taglist(s),
			corner.right({ left = -15 }),
			wibox.widget.textbox(" "),
			wibox.widget.systray(),
		},
		-- middle widget
		{
			layout = wibox.layout.fixed.horizontal,
			{
				widget = wibox.widget.separator,
				opacity = 0,
				visible = true,
				forced_width = 350,
			},
			corner.left({ right = -15 }),
			date_and_time(),
			corner.right({ left = -15 }),
		},
		-- Right widgets
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 10,
			corner.left({ right = -20 }),
			battery,
			volume,
			brightness,
			wifi,
			cpu,
			ram,
			temperature,
			keyboard_layout(),
			corner.right({ left = -35 }),
		},
	})
end)
