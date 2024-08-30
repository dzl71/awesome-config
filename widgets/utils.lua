local wibox = require "wibox"
local gears = require "gears"

local utils = {}

function utils.widget_base(color, left_margin, right_margin, max_width)
	return wibox.widget {
		{
			{
				id = 'margin',
				widget = wibox.container.margin,
				left = left_margin,
				right = right_margin
			},
			id = 'background',
			widget = wibox.container.background,
			bg = color,
			shape = gears.shape.rounded_bar,
		},
		default_bg = color,
		widget = wibox.container.constraint,
		strategy = "max",
		width = max_width
	}
end

function utils.set_bg(widget, color)
	widget:get_children_by_id("background")[1].bg = color
end

function utils.inject_info(parent_widget, child_widget)
	parent_widget:get_children_by_id("margin")[1].widget = child_widget
end

return utils
