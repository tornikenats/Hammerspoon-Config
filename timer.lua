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
  sec_elapsed      = 0,
  start_date       = nil
}

function update()
  pom.var.sec_elapsed = pom.var.sec_elapsed + 1
  hours = pom.var.sec_elapsed // (60*60)
  minutes = pom.var.sec_elapsed // 60 % 60
  seconds = pom.var.sec_elapsed % 60
  pom.var.menubar:setTitle(string.format("%02d:%02d:%02d", hours, minutes, seconds))

  if pom.var.start_date ~= os.date("%F") then
    -- Save statistics
    stat_file = io.open("stats.txt", "a")
    stat_file:write(pom.var.start_date .. ": " .. string.format("%02d:%02d:%02d", hours, minutes, seconds) .. "\n")
    stat_file:flush()
    stat_file:close()
    pom.var.sec_elapsed = 0
    pom.var.start_date = os.date("%F")
  end
end 

function pom_enable()
  if pom.var.enabled then
    return
  end

  pom.var.enabled = true
  pom.var.sec_elapsed = 0
  pom.var.start_date = os.date("%F")
  pom.timer = hs.timer.new(pom.config.refresh, update)
  pom.timer:start()
end

function pom_disable()
  pom.var.enabled = false
  pom.var.menubar:setTitle("stopped")
end

function create_menu()
  pom.var.menubar = hs.menubar.new()
  pom.var.menubar:setTitle("loading...")
  hs.caffeinate.watcher.new(sleepWatch):start()  
end

function sleepWatch(eventType)
	if eventType == hs.caffeinate.watcher.systemWillSleep or eventType == hs.caffeinate.watcher.systemWillPowerOff then
		pom.timer:stop()
	elseif eventType == hs.caffeinate.watcher.systemDidWake then
		pom.timer:start()
	end
end

create_menu()
pom_enable()