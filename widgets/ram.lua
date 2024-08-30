local utils = require("widgets.utils")
local awful = require("awful")
local wibox = require "wibox"
local naughty = require("naughty")

-- =============================
--      defining variables
-- =============================

---@type string
local command = [[bash -c "nice free | awk '{total += $2} {used += $3} END {print used / total * 100}'"]]

---@type number
local timeout = 3

---@type string
local icon = " "

---@type integer
local crit_threshold = 85

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
		function(ram, stdouot, stderr, exitreason, exitcode)
			utils.set_bg(ram, ram.default_bg)
			local percentage = string.format("%.1f", stdouot) ---@type string
			if tonumber(percentage) > crit_threshold then
				utils.set_bg(ram, crit_color)
				if not notified then
					icon = icon
					notified = true
					naughty.notify({
						title = "Ram\n",
						text = "ram is in high usage",
						preset = naughty.config.presets.critical,
					})
				end
			else
				notified = false
			end
			utils.inject_info(ram, wibox.widget.textbox(icon .. ' ' .. percentage .. "% "))
		end,
		utils.widget_base(color, left_margin, right_margin)
	)
end
