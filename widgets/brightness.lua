local utils = require("widgets.utils")
local awful = require("awful")
local wibox = require("wibox")

-- ==========================
--	  defining variables
-- ==========================

---@type string
local command = [[bash -c "nice brightnessctl | grep -oP '[0-9.]{1,3}(?=%)'"]]

---@type number
local timeout = 3600

---@type string
local icon = ' '

---@type string
local crit_color = "#ff0000"

-- ===========================
--    creating the widget
-- ===========================

return function(color, left_margin, right_margin)
	local widget, updater = awful.widget.watch(
		command,
		timeout,
		function(brightness, stdout, stderr, exitreason, exitcode)
			utils.set_bg(brightness, brightness.default_bg)
			if stderr:len() > 0 then
				utils.set_text(brightness, wibox.widget.textbox(' ' .. icon .. "unavailable "))
				utils.set_bg(brightness, crit_color)
				return
			end
			local output = string.format("%.0f", stdout) ---@type string
			utils.set_text(brightness, wibox.widget.textbox(icon .. output .. '% '))
		end,
		utils.widget_base(color, left_margin, right_margin)
	)
	return { widget = widget, updater = updater }
end
