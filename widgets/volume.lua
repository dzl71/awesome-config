local utils = require("widgets.utils")
local awful = require("awful")
local wibox = require "wibox"

-- =================================
--		defining variables
-- =================================

---@type string
local command = [[bash -c "nice pamixer --get-volume --get-mute"]]

---@type number
local timeout = 3600

---@type table
local volume_icons = {

	'󰕿',
	'󰖀',
	'󰕾',
	'󰕾',
}

---@type string
local mute_icon = "󰸈"

---@type string
local not_mute = "false"

---@type string
local crit_color = "#ff0000"

-- ==============================
--		creating the widget
-- ==============================

return function(color, margin_left, margin_right)
	local widget, updater = awful.widget.watch(
		command,
		timeout,
		function(volume_widget, stdout, stderr, exitreason, exitcode)
			utils.set_bg(volume_widget, volume_widget.default_bg)
			if stderr:len() > 0 then
				utils.set_text(volume_widget, wibox.widget.textbox(' ' .. mute_icon .. " unavailable "))
				utils.set_bg(volume_widget, crit_color)
				return
			end
			local volume = tonumber(string.match(stdout, "%d+")) ---@type integer?
			local status = string.match(stdout, "%a+") ---@type string
			local icon = mute_icon ---@type string
			if status == not_mute then
				icon = volume_icons[math.ceil(volume / 33)]
			end
			utils.set_text(volume_widget, wibox.widget.textbox(icon .. " " .. volume .. '% '))
		end,
		utils.widget_base(color, margin_left, margin_right)
	)
	return { widget = widget, updater = updater }
end
