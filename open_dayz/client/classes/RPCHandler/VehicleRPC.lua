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

-- Todo: Move the following to somewhere else
local vehicleComponents = {
	[VEHICLE_COMPONENT_DOOR_LF] = "door_lf_dummy";
	[VEHICLE_COMPONENT_DOOR_RF] = "door_rf_dummy";
	[VEHICLE_COMPONENT_DOOR_LR] = "door_lr_dummy";
	[VEHICLE_COMPONENT_DOOR_RR] = "door_rr_dummy";
	-- Todo: Add mising fields
}

enum("VEHICLE_COMPONENT_DOOR_LF", "vehiclecomponents")

function VehicleRPC.vehicleRemoveComponent(vehicle, component)
	setVehicleComponentVisible(vehicle, vehicleComponents[component], false)
end

function VehicleRPC.vehicleAddComponent(vehicle, component)
	setVehicleComponentVisible(vehicle, vehicleComponents[component], true)
end
