pcall(require, "luarocks.loader")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")


local TERMINAL = "kitty"
local MODKEY = "Mod1"


-- launcher widget
mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = awful.menu({ items = {
    { "open terminal", TERMINAL },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
  } })
})


local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ MODKEY }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ MODKEY }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        { raise = true }
      )
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end)
)



awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])



  -- widget with all tags
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- widget with all application running
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }

  -- clock widget
  local mytextclock = wibox.widget.textclock()

  -- layout widget
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end ),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc(1) end ),
    awful.button({}, 5, function() awful.layout.inc(-1) end)
  ))

  -- Create an actual bar
  s.mywibox = awful.wibar({ position = "bottom", screen = s })
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,

    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,

      mylauncher,
      s.mytaglist,
    },

    s.mytasklist, -- Middle widget

    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,

      -- wibox.widget.systray -- god knows what is it.
      mytextclock,
      s.mylayoutbox,
    },
  }
end)
