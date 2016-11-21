--------------------------------------------------------------------------------
-- Configuration variables
--------------------------------------------------------------------------------
local pom={}

pom.config = {
  refresh = 1 -- seconds
}

pom.var = { 
  is_active        = false,
  menubar          = nil,
  start_time       = 0
}

function update()
  elapsed = hs.timer.secondsSinceEpoch() - pom.var.start_time
  seconds = elapsed / 1000
  minutes = seconds / 60
  hours = minutes / 60
  pom.var.menubar:setTitle(hours + ":" + minutes + ":" + seconds)
end 

function pom_enable()
  if pom.var.enabled then
    return
  end

  pom.var.enabled = true
  pom.var.start_time = hs.timer.secondsSinceEpoch()
  pom_timer = hs.timer.new(pom.config.refresh, update)
  pom_timer:start()
end

function pom_disable()
  pom.var.enabled = false
  pom.var.menubar:setTitle("stopped")
end

function create_menu()
  pom.var.menubar = hs.menubar.new()
  pom.var.menubar:setTitle("stopped")
end

create_menu()
pom_enable()