-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/RPCs.lua
-- *  PURPOSE:     RPC enumeration
-- *
-- ****************************************************************************
RPCs = {
	-- Player RPCs
	
	-- Object creation RPCs
	enum("RPC_NPC_CREATE", "rpc");
	enum("RPC_ZOMBIE_CREATE", "rpc");
	
	-- register / login
	enum("RPC_PLAYER_LOGIN", "rpc");
	enum("RPC_PLAYER_REGISTER", "rpc");
	enum("RPC_PLAYER_NECESSITIES_SYNC", "rpc");
	-- 
	
	-- NPC RPCs
	enum("RPC_NPC_MOVE", "rpc");
	enum("RPC_NPC_STOP", "rpc");
	enum("RPC_NPC_ATTACK", "rpc");
	enum("RPC_NPC_SYNCER_CHANGED", "rpc");
		
	-- Transfer Manager RPCs
	enum("RPC_TRANSFER_REQUEST_FILELIST", "rpc");
	enum("RPC_TRANSFER_REQUEST_FILES", "rpc");
	
	-- Server RPCs
	enum("RPC_SERVER_GET_FULL_CONFIG", "rpc");
	enum("RPC_SERVER_SET_CONFIG", "rpc");
	
	-- Vehicle RPCs
	enum("RPC_VEHICLE_STARTENGINE", "rpc");
	enum("RPC_VEHICLE_ENTER_SYNC", "rpc");
	enum("RPC_VEHICLE_EXIT_SYNC", "rpc");
	enum("RPC_VEHICLE_SET_FUEL", "rpc");
	enum("RPC_VEHICLE_REMOVE_COMPONENT", "rpc");
	enum("RPC_VEHICLE_ADD_COMPONENT", "rpc");
}

RPCStatus = {
	-- Generic
	enum("RPC_STATUS_SUCCESS", "rpcstatus");
	enum("RPC_STATUS_ERROR", "rpcstatus");
	
	-- Login / Register
	enum("RPC_STATUS_ALREADY_LOGGED_IN", "rpcstatus");
	enum("RPC_STATUS_INVALID_USERNAME", "rpcstatus");
	enum("RPC_STATUS_INVALID_PASSWORD", "rpcstatus");
	enum("RPC_STATUS_DUPLICATE_USER", "rpcstatus");
}

RPCNames = getEnums().rpc
RPCStatusNames = getEnums().rpcstatus

	
function getRPCName(rpcId)
	return RPCNames[rpcId]
end
	
function getRPCStatusName(rpcId)
	return RPCStatusNames[rpcId]
end

function getRPCDebugName(rpcid)
	return RPCNames[rpcid]..(" (%d)"):format(rpcid or -1)
end

function getRPCStatusDebugName(rpcid)
	return (RPCStatusNames[rpcid] or "INVALID_RPC STATUS")..(" (%d)"):format(rpcid or -1)
end
