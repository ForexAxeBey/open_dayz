-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Vehicle.lua
-- *  PURPOSE:     Vehicle element class
-- *
-- ****************************************************************************
Vehicle = inherit(MTAElement)
registerElementClass("vehicle", Vehicle)

function Vehicle:constructor()
	self.m_Fuel = 100

	-- Add event handlers
	addEventHandler("onClientVehicleEnter", self, bind(self.Event_vehicleEnter, self))
	addEventHandler("onClientVehicleExit", self, bind(self.Event_vehicleExit, self))
end

function Vehicle:destructor()
	
end

function Vehicle:getFuel()
	return self.m_Fuel
end


function Vehicle:Event_vehicleEnter(player, seat)
	if player == localPlayer then
		self.m_FuelTimer = setTimer(function() self.m_Fuel = self.m_Fuel - 0.05 end, 2000, 0)
		
	end
end

function Vehicle:Event_vehicleExit(player, seat)
	if player == localPlayer then
		-- First some clean-ups
		if self.m_FuelTimer and isTimer(self.m_FuelTimer) then
			killTimer(self.m_FuelTimer)
		end
		
		-- Do the exit sync
		self:rpc(RPC_VEHICLE_EXIT_SYNC, self:getFuel())
	
	end
end
