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
	widget.widget.bg = color
end

function utils.set_widget(parent_widget, child_widget)
	parent_widget.widget.widget.widget = child_widget
end

return utils
