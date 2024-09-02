local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local widget_utils = require("widgets.utils")

-- ===========================
--    defining variables
-- ===========================

local fixed_horizontal = wibox.layout.fixed.horizontal

---@type integer
local tags_num = 4

---@type string
local color_odd = "#8a2be2"

---@type string
local color_even = "#7b68ee"

---@type number
local left_margin = 10

---@type number
local right_margin = 30

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

local keyboard_layout = widget_utils.widget_base()
widget_utils.inject_widget_info(
	keyboard_layout,
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

local date = widget_utils.widget_base()
widget_utils.inject_widget_info(
	date,
	awful.widget.textclock("󰃱  %d-%m-%Y %a ", 3600)
)

local time = widget_utils.widget_base()
widget_utils.inject_widget_info(
	time,
	awful.widget.textclock("  %T ", 1)
)

local layout_box = function(screen)
	local lbox = widget_utils.widget_base()
	widget_utils.inject_widget_info(
		lbox,
		awful.widget.layoutbox(screen)
	)
	widget_utils.widget_init(
		lbox,
		color_even,
		10,
		10
	)
	return lbox
end

-- ======================
--		load widgets
-- ======================

local taglist_base = require("widgets.taglist").widget
local wifi = require("widgets.wifi").widget
local temperature = require("widgets.temperature").widget
local ram = require("widgets.ram").widget
local cpu = require("widgets.cpu").widget
local volume = require("widgets.volume").widget
local brightness = require("widgets.brightness").widget
local battery = require("widgets.battery").widget

-- ====================================
--	   setup "always visible" widgets
-- ====================================

local taglist = function(screen)
	local tlist = widget_utils.widget_base()
	widget_utils.widget_init(
		tlist,
		color_odd,
		left_margin,
		12.5
	)
	widget_utils.inject_widget_info(tlist, taglist_base(screen))
	return tlist
end

widget_utils.widget_init(
	wifi,
	color_even,
	left_margin,
	right_margin
)

widget_utils.widget_init(
	temperature,
	color_odd,
	left_margin,
	right_margin
)
widget_utils.widget_init(
	ram,
	color_even,
	left_margin,
	right_margin
)
widget_utils.widget_init(
	cpu,
	color_odd,
	left_margin,
	right_margin
)
widget_utils.widget_init(
	volume,
	color_even,
	left_margin,
	right_margin
)
widget_utils.widget_init(
	brightness,
	color_odd,
	left_margin,
	right_margin
)
widget_utils.widget_init(
	battery,
	color_even,
	left_margin,
	right_margin
)
widget_utils.widget_init(
	keyboard_layout,
	color_odd,
	left_margin,
	18
)
widget_utils.widget_init(
	date,
	color_even,
	left_margin,
	18
)
widget_utils.widget_init(
	time,
	color_odd,
	left_margin,
	18
)

-- ==================================
--		configuring the screen
-- ==================================


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
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
	-- s.mypromptbox = awful.widget.prompt()

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
			taglist(s),
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

