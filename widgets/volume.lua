local utils = require("widgets.utils")
local awful = require("awful")
local gears = require("gears")
local wibox = require "wibox"

-- =================================
--		defining variables
-- =================================

---@type string
local command = [[bash -c "nice pamixer --get-volume --get-mute ; nice pamixer --list-sinks | grep -o bluez"]]

---@type table
local volume_icons = {
	'󰕿 ',
	'󰖀 ',
	'󰕾 ',
	'󰕾 ',
}

---@type string
local mute_icon = "󰸈"

---@type string
local bluetooth_icon = " "

---@type string
local not_mute = "false"

---@type string
local crit_color = "#ff0000"

---@type string
local default_color = "#fac898"

-- ==============================
--		creating the widget
-- ==============================

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
					widget:inject_info(wibox.widget.textbox(mute_icon .. " N/A "))
					widget:set_color({ bg = crit_color, fg = "#ffffff" })
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
				local text = icon .. volume .. '%'
				widget:set_color({ fg = default_color })
				widget:inject_info(wibox.widget.textbox(text))
				popup:inject_info(volume, text)
			end
		)
		popup:set_invisible()
	end
})

return {
	widget = widget(),
	timer = timer,
	popup = popup,
}
