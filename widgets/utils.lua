local wibox = require "wibox"
local gears = require "gears"

local utils = {}

function utils.widget_base()
	return wibox.widget {
		id = "constraint",
		widget = wibox.container.constraint,
		strategy = "max",
		-- default_bg = color,
		{
			id = 'background',
			widget = wibox.container.background,
			shape = gears.shape.rounded_bar,
			-- bg = color,
			{
				id = 'margin',
				widget = wibox.container.margin,
				-- left = left_margin,
				-- right = right_margin,
			},
		},
	}
end

function utils.set_bg(widget, color)
	widget:get_children_by_id("background")[1].bg = color
end

function utils.inject_info(parent_widget, child_widget)
	parent_widget:get_children_by_id("margin")[1].widget = child_widget
end

---initialize the widget base
---@param color string
---@param left_margin number?
---@param right_margin number?
function utils.widget_init(widget, color, left_margin, right_margin)
	widget:get_children_by_id("margin")[1].left = left_margin
	widget:get_children_by_id("margin")[1].right = right_margin
	widget:get_children_by_id("background")[1].bg = color
	widget:get_children_by_id("constraint")[1].default_bg = color
	-- widget:get_children_by_id("constraint")[1].max_width = max_width
end

return utils
