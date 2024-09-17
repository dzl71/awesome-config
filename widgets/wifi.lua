local utils = require("widgets.utils")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- ==============================
--		defining variables
-- ==============================

---@type string
local command = [[bash -c "nice nmcli d wifi list | grep '\*' | awk '{print $(NF - 2)}'"]]

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

local widget = utils.widget_base()

local timer = gears.timer({
	timeout = 10,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(out)
				utils.set_bg(widget, widget.default_bg)
				local icon = no_signal_icon ---@type  string
				local signal = tonumber(out) ---@type integer?
				if out:len() > 0 or signal ~= nil then
					icon = signal_icons[math.ceil(signal / 25)]
				else
					signal = 0
					utils.set_bg(widget, crit_color)
				end
				utils.inject_widget_info(widget, wibox.widget.textbox(icon .. signal .. "%"))
			end

		)
	end

})


return {
	widget = widget,
	timer = timer,
}
