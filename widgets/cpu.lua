local utils = require("widgets.utils")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")

-- =============================
--      defining variables
-- =============================

---@type string
local command = [[bash -c "nice top -bn1 | grep -oP '[\d.]+(?= id,)'"]]

---@type string
local icon = " "

---@type string
local crit_color = "#ff0000"

---@type string
local default_color = "#f8c8dc"

---@type integer
local crit_threshold = 85

---@type boolean
local notified = false

-- ===========================================
--		  creating the widget updater
-- ===========================================

local widget = utils.widget_base(default_color)

local timer = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(
			command,
			function(out)
				local percentage = string.format("%.1f", 100 - out) ---@type string
				if tonumber(percentage) > crit_threshold then
					utils.set_color(widget, { bg = crit_color, fg = "#ffffff" })
					if not notified then
						icon = icon
						notified = true
						naughty.notify({
							title = "Cpu\n",
							text = "widget is in high usage",
							preset = naughty.config.presets.critical,
						})
					end
				else
					notified = false
				end
				utils.set_color(widget, { fg = default_color })
				utils.inject_widget_info(widget, wibox.widget.textbox(icon .. percentage .. "%"))
			end
		)
	end
})
return {
	widget = widget,
	timer = timer,
}
