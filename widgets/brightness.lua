local utils = require("widgets.utils")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- ==========================
--	  defining variables
-- ==========================

---@type string
local command = [[bash -c "nice brightnessctl | grep -oP '(?<=\()[0-9%]*(?=%\))'"]]

---@type string
local icon = ' '

---@type string
local crit_color = "#ff0000"

---@type string
local default_color = "#fffaa0"

-- ===========================
--    creating the widget
-- ===========================

local widget = utils.widget_base(default_color)

local popup = utils.popup_base()

local timer = gears.timer({
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(out, stderr)
				if stderr:len() > 0 then
					utils.inject_widget_info(widget, wibox.widget.textbox(icon .. " N/A "))
					utils.set_color(widget, {bg = crit_color, fg = "#ffffff"})
					return
				end
				local brightness = tonumber(out)
				local text = icon .. brightness .. '%'
				utils.set_color(widget, {fg = default_color })
				utils.inject_widget_info(widget, wibox.widget.textbox(text))
				utils.inject_popup_info(popup, brightness, text)
			end
		)
		popup.visible = false
	end
})

-- stop the timer if it works
timer:connect_signal(
	"timeout",
	function()
		timer:stop()
	end
)

return {
	widget = widget,
	timer = timer,
	popup = popup,
}
