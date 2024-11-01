local wibox = require "wibox"
local gears = require "gears"
local awful = require "awful"

local utils = {}

------------------
-- widget utils --
------------------

function utils.widget_base(default_color)
	return wibox.widget({
		widget = wibox.container.background,
		forced_height = 25,
		fg = default_color
	})
end

---sets the color of the widget
---color is a table with the followin fields
---optional bg: background of type sring?
---optional fg: foreground of type sring?
---setting one of the fields to nil is same as not defining it
---@param widget any
---@param color table
function utils.set_color(widget, color)
	widget.bg = color.bg
	widget.fg = color.fg
end

function utils.inject_widget_info(widget, info)
	widget.widget = info
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
