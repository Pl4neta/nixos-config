-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local mytasklist = require('mytasklist')
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Naughty
-- Fuck off spotify i hate your shitty enormous notifications. (NOT WORKING!!!!)
--naughty.config.presets.spotify = {callback = function() return false end}
--table.insert(naughty.config.mapping, {{appname = "Spotify"}, naughty.config.presets.spotify})
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

separator = wibox.widget.textbox()
separator.text = '   '
miniSeparator = wibox.widget.textbox()
miniSeparator.text = ' '

beautiful.tasklist_bg_focus = '#fff' .. '00'


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create custom battery widget
local function osExecute(cmd)
	local fileHandle = assert(io.popen(cmd, 'r'))
	local commandOutput = assert(fileHandle:read('*a'))
	fileHandle:close()
	return commandOutput
end

local function batCheck()
	--local perc = osExecute('acpi | awk -F \',\' \'{sub(" ","",$2);sub("%","",$2);print$2}\'')
	--io.input('acpi | awk -F \',\' \'{sub(" ","",$2);sub("%","",$2);print$2}\'')
	--local perc = io.read('*all')
	local fperc = assert(io.popen('acpi | awk -F \',\' \'{sub(" ","",$2);sub("%","",$2);print$2}\''))
	local perc = fperc:read('*number')
	batterywidget.text= perc..'%'

	fstatus = assert(io.popen('acpi | cut -d: -f 2,2 | cut -d, -f 1,1', 'r'))
	local status = fstatus:read('*l')
	if status == ' Discharging' then
		if perc <= 20 then
			batteryicon:set_image(beautiful.widget_bat_very_low)
		elseif perc <= 40 then
			batteryicon:set_image(beautiful.widget_bat_low)
		elseif perc <= 60 then
			batteryicon:set_image(beautiful.widget_bat_med)
		elseif perc <= 80 then
			batteryicon:set_image(beautiful.widget_bat_high)
		else
			batteryicon:set_image(beautiful.widget_bat_full)
		end
	else
		if perc < 100 then
			batteryicon:set_image(beautiful.widget_bat_charging_empty)
		else
			batteryicon:set_image(beautiful.widget_bat_charging_full)
		end
	end
	
	fperc:close()
	fstatus:close()
end

batterywidget = wibox.widget.textbox()
batteryicon = wibox.widget.imagebox()

batterywidgettimer = timer({ timeout = 5 })

batCheck()

batterywidgettimer:connect_signal('timeout', function()	batCheck() end)
batterywidgettimer:start()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

