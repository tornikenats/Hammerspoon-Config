
--------------------------------------------------------------------------------
-- Configuration variables
--------------------------------------------------------------------------------
local pom={}
pom.bar = {
  indicator_height          = 0.1, -- ratio from the height of the menubar (0..1)
  indicator_alpha           = 1,
  indicator_in_all_spaces   = true,
  color_time_remaining      = hs.drawing.color.green,
  color_time_remaining_rest = hs.drawing.color.x11.deepskyblue,
  color_time_remaining_custom = hs.drawing.color.x11.gold,
  color_time_used           = hs.drawing.color.red,

  c_left = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0)),
  c_used = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
}

pom.config = {
  enable_color_bar          = true,
  work_period_sec           = 25 * 60,
  rest_period_sec           = 5 * 60,
  long_rest_period_sec      = 15 * 60,
  total_rest_count          = 4,
  refresh                   = 1 -- seconds
}

pom.var = { 
  is_active                 = false,
  mode                      = "work", -- {"work", "rest"}
  time_left                 = pom.config.work_period_sec,
  max_time_sec              = pom.config.work_period_sec,
  rest_count                = 0,
  menubar                   = nil
}

function draw(target, offset, width, fill_color)
  screen = hs.screen.mainScreen()
  screen_rect = screen:fullFrame()

  target:setSize(hs.geometry.rect(screen_rect.x + offset, screen_rect.y, width, 2))
  target:setTopLeft(hs.geometry.point(screen_rect.x + offset, screen_rect.y))
  target:setFillColor(fill_color)
  target:setFill(true)
  target:setAlpha(pom.bar.indicator_alpha)
  target:setLevel(hs.drawing.windowLevels.overlay)
  target:setStroke(false)
  target:show()
end

function update()
  pom.var.time_left = pom.var.time_left - pom.config.refresh

  if pom.var.time_left < 0 then
    pom_disable()
    hs.notify.new({
        title="Finished!",
        informativeText=text
    }):send()

    if pom.var.mode == 'work' then
      text = 'Relax now!'
      start_rest()
    elseif pom.var.mode == 'rest' then
      text = 'Work now!'
      start_work()
    end
  end

  screen = hs.screen.mainScreen()
  screen_rect = screen:fullFrame()
  local time_ratio  = pom.var.time_left / pom.var.max_time_sec
  local width       = math.ceil(screen_rect.w * time_ratio)
  local offset  = screen_rect.w - width
  if pom.var.mode == "work" then
    draw(pom.bar.c_left, offset, width, pom.bar.color_time_remaining)
  elseif pom.var.mode == "rest" then
    draw(pom.bar.c_left, offset, width, pom.bar.color_time_remaining_rest)
  end
  draw(pom.bar.c_used, 0, offset, pom.bar.color_time_used)

  pom.var.menubar:setTitle(pom.var.mode .. " " .. (math.ceil(time_ratio * 100)) .. "%")
end

function start_work()
  pom.var.mode = "work"
  pom_enable()
end

function start_rest()
  pom.var.mode = "rest"
  pom.var.rest_count = pom.var.rest_count + 1

  -- Long rest every 4 rests
  if pom.var.rest_count > pom.var.total_rest_count then
    pom.var.max_time_sec = pom.config.rest_period_sec
    pom.var.time_left = pom.config.rest_period_sec
  end

  pom_enable()
end

function pom_enable()
  if pom.var.enabled then
    return
  end

  pom.var.enabled = true
  pom.var.menubar:setTitle(pom.var.mode)

  pom.bar.c_left = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
  pom.bar.c_used = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))

  if pom.var.mode == "work" then
    pom.var.max_time_sec = pom.config.work_period_sec
    pom.var.time_left = pom.config.work_period_sec
  elseif pom.var.mode == "rest" then
    pom.var.max_time_sec = pom.config.rest_period_sec
    pom.var.time_left = pom.config.rest_period_sec
  end
  pom_timer = hs.timer.new(pom.config.refresh, update)
  pom_timer:start()
end

function pom_disable()
  pom_timer:stop()
  pom_timer = nil  
  pom.bar.c_left:delete()
  pom.bar.c_left = nil
  pom.bar.c_used:delete()
  pom.bar.c_used = nil
  pom.var.enabled = false
  pom.var.menubar:setTitle("Pomodoro")
end

function create_menu()
  pom.var.menubar = hs.menubar.new()
  pom.var.menubar:setTitle("Pomodoro")
  pom.var.menubar:setMenu({
      { title="Start", fn=start_work },
      { title="Stop", fn=pom_disable}
    })
end

function create_url_events()
  hs.urlevent.bind("start", work)
  hs.urlevent.bind("stop", pom_disable)
end

create_menu()
create_url_events()