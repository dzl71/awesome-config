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
		strategy = "exact",
		-- default_bg = color,
		{
			id = 'background',
			widget = wibox.container.background,
			shape = gears.shape.rounded_rect,
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
		shape = gears.shape.rounded_rect,
		x = 1810 - 150,
		y = 50,
		widget = wibox.widget({
			layout = wibox.layout.fixed.horizontal,
			{
				widget = wibox.widget.textbox,
				id = "text",
				valign = "center",
				align = "center",
				forced_height = 50,
				forced_width = 49,
				wrap = "word_char"
			},
			{
				widget           = wibox.widget.progressbar,
				id               = "bar",
				-- shapes
				shape            = gears.shape.rounded_rect,
				bar_shape        = gears.shape.rounded_rect,
				-- colors
				color            = "#7b68ee",
				background_color = "#000000",
				border_color     = "#000000",
				-- bar values
				min_value        = 0,
				value            = 0,
				max_value        = 100,
				-- dimentions
				forced_width     = 200,
				forced_height    = 30,
				paddings         = 6,
				margins          = {
					top = 5,
					bottom = 5,
					right = 5,
					left = 5,
				}
			}

		})
	})
end

function utils.inject_popup_info(popup, value_info, text_info)
	popup.widget:get_children_by_id("bar")[1].value = value_info
	popup.widget:get_children_by_id("text")[1].text = text_info
end

return utils
