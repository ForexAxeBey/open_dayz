-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/RPCHandler/VehicleRPC.lua
-- *  PURPOSE:     Vehicle RPC class
-- *
-- ****************************************************************************
VehicleRPC = inherit(RPC)

function VehicleRPC:constructor()
	self:register(RPC_VEHICLE_ENTER_SYNC, VehicleRPC.vehicleEnterSync)
	self:register(RPC_VEHICLE_SET_FUEL, VehicleRPC.vehicleSetFuel)
	self:register(RPC_VEHICLE_REMOVE_COMPONENT, VehicleRPC.vehicleRemoveComponent)
	self:register(RPC_VEHICLE_ADD_COMPONENT, VehicleRPC.vehicleAddComponent)
end

function VehicleRPC.toElement(element)
	return element
end

function VehicleRPC.vehicleEnterSync(vehicle, fuel)
	vehicle.m_Fuel = fuel -- Since we do not want to allow access via addon we have to modify it directly here
	
end

function VehicleRPC.vehicleSetFuel(vehicle, fuel)
	vehicle.m_Fuel = fuel
	
end

function VehicleRPC.vehicleRemoveComponent(vehicle, component)
	vehicle:removeComponent(component)
end

function VehicleRPC.vehicleAddComponent(vehicle, component)
	vehicle:addComponent(component)
end
