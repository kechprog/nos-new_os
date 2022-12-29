local gears         = require("gears")
local awful         = require("awful")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local switcher      = require("awesome-switcher")

local TERMINAL = "kitty"
local MODKEY   = "Mod1"
local BROWSER  = "firefox"

local function focus(direction)
  return function()
    awful.client.focus.bydirection(direction)
    local c = client.focus
    c:raise()
    if mouse.object_under_pointer() ~= c then
      local geometry = c:geometry()
      local x = geometry.x + geometry.width / 2
      local y = geometry.y + geometry.height / 2
      mouse.coords({ x = x, y = y }, true)
    end
  end
end

local GLOBALKEYS = gears.table.join(
  awful.key({ MODKEY, }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),

  awful.key({ MODKEY, }, "Tab", function()
    switcher.switch(1, "Mod1", "Alt_L", "Shift", "Tab")
  end,
    { description = "alt tab", group = "awesome" }),

  awful.key({ MODKEY, "Shift" }, "Tab", function()
    switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
  end,
    { description = "alt tab", group = "awesome" }),

  awful.key({ MODKEY, }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag" }),

  awful.key({ MODKEY }, "l", focus("right"), -- some wierd shit
    { description = "focus left", group = "awesome" }),

  awful.key({ MODKEY }, "k", focus("up"),
    { description = "focus up", group = "awesome" }),

  awful.key({ MODKEY }, "j", focus("down"),
    { description = "focus down", group = "awesome" }),

  awful.key({ MODKEY }, "h", focus("left"), -- some wierd shit
    { description = "focus right", group = "awesome" }),

  awful.key({ MODKEY, }, "t", function()
    awful.layout.inc(1)
    local tag = client.focus and client.focus.first_tag or nil
    for _, c in ipairs(tag:clients()) do
      if awful.layout.get() == awful.layout.suit.tile then
        awful.titlebar.hide(c, "left") -- god knows why it can't infer position
      else
        awful.titlebar.show(c, "left")
      end
    end
  end,
    { description = "select next", group = "layout" }),

  ------------------------------------------------------------------------
  --                                APPS                                --
  ------------------------------------------------------------------------

  awful.key({ MODKEY, }, "Return", function() awful.spawn(TERMINAL) end,
    { description = "open a terminal", group = "launcher" }),

  awful.key({ MODKEY, }, "w", function() awful.spawn(BROWSER) end,
    { description = "open a terminal", group = "launcher" }),

  awful.key({ MODKEY, "Shift" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),

  awful.key({ MODKEY, "Shift" }, "e", awesome.quit,
    { description = "quit awesome", group = "awesome" }),

  awful.key({ MODKEY, "Shift" }, "space", function() awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }),

  -- Prompt
  awful.key({ MODKEY }, "space", function() awful.spawn.with_shell("rofi -show drun") end,
    { description = "run prompt", group = "launcher" }),

  -- Menubar
  awful.key({ MODKEY }, "p", function() menubar.show() end,
    { description = "show the menubar", group = "launcher" })
)

for i = 1, 9 do
  GLOBALKEYS = gears.table.join(GLOBALKEYS,
    -- View tag only.
    awful.key({ MODKEY }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ MODKEY, "Control" }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ MODKEY, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ MODKEY, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

root.keys(GLOBALKEYS)
