-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/RPCHandler/PlayerRPC.lua
-- *  PURPOSE:     Player RPC class
-- *
-- ****************************************************************************
PlayerRPC = inherit(RPC)

function PlayerRPC:constructor()
	self:register(RPC_PLAYER_LOGIN, PlayerRPC.playerLogin)
	self:register(RPC_PLAYER_REGISTER, PlayerRPC.playerRegister)
	self:register(RPC_SERVER_GET_FULL_CONFIG, PlayerRPC.playerGetFullConfig)
	self:register(RPC_TRANSFER_REQUEST_FILELIST, PlayerRPC.playerRequestFilelist)
	self:register(RPC_TRANSFER_REQUEST_FILES, PlayerRPC.playerRequestFiles)
end

function PlayerRPC.playerLogin(player, client, username, password)
	if player ~= client then return end
	
	player:login(username, password)
end

function PlayerRPC.playerRegister(player, client, username, password, salt)
	if player ~= client then return end
	
	player:register(username, password, salt)
end

function PlayerRPC.playerGetFullConfig(player, client)
	client:rpc(RPC_SERVER_GET_FULL_CONFIG, core:getClientConfig())
end

function PlayerRPC.playerRequestFilelist(player, client)
	client:rpc(RPC_TRANSFER_REQUEST_FILELIST, TransferManager:getSingleton():getOnConnectList())
end

function PlayerRPC.playerRequestFiles(player, client, files)
	TransferManager:getSingleton():getFile(client, files)
end

function PlayerRPC.toElement(element)
	-- Our first parameter is an element, so we are able to return it directly
	return element
end
