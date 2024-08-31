local utils = require("widgets.utils")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")

-- =============================
--      defining variables
-- =============================

---@type string
local command = [[bash -c "nice sensors | grep Tctl | awk '{print $2}'"]]

---@type string
local icon = "󰔏"

---@type integer
local crit_threshold = 80

---@type string
local crit_color = "#ff0000"

---@type boolean
local notified = false

-- ==================================
--		  creating the widget
-- ==================================

local widget = utils.widget_base()

local timer = gears.timer({
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(out)
				utils.set_bg(widget, widget.default_bg)
				if tonumber(string.match(out, "[%d.]+")) > crit_threshold then
					utils.set_bg(widget, crit_color)
					if not notified then
						icon = icon
						notified = true
						naughty.notify({
							title = "Temperature\n",
							text = "this laptop is overheating",
							preset = naughty.config.presets.critical,
						})
					end
				else
					notified = false
				end
				utils.inject_info(widget, wibox.widget.textbox(icon .. ' ' .. out))
			end
		)
	end
})

return {
	widget = widget,
	timer = timer,
}
