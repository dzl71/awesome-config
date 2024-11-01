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
	rounded_edge = true,
}

---returns a right corner widget, with margins from left and right
---margin.left is optional number
---margin.right is optional number
---@param margin table
---@return any
local right = function(margin)
	return wibox.widget({
	widget = wibox.container.margin,
	left = margin.left,
	right = margin.right,
	base_config
})
end

---returns a left corner widget, with margins from left and right
---margin.left is optional number
---margin.right is optional number
---@param margin table
---@return any
local left = function(margin)
	return wibox.widget({
		widget = wibox.container.margin,
		right = margin.right,
		left = margin.left,
		{
			widget = wibox.container.mirror,
			reflection = { horizontal = true, vertical = false, },
			base_config
		}
	})
end

return {
	left = left, right = right,
}
