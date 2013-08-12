-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Server.lua
-- *  PURPOSE:     Server class
-- *
-- ****************************************************************************
Server = inherit(Singleton)

function Server:constructor()
	self:rpc(RPC_SERVER_GET_FULL_CONFIG)
	self.m_Config = {}
end

function Server:setConfig(config)
	self.m_Config = config
	core:onConfigRetrieve()
end

function Server:set(key, value)
	self.m_Config[key] = value
end

function Server:get(key)
	return self.m_Config[key]
end

function Server:rpc(rpcid, ...)
	if not rpcid and DEBUG then outputConsole(debug.traceback()) end
	assert(rpcid, "Missing RPC called ")
	triggerServerEvent("onRPC", resourceRoot, rpcid, localPlayer, ...)
end