local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

-- ======================
--   defining variables
-- ======================

---@type string
local keyboard_layouts = { "us", "il", "ru" }

---@type integer
local default_master_count = 1

---@type integer
local keyboard_layout_current = 1

---@type integer
local max_clients = 4

---@type string
local modkey = "Mod1"

---@type table
local keys = {}

-- =======================
--	  defining utility
-- =======================

local hold_timeout = gears.timer({
	timeout = 0.075,
	autostart = false,
	call_now = false,
	single_shot = true,
	callback = function()
	end,
})

-- change volume

---@param command string
local function volume_change(command)
	local volume = require("widgets.volume")
	if not hold_timeout.started then
		hold_timeout:start()
		awful.spawn(command)
		volume.timer:emit_signal("timeout")
		volume.popup.visible = true
		volume.timer:again()
	end
end

-- change brightness

---@param percentage string
local function brightness_change(percentage)
	local brightness = require("widgets.brightness")
	if not hold_timeout.started then
		hold_timeout:start()
		awful.spawn("brightnessctl set " .. percentage)
		brightness.timer:emit_signal("timeout")
		brightness.popup.visible = true
		brightness.timer:again()
	end
end

-- raise client focus
local function raise_client()
	if client.focus then
		client.focus:raise()
	end
end

---@param client_name string
local function spawn_client(client_name)
	local selected_tag = awful.screen.focused().selected_tag
	local tag_clients_num = #selected_tag:clients() ---@type integer
	if (tag_clients_num < max_clients) or (max_clients <= 0) then
		awful.spawn(client_name)
	end
end

-- ====================================
--     defining global keybindings
-- ====================================

keys.global = gears.table.join(
-- =====================
--   awaesome reload
-- =====================

-- restart awesome
	awful.key(
		{ modkey, "Control" },
		'r',
		awesome.restart,
		{ description = "restart awesome", group = "awesome" }
	),

	-- quit awesome
	awful.key(
		{ modkey, "Control" },
		'q',
		awesome.quit,
		{ description = "quit awesome", group = "awesome" }
	),

	-- ====================
	--   client spawning
	-- ====================

	-- spawn terminal
	awful.key(
		{ modkey },
		"Return",
		function()
			spawn_client(Terminal)
		end,
		{ description = "spawn terminal", group = 'launcher' }
	),

	-- spawn browser
	awful.key(
		{ modkey },
		"o",
		function()
			spawn_client("zen-browser")
		end,
		{ description = 'spawn firefox (web browser)', group = "launcher" }
	),

	-- spawn rofi
	awful.key(
		{ modkey },
		"d",
		function()
			spawn_client("rofi -show run")
		end,
		{ description = 'spawn rofi (app browser)', group = "launcher" }
	),

	-- show all open clients
	awful.key(
		{ modkey },
		"Tab",
		function()
			spawn_client("rofi -show window")
			-- awful.spawn.with_shell
		end,
		{ description = 'spawn rofi (clients browser)', group = "launcher" }
	),

	-- ========================
	--    util keybindings
	-- ========================

	-- change keyboard layout
	awful.key(
		{ "Control", "Shift" },
		"BackSpace",
		function()
			keyboard_layout_current = keyboard_layout_current + 1
			if keyboard_layout_current > #keyboard_layouts then
				keyboard_layout_current = 1
			end
			awful.spawn("setxkbmap " .. keyboard_layouts[keyboard_layout_current])
		end,
		{ description = "go to the next keyboard layout", group = "keyboard layout" }
	),

	-- brightness increase

	awful.key(
		{},
		"XF86MonBrightnessUp",
		function()
			brightness_change("1%+")
		end
	),

	-- brightness decrease

	awful.key(
		{},
		"XF86MonBrightnessDown",
		function()
			brightness_change("1%-")
		end
	),

	-- volume increase

	awful.key(
		{},
		"XF86AudioRaiseVolume",
		function()
			volume_change("pamixer -i 1")
		end
	),

	-- volume decrease

	awful.key(
		{},
		"XF86AudioLowerVolume",
		function()
			volume_change("pamixer -d 1")
		end
	),

	-- mute
	awful.key(
		{},
		"XF86AudioMute",
		function()
			volume_change("pamixer --toggle-mute")
		end
	)

)

