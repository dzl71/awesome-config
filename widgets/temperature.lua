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

---@type string
local default_color = "#f8c8dc"

---@type boolean
local notified = false

-- ==================================
--		  creating the widget
-- ==================================

local widget = utils.widget_base(default_color)

local timer = gears.timer({
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(out)
				if tonumber(string.match(out, "[%d.]+")) > crit_threshold then
					utils.set_color(widget, { bg = crit_color, fg = "#ffffff" })
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
				utils.set_color(widget, { fg = default_color })
				utils.inject_widget_info(widget, wibox.widget.textbox(icon .. out))
			end
		)
	end
})

return {
	widget = widget,
	timer = timer,
}
