local wibox = require "wibox"
local gears = require "gears"
local awful = require "awful"

local utils = {}

------------------
-- widget utils --
------------------

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

function utils.inject_widget_info(widget, info)
	widget:get_children_by_id("margin")[1].widget = info
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
end

-----------------
-- popup utils --
-----------------

function utils.popup_base()
	return awful.popup({
		ontop = true,
		visible = false,
		shape = gears.shape.circle,
		x = 1810,
		y = 50,
		widget = wibox.widget({
			widget = wibox.container.constraint,
			id = "constraint",
			height = 100,
			width = 100,
			forced_height = 100,
			forced_width = 100,
			{
				widget       = wibox.container.radialprogressbar,
				id           = "bar",
				color        = "#7b68ee",
				border_color = "#00000000",
				visible      = true,
				border_width = 8,
				max_value    = 100,
				value        = 0,
				min_value    = 0,
				{
					widget = wibox.widget.textbox,
					id = "text",
					valign = "center",
					align = "center",
					forced_height = 50,
					forced_width = 40,
				},

			},
		})
	})
end

function utils.inject_popup_info(popup, value_info, text_info)
	popup.widget:get_children_by_id("bar")[1].value = value_info
	popup.widget:get_children_by_id("text")[1].text = text_info
end

return utils
