-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/main.lua
-- *  PURPOSE:     Entry script
-- *
-- ****************************************************************************
main = {}

function main.resourceStart()
	-- Instantiate Core
	core = Core:new()
	
	
end
addEventHandler("onResourceStart", resourceRoot, main.resourceStart, true, "high+99999")
