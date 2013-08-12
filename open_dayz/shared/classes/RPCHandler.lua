-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/classes/RPCHandler.lua
-- *  PURPOSE:     RPC handling class
-- *
-- ****************************************************************************
RPCHandler = inherit(Singleton)

function RPCHandler:constructor()
	self.m_RPCs = {}

	addEvent("onRPC", true)
	addEventHandler("onRPC", resourceRoot, bind(RPCHandler.handleRPC, self))
end

function RPCHandler:registerRPC(rpc, classt, callback)
	checkArgs("RPCHandler:registerRPC", "number", "table", "function")

	if not self.m_RPCs[rpc] then
		self.m_RPCs[rpc] = {}
	end
	self.m_RPCs[rpc][classt] = callback
end

function RPCHandler:handleRPC(rpc, elementId, ...)
	outputDebug("RPC "..tostring(getRPCName(rpc)).." was called!")
	
	assert(self.m_RPCs[rpc], "RPC without handlers called "..getRPCDebugName(rpc))
	for classt, callback in pairs(self.m_RPCs[rpc]) do
		local instance = classt.toElement(elementId)
		assert(instance)
		
		if client then -- We're serverside
			Async.create(callback)(instance, client, ...)
		else
			Async.create(callback)(instance, ...)
		end
	end
end
