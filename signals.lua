local awful = require("awful")
local beautiful = require("beautiful")

-- ============================
--    deifining variables
-- ============================

---@type string
local config_dir = require "gears.filesystem".get_dir("config")

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end

	c.maximized = false
	c.fullscreen = false
end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- ==============================================
--     change tag name (dependts on if tagged)
-- ==============================================

-- ---@type string
-- local inactive_tag_name = ''

-- ---@type string
-- local active_tag_name = ''

tag.connect_signal("tagged", function(tag)
	tag.icon = string.format("%s/icons/numeric-%d-circle.svg", config_dir, tag.index)
end)

tag.connect_signal("untagged", function(tag)
	if #tag:clients() < 1 then
		tag.icon = string.format("%s/icons/numeric-%d-circle-outline.svg", config_dir, tag.index)
	end
end)
