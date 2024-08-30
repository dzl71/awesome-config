local awful = require("awful")
local utils = require("widgets.utils")
local naughty = require("naughty")
local wibox = require("wibox")

-- ==============================
--       defining variables
-- ==============================

---@type string
local command = [[bash -c "nice cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT0/status"]]

---@type integer
local timeout = 3

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

return function(color, left_margin, right_margin)
	return awful.widget.watch(
		command,
		timeout,
		function(battery, stdout, stderr, exit_reason, exit_code)
			utils.set_bg(battery, battery.default_bg)
			local icon = "" ---@type string
			if stderr:len() > 0 then
				icon = percentage_icons[1]
				utils.inject_info(battery, wibox.widget.textbox(' ' .. icon .. ' unavailable '))
				utils.set_bg(battery, crit_color)
				notify("unable to connect to battery")
				return
			end
			local charge = tonumber(string.match(stdout, "%d+")) ---@type integer?
			icon = percentage_icons[math.ceil(charge / 10) + 1]
			local status = string.match(stdout, "%a+") ---@type string
			if status == charging_status then
				icon = icon .. charging_icon
			end
			if charge <= crit_threshold then
				icon = icon
				utils.set_bg(battery, crit_color)
				notify("low battery percentage (" .. charge .. "%)")
			else
				notified = false
			end
			utils.inject_info(battery, wibox.widget.textbox(icon .. ' ' .. charge .. '%'))
		end,
		utils.widget_base(color, left_margin, right_margin, 200)
	)
end
