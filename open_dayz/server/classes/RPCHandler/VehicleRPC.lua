-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/RPCHandler/VehicleRPC.lua
-- *  PURPOSE:     Vehicle RPC class
-- *
-- ****************************************************************************
VehicleRPC = inherit(RPC)

function VehicleRPC:constructor()
	self:register(RPC_VEHICLE_EXIT_SYNC, VehicleRPC.vehicleExitSync)
end

function VehicleRPC.toElement(element)
	return element
end

function VehicleRPC.vehicleExitSync(vehicle, client, remainingFuel)
	-- Process fuel; If the remaining fuel is higher then the fuel on the server there's a desync or the player has some kind of cheat
	if remainingFuel > vehicle:getFuel() then
		AntiCheat:getSingleton():reportViolation(client, CHEAT_FUEL_DESYNC)
	else
		vehicle:setFuel(remainingFuel)
	end
	
end
