local utils = require("widgets.utils")
local awful = require("awful")
local wibox = require "wibox"

-- =================================
--		defining variables
-- =================================

---@type string
local command = [[bash -c "nice pamixer --get-volume --get-mute ; nice pamixer --list-sinks | grep -o bluez"]]

---@type number
local timeout = 2

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
local bluetooth_icon = " "

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
				utils.inject_info(volume_widget, wibox.widget.textbox(' ' .. mute_icon .. " unavailable "))
				utils.set_bg(volume_widget, crit_color)
				return
			end
			local sub_icon = '' ---@type string
			if string.match(stdout, "bluez") then
				sub_icon = bluetooth_icon
			end
			local volume = tonumber(string.match(stdout, "%d+")) ---@type integer?
			local status = string.match(stdout, "%a+") ---@type string
			local icon = sub_icon .. mute_icon ---@type string
			if status == not_mute then
				local icon_idx = math.ceil(volume / 33)
				if icon_idx < 1 then
					icon_idx = 1
				end
				icon = sub_icon .. volume_icons[icon_idx]
			end
			utils.inject_info(volume_widget, wibox.widget.textbox(icon .. " " .. volume .. '% '))
		end,
		utils.widget_base(color, margin_left, margin_right)
	)
	return { widget = widget, updater = updater }
end