--[[
local wifi_button = widget.button.text.state({
	forced_width = 60,
	forced_height = 60,
	normal_bg = '#fff',
	normal_shape = gears.shape.circle,
	on_normal_bg = '#000',
	text_normal_bg = '#000',
	text_on_normal_bg = '#fff',
	size = 17,
	text = 'WIFI',
})
]]

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    --awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Own tag table config
    local tagNames = { '1', '2', '3', '4' }
    local l = awful.layout.suit
    local layouts = { l.magnifier, l.tile, l.spiral.dwindle, l.max }
    if s.index==1 then
        awful.tag(tagNames, screen[1], layouts)
    else
        awful.tag({'0'}, s, l.magnifier)
    end
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    --[[ Own taglist
    taglist = awful.widget.taglist({
	    screen = s,
	    filter = awful.widget.taglist.filter.all,
	    layout = {
		    ]]

    -- Create a tasklist widget
    s.mytasklist = mytasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused, --awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    s.mytasklist:connect_signal("property::count", function()
	s.mytasklist.visible = s.mytasklist.count > 0 or false
    end)


    --[[ Create the wibox
    if s.index==1 then
    s.mywibox = awful.wibar({
	position = "top",
	screen = screen[1],
	height = 30,
	bg = beautiful.catppuccin_macchiato_crust,--'#fff' .. '00',
	fg = beautiful.catppuccin_macchiato_text
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
	layout = wibox.layout.align.horizontal,
	expand = 'none',
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
	    separator,
	    {
		{
		    {
			layout = wibox.layout.fixed.horizontal,
			--separator,
			--mylauncher,
			separator,
		     	s.mytaglist,
		    	separator,
			s.mypromptbox,
		    },
		    widget = wibox.container.background,
		    shape = gears.shape.rounded_rect,
		    bg = beautiful.catppuccin_macchiato_base
		},
		top = 3,
		right = 3,
		bottom = 3,
		left = 3,
	    	widget = wibox.container.margin
	    },
	    separator,
        },   
	{ -- Middle widget
	    layout = wibox.layout.fixed.horizontal,
	    separator,
	    {
		{
		    {
			s.mytasklist,
			top = 3,
			right = 3,
			bottom = 3,
			left = 3,
			widget = wibox.container.margin
		    },
		    widget = wibox.container.background,
		    shape = gears.shape.rounded_rect,
		    bg = beautiful.catppuccin_macchiato_base
		},
		top = 3,
		right = 3,
		bottom = 3,
		left = 3,
		widget = wibox.container.margin
	    },
	    separator,
	},
	{ -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            separator,
	    {
		layout = wibox.layout.fixed.horizontal,
		{
		    {
			{
			    layout = wibox.layout.fixed.horizontal,
			    separator,
			    --wibox.widget.systray(),
			    {
				{
				    batteryicon,
				    direction = 'west',
				    widget = wibox.container.rotate,
				},
				top = 5,
				right = 5,
				bottom = 5,
				left = 5,
				widget = wibox.container.margin,
			    },
			    miniSeparator,
			    batterywidget,
			    separator,
			},
			widget = wibox.container.background,
			shape = gears.shape.rounded_rect,
			bg = beautiful.catppuccin_macchiato_base
		    },
		    top = 3,
		    right = 3,
		    bottom = 3,
		    left = 3,
		    widget = wibox.container.margin,
		},
		{
		    {
			{
			    layout = wibox.layout.fixed.horizontal,
			    separator,
			    mytextclock,
			    separator
			},
			widget = wibox.container.background,
			shape = gears.shape.rounded_rect,
			bg = beautiful.catppuccin_macchiato_base
		    },
		    top = 3,
		    right = 3,
		    bottom = 3,
		    left = 3,
		    widget = wibox.container.margin
		},
		{
		    {
			{
			    layout = wibox.layout.fixed.horizontal,
			    separator,
			    {
				s.mylayoutbox,
				top = 3,
				right = 3,
				bottom = 3,
				left = 3,
				widget = wibox.container.margin
			    },
			    separator
			},
			widget = wibox.container.background,
			shape = gears.shape.rounded_rect,
			bg = beautiful.catppuccin_macchiato_base
		    },
		    top = 3,
		    right = 3,
		    bottom = 3,
		    left = 3,
		    widget = wibox.container.margin
		},
	    },
	    separator,
        },
    }
end
	local brightnessSlider = require('widgets.brightness_slider')
    local volumeSlider = require('widgets.volume_slider')
	local central_panel = awful.popup({
	    type = 'dock',
	    screen = s,
	    minimum_height = 500,
	    maximum_height = 500,
	    minimum_width = 500,
	    maximum_width = 500,
	    bg = '#fff' .. '00',
	    ontop = true,
	    visible = false,
	    hide_on_right_click = true,
	    --placement = function (w)
	    --	awful.placement.center_horizontal(w)
	    --end,
	    --[[placement = function(w)
		    awful.placement.top(w, {
			    margins = {
				    top = 30 + 5,
				    right = 5,
				    bottom = 5,
				    left = 5
			    },
		    })
	    end,]
	    widget =
	    {
		{
		    {
			layout = wibox.layout.fixed.horizontal,
			{
			    layout = wibox.layout.fixed.vertical,
			    {
				{
				    {
					{
					    layout = wibox.layout.fixed.vertical,
					    {
						layout = wibox.layout.fixed.horizontal,
						{
						    {
							{
							    text = 'WIFI',
							    widget = wibox.widget.textbox
							},
							top = 10,
							right = 10,
						 	bottom = 10,
							left = 10,
							widget = wibox.container.margin
						    },
						    shape = gears.shape.circle,
						    widget = wibox.container.background,
						    bg = '#fff'
						},
						{
						    {
							{
							    text = 'BLUETOOTH',
							    widget = wibox.widget.textbox
							},
							top = 10,
							right = 10,
							bottom = 10,
							left = 10,
							widget = wibox.container.margin
						    },
						    shape = gears.shape.rounded_rect,
						    widget = wibox.container.background,
						    bg = '#fff'
						},
						{
						    {
							{
							    text = 'MICROPHONE',
							    widget = wibox.widget.textbox
							},
							top = 10,
							right = 10,
							bottom = 10,
							left = 10,
							widget = wibox.container.margin
						    },
						    shape = gears.shape.circle,
						    widget = wibox.container.background,
						    bg = '#fff'
					        },
					    },
					    {
						layout = wibox.layout.fixed.horizontal,
						{
						    {
							{
							    text = 'GPS',
							    widget = wibox.widget.textbox
							},
							top = 10,
							right = 10,
							bottom = 10,
							left = 10,
							widget = wibox.container.margin
						    },
						    shape = gears.shape.circle,
						    widget = wibox.container.background,
						    bg = '#fff'
						},
						{
						    {
							{
							    text = 'SCREENSHOT',
							    widget = wibox.widget.textbox
							},
							top = 10,
							right = 10,
							bottom = 10,
							left = 10,
							widget = wibox.container.margin
						    },
						    shape = gears.shape.circle,
						    widget = wibox.container.background,
						    bg = '#fff'
						},
						{
						    {
							{
							    text = 'RECORD',
							    widget = wibox.widget.textbox
							},
							top = 10,
							right = 10,
							bottom = 10,
							left = 10,
							widget = wibox.container.margin
						    },
						    shape = gears.shape.circle,
						    widget = wibox.container.background,
						    bg = '#fff'
						},
					    },
					},
					top = 10,
					right = 10,
					bottom = 10,
					left = 10,
					widget = wibox.container.margin
				    },
				    shape = gears.shape.rounded_rect,
				    widget = wibox.container.background,
				    bg = beautiful.catppuccin_macchiato_base
				},
				top = 5,
				right = 5,
				bottom = 5,
				left = 5,
				widget = wibox.container.margin
			    },
			    {
				{
				    {
						volumeSlider,
						brightnessSlider,
						layout = wibox.layout.fixed.vertical,				
					},
				    shape = gears.shape.rounded_rect,
				    widget = wibox.container.background,
				    bg = beautiful.catppuccin_macchiato_base
				},
				top = 5,
				right = 5,
				bottom = 5,
				left = 5,
				widget = wibox.container.margin
		  	    },
			},
			{
			    {
				{
				    {
					
					layout = wibox.layout.fixed.vertical,
					{
					    widget = wibox.widget.textbox,
					    text = 'To Do',
					},
					{
					    widget = wibox.widget.textbox,
					    text = '_____',
					},
					{
					    layout = wibox.layout.fixed.vertical,
					    {
						widget = wibox.widget.textbox,
						text = 'Lorem',
					    },
					    {
						widget = wibox.widget.textbox,
						text = 'Ipsum',
					    },
					    {
						widget = wibox.widget.textbox,
						text = '...',
					    },
					},
				    },
				    top = 10,
				    right = 10,
				    bottom = 10,
				    left = 10,
				    widget = wibox.container.margin,
				},
				shape = gears.shape.rounded_rect,
				widget = wibox.container.background,
				bg = beautiful.catppuccin_macchiato_base,
			    },
			    top = 5,
			    right = 5,
			    bottom = 5,
			    left = 5,
			    widget = wibox.container.margin,
			},
		    },
		    top = 5,
		    right = 5,
		    bottom = 5,
		    left = 5,
		    widget = wibox.container.margin
		},
		widget = wibox.container.background,
		shape = gears.shape.rounded_rect,
		bg = beautiful.catppuccin_macchiato_crust
	    },
    })
    central_panel:bind_to_widget(batteryicon)
    --central_panel:move_next_to(mouse.current_widget_geometry)
    --awful.placement.center_horizontal(central_panel)
    --]]
end)
--]]
--[[
local left =
{
	{
		layout = wibox.layout.fixed.horizontal,
		mylauncher,
		{
			filter = awful.widget.taglist.filter.all,
			buttons = taglist_buttons,
			widget = awful.widget.taglist
		},
		awful.widget.prompt(),
	},
	bg = '#ccc',
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
}
local middle =
{
	{
		filter = awful.widget.tasklist.filter.focused,
		buttons = tasklist_buttons,
		widget = awful.widget.tasklist
	},
	bg = '#ccc',
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
}
local right =
{
	{
		layout = wibox.layout.fixed.horizontal,
		mykeyboardlayout,
		wibox.widget.systray(),
		mytextclock,
	},
	bg = '#ccc',
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
}
screen.connect_signal('request::desktop_decoration', function(s)
	awful.wibar{
		position = 'top',
		screen = s,
		height = 50,
		bg = '#0000',
		widget = {
			left,
			middle,
			right,
			expand = 'none',
			layout = wibox.layout.align.horizontal,
		}
	}
end)
--]]		
	
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   function()
			for i = 1, screen.count() do
					awful.tag.viewprev(i)
			end
	end,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  function()
			for i = 1, screen.count() do
					awful.tag.viewnext(i)
			end
	end,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Down",  function()
			for i = 1, screen.count() do
					awful.tag.history.restore(i)
			end
	end,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", function () awful.util.spawn_with_shell('~/.config/awesome/reload.sh') end,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.util.spawn('rofi -config ~/.config/rofi/config -show drun -theme ~/.config/rofi/launchers/type-1/style-5.rasi') end,
              {description = "run rofi", group = "launcher"}),
	      --[[combi -combi-modi \"window,run\" -modi combi]]
	awful.key({ modkey },	"Escape",		function() awful.util.spawn_with_shell('~/.config/eww/dashboard/launch_dashboard') end,
		{description = "launch eww dashboard", group = 'launcher'}),
		 
    awful.key({ modkey, "Control" }, "o",     function (c) awful.rules.apply(c) end,
	      {description = "return app to original position", group = 'launcher'}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    --scrot
    awful.key({ modkey, 'Control' }, 's',    function () awful.util.spawn_with_shell('scrot \'screenshots/%d-%m-%Y_%H-%M-%S_$wx$h_scrot.png\' -s -f -i -e \'xclip -selection clipboard -target image/png -i $f\'') end,
	      {description = 'scrot screenshot', group = 'screen'}),
	
    --controls
    awful.key({ modkey }, '#71',	function() awful.util.spawn_with_shell('light -U 5;~/.config/eww/popups/blight/launch_popup_blight') end,
	      {description = 'decrease brightness by 5', group = 'screen'}),
	      
    awful.key({ modkey }, '#72',	function() awful.util.spawn_with_shell('light -A 5;~/.config/eww/popups/blight/launch_popup_blight') end,
	      {description = 'increase brightness by 5', group = 'screen'}),
    
    awful.key({ modkey }, '#68',	function() awful.util.spawn_with_shell('amixer set Master 10%-;~/.config/eww/popups/volume/launch_popup_volume') end,
	      {description = 'decrease volume by 5', group = 'media'}),
	      
    awful.key({ modkey }, '#69',	function() awful.util.spawn_with_shell('amixer set Master 10%+;~/.config/eww/popups/volume/launch_popup_volume') end,
	      {description = 'increase volume by 5', group = 'media'}),

	awful.key({ }, '#172',	function() awful.util.spawn_with_shell('playerctl --player=playerctld play-pause') end,
	      {description = 'playerctl play/pause', group = 'media'}),

	awful.key({ }, '#174',	function() awful.util.spawn_with_shell('playerctl --player=playerctld stop') end,
	      {description = 'playerctl stop', group = 'media'}),
	
	awful.key({ }, '#171',	function() awful.util.spawn_with_shell('playerctl --player=playerctld next') end,
	      {description = 'playerctl next', group = 'media'}),

	awful.key({ }, '#173',	function() awful.util.spawn_with_shell('playerctl --player=playerctld previous') end,
	      {description = 'playerctl previous', group = 'media'}),

	--soundboard
	awful.key({ modkey, 'Shift' }, '#87',
		function() awful.util.spawn_with_shell('play ~/soundboard/.mp3') end,
		{description = 'play 1', group = 'soundboard'})

	--[[ morse code attempt
	awful.key({ modkey, 'Shift' }, '#90',
		function() awful.util.spawn_with_shell('play ~/soundboard/beep.mp3') end,
		function() awful.util.spawn_with_shell('killall play') end,
		{description = 'beep tone', group = 'media'})
		]]
	
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        for s in screen do
                        	local tag = s.tags[i]
                        	if tag then
                           		tag:view_only()
                        	end
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
						for s in screen do
                      		local tag = s.tags[i]
                      		if tag then
                        		awful.tag.viewtoggle(tag)
                      		end
						end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart Applications
awful.spawn.with_shell('~/.config/awesome/autorun.sh')
-- }}}
