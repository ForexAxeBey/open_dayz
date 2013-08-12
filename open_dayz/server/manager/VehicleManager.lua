-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/manager/VehicleManager.lua
-- *  PURPOSE:     Vehicle manager
-- *
-- ****************************************************************************
VehicleManager = inherit(Singleton)

function VehicleManager:constructor()
	-- Add events
	addEventHandler("onVehicleStartEnter", root, function(...) source:onStartEnter(...) end)
end
