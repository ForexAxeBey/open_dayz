-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/main.lua
-- *  PURPOSE:     Entry script
-- *
-- ****************************************************************************
main = {}

function main.resourceStart()
	-- Instantiate Core
	core = Core:new()
	
	
end
addEventHandler("onClientResourceStart", resourceRoot, main.resourceStart, true, "high+99999")

function main.resourceStop()
	-- Delete the core
	delete(core)
end
addEventHandler("onClientResourceStop", resourceRoot, main.resourceStop, true, "low-999999")