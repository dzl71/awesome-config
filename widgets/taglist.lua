local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local main_color = '#f8c8dc'
local empty_color = "#3a425f"

local forced_size = 25

local hover_style = {
	shape_border_color = main_color,
	bg = '#000000',
	fg = main_color,
}

local tagged_style = {
	shape_border_color = empty_color,
	bg = empty_color,
	fg = main_color,
}

local empty_style = {
	shape_border_color = empty_color,
	bg = empty_color,
	fg = empty_color,
}

local selected_style = {
	shape_border_color = main_color,
	bg = main_color,
	fg = empty_color,
}

--------------------
-- util functions --
--------------------

local function impl_style(self, style)
	for field, value in pairs(style) do
		self[field] = value
	end
	self.current_style = style
end

local function color(self)
	if self.tag.selected then
		self.backup_style = self.current_style
		impl_style(self, selected_style)
	elseif #self.tag:clients() > 0 then
		impl_style(self, tagged_style)
	else
		impl_style(self, empty_style)
	end
end

-------------------
-- widget config --
-------------------

local widget_template = {
	id = 'background',
	widget = wibox.container.background,
	shape = gears.shape.circle,
	bg = empty_color,
	fg = empty_color,
	shape_border_color = empty_color,
	shape_border_width = 2,
	forced_height = forced_size,
	forced_width = forced_size,
	{
		id = "placement",
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
		{
			id = 'index',
			widget = wibox.widget.textbox,
		},
	},
	-- callbaks --
	create_callback = function(self, c3, index, objects)
		self:get_children_by_id('index')[1].text = index
		self.tag = awful.tag.find_by_name(awful.screen.focused(), tostring(index))
		color(self)

		-- change style when mouse enters
		self:connect_signal('mouse::enter', function()
			self.backup_style = self.current_style
			impl_style(self, hover_style)
		end)

		-- change style to previous when mouse leaves
		self:connect_signal('mouse::leave', function()
			color(self)
		end)
	end,

	-- whenever a tag gets updated, it gets colored
	update_callback = function(self, c3, index, objects)
		self:get_children_by_id('index')[1].text = index
		self.tag = awful.tag.find_by_name(awful.screen.focused(), tostring(index))
		color(self)
	end
}

local widget = function(screen)
	return awful.widget.taglist({
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		widget_template = widget_template,
		style = {
			spacing = 3,
		},
	})
end


return {
	widget = widget,
}
