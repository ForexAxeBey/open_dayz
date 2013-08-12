-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/RPCHandler/RPC.lua
-- *  PURPOSE:     RPC base class
-- *
-- ****************************************************************************
RPC = inherit(Object)

function RPC:register(rpc, callback)	
	assert(rpc, "Non-existing rpc registered")
	
	return RPCHandler:getSingleton():registerRPC(rpc, self, callback)
end

RPC.toElement = pure_virtual
