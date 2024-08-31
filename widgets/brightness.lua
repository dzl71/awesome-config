local utils = require("widgets.utils")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- ==========================
--	  defining variables
-- ==========================

---@type string
local command = [[bash -c "nice brightnessctl | grep -oP '(?<=\()[0-9%]*(?=\))'"]]

---@type string
local icon = ' '

---@type string
local crit_color = "#ff0000"

-- ===========================
--    creating the widget
-- ===========================

local widget = utils.widget_base()

local timer = gears.timer({
	timeout = 3600,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(out, stderr)
				utils.set_bg(widget, widget.default_bg)
				if stderr:len() > 0 then
					utils.inject_info(widget, wibox.widget.textbox(' ' .. icon .. "unavailable "))
					utils.set_bg(widget, crit_color)
					return
				end
				utils.inject_info(widget, wibox.widget.textbox(icon .. out))
			end
		)
	end
})

return {
	widget = widget,
	timer = timer,
}
