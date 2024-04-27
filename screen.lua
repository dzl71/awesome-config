local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")

-- ===========================
--    defining variables
-- ===========================

local fixed_horizontal = wibox.layout.fixed.horizontal

---@type integer
local tags_num = 4

---@type string
local even_color = "#8a2be2"

---@type string
local odd_color = "#7b68ee"

---@type number
local left_margin = 10

---@type number
local right_margin = 20

-- =================================
--		defining util functios
-- =================================

---@param widget any
---@param color string
---@return any
local function theme(widget, color, margin_right)
	widget.widget = wibox.widget {
		widget.widget,
		widget = wibox.container.margin,
		left = 10,
		right = margin_right,
	}
	widget.shape = gears.shape.rounded_bar
	widget.bg = color
	widget.default_bg = color
	return widget
end


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

---@type table
local KeyboardLayout = wibox.widget {
	widget = wibox.container.background,
	{
		layout = wibox.layout.fixed.horizontal,
		{
			widget = wibox.container.margin,
			wibox.widget.textbox("󰌌 "),
			right = -10
		},
		awful.widget.keyboardlayout:new(),
	}
}
local Date = wibox.widget {
	widget = wibox.container.background,
	awful.widget.textclock("󰃱  %d-%m-%Y %a ", 1)
}

local Time = wibox.widget {
	widget = wibox.container.background,
	awful.widget.textclock("  %T ", 1)
}

-- ====================================
--		setup widget initializers
-- ====================================

local wifi_init = require "widgets.wifi"
local temperature_init = require "widgets.temperature"
local ram_init = require "widgets.ram"
local cpu_init = require "widgets.cpu"
local volume_init = require "widgets.volume"
local brightness_init = require "widgets.brightness"
local battery_init = require "widgets.battery"

-- ====================================
--	   setup always visible widgets
-- ====================================


local tag_container = function(screen)
	return theme(
		wibox.widget {
			widget = wibox.container.background,
			screen.mytaglist
		},
		even_color,
		10
	)
end
local wifi = wifi_init(odd_color, left_margin, right_margin)
local temperature = temperature_init(even_color, left_margin, right_margin)
local ram = ram_init(odd_color, left_margin, right_margin)
local cpu = cpu_init(even_color, left_margin, right_margin)
local volume = volume_init(odd_color, left_margin, right_margin)
local brightness = brightness_init(even_color, left_margin, right_margin)
local battery = battery_init(odd_color, left_margin, right_margin)
local keyboard_layout = theme(KeyboardLayout, even_color, right_margin)
local date = theme(Date, odd_color, right_margin)
local time = theme(Time, even_color, right_margin)
local layout_box = function(screen)
	return theme(
		wibox.widget {
			widget = wibox.container.background,
			screen.mylayoutbox,
		},
		odd_color,
		15
	)
end

-- ====================================
--    collect manual widget updaters
-- ====================================

local widget_updaters = {
	volume_updater = volume.updater,
	brightness_updater = brightness.updater,
}

-- ==================================
--		configuring the screen
-- ==================================


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	-- awful.tag({ "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])
	for i = 1, tags_num do
		awful.tag.add(
			i, --"",
			{
				index = i,
				screen = s,
				layout = awful.layout.layouts[1],
				master_count = 1,
				icon = string.format("%s/icons/numeric-%d-circle-outline.svg", gears.filesystem.get_dir("config"), i),
			})
	end


	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
	}

	-- ============================
	--		defining the bar
	-- ============================

	-- Create the wibox
	s.mywibox = awful.wibar({
		border_width = 13,
		position = "top",
		screen = s,
		fg = "#ffffff",
		height = 27,
		bg = "#00000000",
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		-- Left widgets
		{
			layout = fixed_horizontal,
			tag_container(s),
			wibox.widget.textbox(" "),
			wibox.widget.systray(),
		},
		-- middle widget
		wibox.widget.base.empty_widget(),
		-- Right widgets
		{
			layout = fixed_horizontal,
			spacing = -20,
			wifi,
			temperature,
			ram,
			cpu,
			volume.widget,
			brightness.widget,
			battery,
			keyboard_layout,
			date,
			time,
			layout_box(s),
		},
	})
end)

return widget_updaters
