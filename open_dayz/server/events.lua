-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/events.lua
-- *  PURPOSE:     Event list
-- *
-- ****************************************************************************

local events = {
	-- Player events
	"onPlayerLoggedIn",
	"onPlayerRegister",
	
}

for k, eventName in ipairs(events) do
	addEvent(eventName, false)
end
