local utils = require("widgets.utils")
local awful = require("awful")
local wibox = require "wibox"

-- ==============================
--		defining variables
-- ==============================

---@type string
local command = [[bash -c "nice nmcli d wifi list | grep '*' | awk '{print $(NF - 2)}'"]]

---@type number
local timeout = 15

---@type string
local crit_color = "#ff0000"

---@type table
local signal_icons = {
	"󰤟 ",
	"󰤢 ",
	"󰤥 ",
	"󰤨 ",
}

---@type string
local no_signal_icon = "󰤮 "


-- ===================================
--       creating the widget
-- ===================================

return function(color, left_margin, right_margin)
	return awful.widget.watch(
		command,
		timeout,
		function(wifi, stdout, stderr, exitreason, exitcode)
			utils.set_bg(wifi, wifi.default_bg)
			local icon = no_signal_icon ---@type  string
			local signal = tonumber(stdout) ---@type integer?
			if stdout:len() > 0 then
				icon = signal_icons[math.ceil(signal / 25)]
			else
				signal = 0
				utils.set_bg(wifi, crit_color)
			end
			utils.set_widget(wifi, wibox.widget.textbox(icon .. signal .. "% "))
		end,
		utils.widget_base(color, left_margin, right_margin)
	)
end
