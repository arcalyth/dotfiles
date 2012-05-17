--  vim: filetype=lua		
------------------------------------------
-- awesome window manager configuration --
-- modified: April 2012			--
-- theme: arcane			--
-- colorscheme: solarize		--
------------------------------------------

-- includes
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("vicious")
---

-- initialize theeme
beautiful.init(awful.util.getdir("config") .."/themes/arcane/theme.lua")
awesome.font = "proggycleantt 10"
--

-- environment
modkey = "Mod4"
terminal = "urxvt"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor
---

-- layouts
layouts =
{
    awful.layout.suit.tile,		-- 1, vertical
    awful.layout.suit.tile.bottom,	-- 2, horizontal
}
---

-- tags
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "δ", "Δ", "μ", "Ω"}, s, layouts[1])
end

-- widget definitions
-- tag list
tagList = {}
tgButtons = awful.util.table.join(awful.button({ }, 1, awful.tag.viewonly))
-- prompt
cmdPrompt = {}
-- task list
taskList = {}

topWibox = {}
bottomWibox = {}
tbLeft = {}
tbRight = {}
-- top statusbar
for s = 1, screen.count() do
topWibox[s] = awful.wibox({ position = "top", screen = s, height = 13 })
tagList[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, tgButtons)
cmdPrompt[s] = awful.widget.prompt({ prompt = '|$ ',layout = awful.widget.layout.horizontal.leftright })
taskList[s] = awful.widget.tasklist(
	function(c) 
	    return awful.widget.tasklist.label.focused(c, s, {})
	end,nil)

    -- systray
    sysTray = widget({ type = "systray" })

    tbLeft[s] = { tagList[s], cmdPrompt[s],
		taskList[s], layout = awful.widget.layout.horizontal.leftright }
    tbRight[s] = { sysTray, layout = awful.widget.layout.horizontal.rightleft }

topWibox[s].widgets = { tbLeft[s], tbRight[s], layout=awful.widget.layout.horizontal.rightleft }
-- end top status bar

-- bottom statusbar
bottomWibox[s] = awful.wibox({ position = "bottom", screen = s, height = 13 })
    -- separator
    separator = widget({ type = "textbox" })
    separator.text = " / "
    -- spacer
    spacer = widget({ type = "textbox" })
    spacer.text = "  "
    -- mpd status
    mpdStatus = widget({type = "textbox"})
    vicious.register(mpdStatus, vicious.widgets.mpd,
	function (widget, args)
	    if (args["{state}"] == "Stop") then
		return "d(-_-)b"
	    else
		return "d(^_^)b [" .. args["{Artist}"] .. " - " .. args["{Title}"] .. "]"
	    end
	end, 10)
    -- weather
--    miniWeather = widget({ type = "textbox" })
--    vicious.register("miniWeather", vicious.widgets.weather,
--	function (widget, args)
--	    return "weather " .. args["{tempc}"] .. "°C " .. args["{sky}"] 
--	end, 1800, "KGRR")
    -- clock
    clock = awful.widget.textclock({}, "%H:%M [%a %y.%m.%d]")
    -- cpu usage
    cpuMeter = widget({type = "textbox" })
    vicious.register(cpuMeter, vicious.widgets.cpu, "cpu0 $2% cpu1 $3% cpu2 $4% cpu3 $5%")
    -- mem usage
    memMeter = widget({ type = "textbox" })
    vicious.register(memMeter, vicious.widgets.mem, "mem -$2M ($1%)")
    -- battery meter
    batMeter = widget({type = "textbox"})
    vicious.register(batMeter, vicious.widgets.bat, "$1pwr $2%", 61, "BAT0")

    -- left side creation
    bbLeft = { mpdStatus, layout=awful.widget.layout.horizontal.leftright }
    -- right side creation
    --bbRight = { cpuMeter, memMeter, batMeter, clock }
    bbRight = { clock, separator, batMeter, separator, memMeter, separator, cpuMeter, layout=awful.widget.layout.horizontal.rightleft }

    bottomWibox[s].widgets = { bbLeft, spacer, bbRight, layout=awful.widget.layout.horizontal.leftright } 
end
--- old

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey }, "r", function () cmdPrompt[mouse.screen]:run() end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags, keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[i] then
                          awful.client.movetotag(tags[i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[i] then
                          awful.client.toggletag(tags[i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
		     size_hints_honor = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true, ontop=true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
--{ rule = { class = "urxvt" },
--      properties = { opacity=0.8 } }
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })
    
    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
