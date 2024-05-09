local utils = require("widgets.utils")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")

-- =============================
--      defining variables
-- =============================

---@type string
local command = [[bash -c "nice top -bn1 | grep -oP '[\d.]+(?= id,)'"]]

---@type number
local timeout = 1

---@type string
local icon = ""

---@type string
local crit_color = "#ff0000"

---@type integer
local crit_threshold = 85

---@type boolean
local notified = false

-- ===========================================
--		  creating the widget updater
-- ===========================================

return function(color, left_margin, right_margin)
	return awful.widget.watch(
		command,
		timeout,
		function(cpu, stdouot, stderr, exitreason, exitcode)
			utils.set_bg(cpu, cpu.default_bg)
			local percentage = string.format("%.1f", 100 - stdouot) ---@type string
			if tonumber(percentage) > crit_threshold then
				utils.set_bg(cpu, crit_color)
				if not notified then
					icon = icon
					notified = true
					naughty.notify({
						title = "Cpu\n",
						text = "cpu is in high usage",
						preset = naughty.config.presets.critical,
					})
				end
			else
				notified = false
			end
			utils.set_widget(cpu, wibox.widget.textbox(icon .. ' ' .. percentage .. "% "))
		end,
		utils.widget_base(color, left_margin, right_margin)
	)
end
