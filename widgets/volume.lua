local utils = require("widgets.utils")
local awful = require("awful")
local beautiful = require("beautiful").get()
local gears = require("gears")
local wibox = require "wibox"

-- =================================
--		defining variables
-- =================================

---@type string
local command = [[bash -c "nice pamixer --get-volume --get-mute ; nice pamixer --list-sinks | grep -o bluez"]]

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

local widget = utils.widget_base()

local popup = utils.popup_base()

local timer = gears.timer({
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(out, stderr)
				utils.set_bg(widget, widget.default_bg)
				if stderr:len() > 0 then
					utils.inject_widget_info(widget, wibox.widget.textbox(' ' .. mute_icon .. " unavailable "))
					utils.set_bg(widget, crit_color)
					return
				end
				local sub_icon = '' ---@type string
				if string.match(out, "bluez") then
					sub_icon = bluetooth_icon
				end
				local volume = tonumber(string.match(out, "%d+")) ---@type integer?
				local status = string.match(out, "%a+") ---@type string
				local icon = sub_icon .. mute_icon ---@type string
				if status == not_mute then
					local icon_idx = math.ceil(volume / 33)
					if icon_idx < 1 then
						icon_idx = 1
					end
					icon = sub_icon .. volume_icons[icon_idx]
				end
				local text = icon .. " " .. volume .. '%'
				utils.inject_widget_info(widget, wibox.widget.textbox(text))
				utils.inject_popup_info(popup, volume, text)
			end
		)
		popup.visible = false
	end
})

return {
	widget = widget,
	timer = timer,
	popup = popup,
}
