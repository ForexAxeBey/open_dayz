-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/RPCHandler/ServerRPC.lua
-- *  PURPOSE:     Server RPC class
-- *
-- ****************************************************************************
ServerRPC = inherit(RPC)

function ServerRPC:constructor()
	self:register(RPC_SERVER_GET_FULL_CONFIG, ServerRPC.getFullConfig)
	self:register(RPC_SERVER_SET_CONFIG, ServerRPC.setConfig)
end

function ServerRPC.toElement(element)
	-- Element doesn't matter at all
	return Server:getSingleton()
end

function ServerRPC.getFullConfig(svr, config)
	server:setConfig(config)
end
function ServerRPC.setConfig(svr, key, value)
	outputDebug(svr)
	outputDebug(key)
	outputDebug(value)
	server:set(key, value)
end