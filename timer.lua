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
  sec_elapsed      = 0
}

function update()
  pom.var.sec_elapsed = pom.var.sec_elapsed + 1
  hours = pom.var.sec_elapsed // (60*60)
  minutes = pom.var.sec_elapsed % (60*60) // 60
  seconds = pom.var.sec_elapsed % (60*60*60)
  pom.var.menubar:setTitle(string.format("%02d:%02d:%02d", hours, minutes, seconds))
end 

function pom_enable()
  if pom.var.enabled then
    return
  end

  pom.var.enabled = true
  pom.var.sec_elapsed = 0
  pom.timer = hs.timer.new(pom.config.refresh, update)
  pom.timer:start()
end

function pom_disable()
  pom.var.enabled = false
  pom.var.menubar:setTitle("stopped")
end

function create_menu()
  pom.var.menubar = hs.menubar.new()
  pom.var.menubar:setTitle("stopped")
end

function sleepWatch(eventType)
	if (eventType == hs.caffeinate.watcher.systemWillSleep) then
		pom.timer.stop()
	elseif (eventType == hs.caffeinate.watcher.systemDidWake) then
		pom.timer.start()
	end
end

local sleepWatcher = hs.caffeinate.watcher.new(sleepWatch)
sleepWatcher:start()

create_menu()
pom_enable()