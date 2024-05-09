local utils = require("widgets.utils")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")

-- =============================
--      defining variables
-- =============================

---@type string
local command = [[bash -c "nice sensors | grep Tctl | awk '{print $2}'"]]

---@type integer
local timeout = 1

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

return function(color, left_margin, right_margin)
	return awful.widget.watch(
		command,
		timeout,
		function(temp, stdouot, stderr, exitreason, exitcode)
			utils.set_bg(temp, temp.default_bg)
			if tonumber(string.match(stdouot, "[%d.]+")) > crit_threshold then
				utils.set_bg(temp, crit_color)
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
			utils.set_widget(temp, wibox.widget({
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.textbox(icon .. ' ' .. stdouot),
				wibox.widget.textbox(" "),
			}))
		end,
		utils.widget_base(color, left_margin, right_margin, 130)
	)
end
