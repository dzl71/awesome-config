local awful = require("awful")
local utils = require("widgets.utils")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

-- ==============================
--       defining variables
-- ==============================

---@type string
local command = [[bash -c "nice cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT0/status"]]

---@type table
local percentage_icons = {
	'󱉞',
	'󰁺',
	'󰁻',
	'󰁼',
	'󰁽',
	'󰁾',
	'󰁿',
	'󰂀',
	'󰂁',
	'󰂂',
	'󰁹',
}

---@type string
local charging_status = "Charging"

---@type string
local charging_icon = '󱐋'

---@type string
local crit_color = "#ff0000"

---@type string
local default_color = "#c1e1c1"

---@type integer
local crit_threshold = 30

---@type boolean
local notified = false

-- =================================
--     defining util functions
-- =================================

---@param text string
local function notify(text)
	if not notified then
		notified = true
		naughty.notify({
			title = "Battery\n",
			text = text,
			preset = naughty.config.presets.critical,
		})
	end
end

-- =====================================
--     creating the widget updater
-- =====================================

local widget = utils.widget_base(default_color)

local timer = gears.timer({
	timeout = 3,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(stdout, stderr)
				local icon = "" ---@type string
				if stderr:len() > 0 then
					icon = percentage_icons[1]
					utils.inject_widget_info(widget, wibox.widget.textbox(icon .. 'unavailable '))
					utils.set_color(widget, { bg = crit_color, fg = "#ffffff" })
					notify("unable to connect to battery")
					return
				end
				local charge = tonumber(string.match(stdout, "%d+")) ---@type integer?
				icon = percentage_icons[math.ceil(charge / 10) + 1]
				local status = string.match(stdout, "%a+") ---@type string
				if status == charging_status then
					icon = charging_icon .. icon
				end
				if charge <= crit_threshold then
					icon = icon
					utils.set_color(widget, { bg = crit_color, fg = "#ffffff" })
					notify("low battery percentage (" .. charge .. "%)")
				else
					notified = false
				end
				utils.set_color(widget, { fg = default_color })
				utils.inject_widget_info(widget, wibox.widget.textbox(icon .. charge .. '%'))
			end
		)
	end
})

return {
	widget = widget,
	timer = timer,
}
