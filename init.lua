require "pomodoro"
--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------
local cmd = {"cmd"}
local alt = {"alt"}
local alt_shift = {"alt", "shift"}
local cmd_alt = {"cmd", "alt"}
local ctrl_alt = {"ctrl", "alt"}
local ctrl_alt_shift = {"ctrl", "alt", "shift"}
local cmd_shift = {"cmd", "shift"}
local ctrl_shift = {"ctrl", "shift"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"}
local main_monitor = hs.screen.allScreens()[1]
local second_monitor = hs.screen.allScreens()[2]

--------------------------------------------------------------------------------
-- CONFIGURATIONS
--------------------------------------------------------------------------------
hs.window.animationDuration = 0

function config()
  hs.hotkey.bind(cmd, "escape", function() 
    hs.caffeinate.systemSleep()
  end)

    -- SIZING SHORTCUTS
  hs.hotkey.bind(alt, "w", function()
    local win = hs.window.focusedWindow()
    win:right()
  end)

  hs.hotkey.bind(alt, "q", function()
    local win = hs.window.focusedWindow()
    win:left()
  end)

  hs.hotkey.bind(alt, "d", function()
    local win = hs.window.focusedWindow()
    win:up()
  end)

  hs.hotkey.bind(alt, "c", function()
    local win = hs.window.focusedWindow()
    win:down()
  end)

  hs.hotkey.bind(alt, "a", function()
    local win = hs.window.focusedWindow()
    win:upLeft()
  end)

  hs.hotkey.bind(alt, "z", function()
    local win = hs.window.focusedWindow()
    win:downLeft()
  end)

  hs.hotkey.bind(alt, "x", function()
    local win = hs.window.focusedWindow()
    win:downRight()
  end)

  hs.hotkey.bind(alt, "s", function()
    local win = hs.window.focusedWindow()
    win:upRight()
  end)

  hs.hotkey.bind(alt, "space", function()
    local win = hs.window.focusedWindow()
    hs.window.fullscreen(win)
  end)

  -- FOCUS SHORTCUTS

  hs.hotkey.bind(alt_shift, "1", function()
    local win = hs.window.focusedWindow()
    if (win) then
      win:moveToScreen(main_monitor)
    end
  end)

  hs.hotkey.bind(alt_shift, "2", function()
    local win = hs.window.focusedWindow()
    if (win) then
      win:moveToScreen(second_monitor)
    end
  end)

  hs.hotkey.bind(cmd_alt_ctrl, "R", function()
    hs.reload()
    hs.alert.show("Config loaded")
  end)

  hs.hotkey.bind(cmd_alt_ctrl, "T", function()
    print(hs.window.focusedWindow():title())
    -- log = hs.logger.new('init', 'debug')
    -- for _, app in pairs(hs.window.allWindows()) do
    --   log:d(app:title())
    --   -- for _, w in pairs(app:allWindows()) do
    --   --   if w ~= nil then
    --   --     log:d('\t' .. w:title())
    --   --     if w:title() == "Microsoft Remote Desktop" then
    --   --       w:focus()
    --   --     end
    --   --   end
    --   -- end
    -- end
    -- x = hs.window.frontmostWindow():application():name()
    -- hs.alert.show(tostring(x))
    -- hs.alert.show(hs.window.focusedWindow():screen():name())
  end)

-- APPLICATION SHORTCUTS

  hs.hotkey.bind(cmd_shift, "=", function() 
    hs.application.launchOrFocus('Finder') 
    hs.application.get("Finder"):selectMenuItem({"Window", "Bring All to Front"})
  end)

  hs.hotkey.bind(cmd_shift, "1", function() 
    hs.application.launchOrFocus('Google Chrome') 
  end)

  hs.hotkey.bind(cmd, "1", function() 
    hs.application.launchOrFocus('Safari') 
  end)

  hs.hotkey.bind(cmd, "2", function() 
    hs.application.launchOrFocus('iTerm') 
  end)

  hs.hotkey.bind(cmd_shift, "2", function() 
    hs.application.launchOrFocus('Terminal') 
  end)

  hs.hotkey.bind(cmd, "3", function()
    hs.application.launchOrFocus('Visual Studio Code')
  end)

  hs.hotkey.bind(cmd, "4", function() 
    hs.application.launchOrFocus('Android Studio') 
  end)

  hs.hotkey.bind(cmd_shift, "M", function() 
    hs.application.launchOrFocus('Mail') 
  end)

  hs.hotkey.bind(cmd_shift, "C", function() 
    hs.application.launchOrFocus('Calendar') 
  end)
end

--------------------------------------------------------------------------------
-- METHODS - BECAREFUL :)
--------------------------------------------------------------------------------

function launchOrFocusWindowOnMainScreen(name)
  app = hs.application.get(name)
  if app == nil then
    app = hs.application.open(name)
  end

  print(tostring(#app:allWindows()))
  if #app:allWindows() == 1 then
    print('hi')
    app:activate()
  end

  for _, w in pairs(app:allWindows()) do
    if w:screen() == hs.screen.mainScreen() then
      w:focus()
    end
  end
end

function hs.screen.get(screen_name)
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    if screen:name() == screen_name then
      return screen
    end
  end
end

-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function hs.window.right(win)
  local frame = win:screen():frame()
  frame.x = frame.x + frame.w/2
  frame.w = frame.w/2
  win:setFrame(frame)
end

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function hs.window.left(win)
  local frame = win:screen():frame()
  frame.w = frame.w/2
  win:setFrame(frame)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function hs.window.up(win)
  local frame = win:screen():frame()
  frame.h = frame.h/2
  win:setFrame(frame)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function hs.window.down(win)
  local frame = win:screen():frame()
  frame.y = frame.y + frame.h/2
  frame.h = frame.h/2
  win:setFrame(frame)
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function hs.window.upLeft(win)
  local frame = win:screen():frame()
  frame.h = frame.y + frame.h/2
  frame.w = frame.w/2
  win:setFrame(frame)
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function hs.window.downLeft(win)
  local frame = win:screen():frame()
  frame.y = frame.y + frame.h/2
  frame.h = frame.h/2
  frame.w = frame.w/2
  win:setFrame(frame)
end

-- +-----------------+
-- |                 |
-- |        +--------|
-- |        |  HERE  |
-- +-----------------+
function hs.window.downRight(win)
  local frame = win:screen():frame()
  frame.y = frame.y + frame.h/2
  frame.x = frame.x + frame.w/2
  frame.h = frame.h/2
  frame.w = frame.w/2
  win:setFrame(frame)
end

-- +-----------------+
-- |        |  HERE  |
-- |        +--------|
-- |                 |
-- +-----------------+
function hs.window.upRight(win)
  local frame = win:screen():frame()
  frame.x = frame.x + frame.w/2
  frame.h = frame.h/2
  frame.w = frame.w/2
  win:setFrame(frame)
end

function hs.window.fullscreen(win)
  win:setFrame(win:screen():frame())
end

config()