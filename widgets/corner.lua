local wibox = require "wibox"
local gears = require "gears"
local awful = require "awful"

local main_color = '#f8c8dc'
local transparent = '#00000000'

local base_config = {
	widget = wibox.container.arcchart,
	colors = { main_color },
	min_value = 0,
	max_value = 360,
	value = 180,
	start_angle = math.pi * 0.5,
	forced_width = 40,
	forced_height = 40,
	thickness = 3,
}

local right = wibox.widget({
	widget = wibox.container.margin,
	left = -15,
	base_config
})

local left = wibox.widget({
	widget = wibox.container.margin,
	right = -15,
	{
		widget = wibox.container.mirror,
		reflection = { horizontal = true, vertical = false, },
		base_config
	}
})

return {
	left = left, right = right,
}