for i = 1, 10 do
	keys.global = gears.table.join(keys.global,

		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{ description = "view tag #" .. i, group = "tag" }
		),

		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{ description = "toggle tag #" .. i, group = "tag" }
		),

		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{ description = "move focused client to tag #" .. i, group = "tag" }
		)
	)
end

-- ====================================
--     defining client keybindings
-- ====================================

keys.client = gears.table.join(

-- =======================
--    client focusing
-- ======================

	awful.key(
		{ modkey }, -- modification keys
		"h",  -- key
		function() -- on press function
			awful.client.focus.bydirection('left')
			raise_client()
		end,
		{ description = "focus to left client", group = "client" } -- data
	),
	awful.key(
		{ modkey }, -- modification keys
		"j",  -- key
		function() -- on press function
			awful.client.focus.bydirection('down')
			raise_client()
		end,
		{ description = "focus to downward client", group = "client" } -- data
	),
	awful.key(
		{ modkey }, -- modification keys
		"k",  -- key
		function() -- on press function
			awful.client.focus.bydirection('up')
			raise_client()
		end,
		{ description = "focus to upward client", group = "client" } -- data
	),
	awful.key(
		{ modkey }, -- modification keys
		"l",  -- key
		function() -- on press function
			awful.client.focus.bydirection('right')
			raise_client()
		end,
		{ description = "focus to right client", group = "client" } -- data
	),

	-- =======================
	--     client swaps
	-- =======================

	awful.key(
		{ modkey, 'Shift' },
		'h',
		function()
			awful.client.swap.bydirection('left')
		end,
		{ description = "swap with the left client", group = "client" } -- data
	),
	awful.key(
		{ modkey, 'Shift' },
		'j',
		function()
			awful.client.swap.bydirection('down')
		end,
		{ description = "swap with the downer client", group = "client" } -- data
	),
	awful.key(
		{ modkey, 'Shift' },
		'k',
		function()
			awful.client.swap.bydirection('up')
		end,
		{ description = "swap with the upper client", group = "client" } -- data
	),
	awful.key(
		{ modkey, 'Shift' },
		'l',
		function()
			awful.client.swap.bydirection('right')
		end,
		{ description = "swap with the right client", group = "client" } -- data
	),

	-- ==========================
	--		client utils
	-- ==========================

	awful.key(
		{ modkey },
		'q',
		function(client)
			local pkilled_clients = { "Discord" } ---@type table
			-- because the list is small enough, we dont have to use binary search
			for _, pkilled_client in ipairs(pkilled_clients) do
				if string.find(client.name, pkilled_client) then
					awful.spawn("pkill " .. pkilled_client)
					break
				end
			end
			client:kill()
		end,
		{ description = "kill client", group = "client" }
	)
)

-- ====================================
--     defining client keygrabbers
-- ====================================

-- client resizing
awful.keygrabber({
	timeout = 2,
	-- keybindings to start the keygrabber
	root_keybindings = {
		{ { modkey }, 'r', function() end },
	},
	-- keygrabber keybindings
	keybindings = {
		{ {}, 'h', function() awful.tag.incmwfact(-0.00625) end }, -- resize left
		{ {}, 'j', function() awful.client.incwfact(-0.025) end }, -- decrease height
		{ {}, 'k', function() awful.client.incwfact(0.025) end }, -- increase height
		{ {}, 'l', function() awful.tag.incmwfact(0.00625) end }, -- resize right
	},
	-- had to do this because allowed_keys terminated the keygrabber instantly
	_allowed_keys = {},
	keypressed_callback = function(self, _, key, _)
		if not gears.table.hasitem(self._allowed_keys, key) then
			self:stop()
		end
	end,
})

return keys
