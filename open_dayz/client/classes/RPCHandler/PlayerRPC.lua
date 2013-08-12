-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/RPCHandler/PlayerRPC.lua
-- *  PURPOSE:     Player RPC class
-- *
-- ****************************************************************************
PlayerRPC = inherit(RPC)

function PlayerRPC:constructor()
	-- Object creation RPCs
	self:register(RPC_NPC_CREATE, PlayerRPC.npcCreate)
	self:register(RPC_ZOMBIE_CREATE, PlayerRPC.zombieCreate)

	self:register(RPC_PLAYER_LOGIN, PlayerRPC.playerLogin)
	self:register(RPC_PLAYER_REGISTER, PlayerRPC.playerRegister)
	
	self:register(RPC_TRANSFER_REQUEST_FILELIST, PlayerRPC.transferRequestFilelist)
	self:register(RPC_TRANSFER_REQUEST_FILES, PlayerRPC.transferRequestFiles)
	
	-- Sync RPCs
	self:register(RPC_PLAYER_NECESSITIES_SYNC, PlayerRPC.playerNecessitiesSync)
end

function PlayerRPC.toElement(element)
	-- Our first parameter is an element, so we are able to return it directly
	return element
end

function PlayerRPC.npcCreate(npc)
	NPCManager:getSingleton():addNPCByRef(npc, "NPC") -- Todo
end

function PlayerRPC.zombieCreate(zombie)
	ZombieManager:getSingleton():addZombieByRef(zombie, "Zombie") -- Todo
end

function PlayerRPC.playerLogin(player, status, reason)
	if status == RPC_STATUS_ERROR then
		if reason == RPC_STATUS_ALREADY_LOGGED_IN then
			localPlayer:sendMessage(_"Login failed. You're already logged in!", 255, 0, 0)
			return
		elseif reason == RPC_STATUS_INVALID_USERNAME or reason == RPC_STATUS_INVALID_PASSWORD then
			localPlayer:sendMessage(_"Login failed. Invalid username / password!", 255, 0, 0)
			return
		end
	elseif status == RPC_STATUS_SUCCESS then
		localPlayer:sendMessage(_"Sucessfully logged in!")
	end
end

function PlayerRPC.playerRegister(player, status, reason)
	if status == RPC_STATUS_ERROR then
		if reason == RPC_STATUS_ALREADY_LOGGED_IN then
			localPlayer:sendMessage(_"Registration failed. You're already logged in!", 255, 0, 0)
			return
		elseif reason == RPC_STATUS_DUPLICATE_USER then
			localPlayer:sendMessage(_"Registration failed. A user with the desired name already exists!", 255, 0, 0)
			return
		end
	elseif status == RPC_STATUS_SUCCESS then
		localPlayer:sendMessage(_"Sucessfully registered!")
	end
end

function PlayerRPC.transferRequestFilelist(player, filelist)
	TransferManager:getSingleton():receiveOnConnectList(filelist)
end

function PlayerRPC.transferRequestFiles(player, filelist)
	TransferManager:getSingleton():receiveFiles(filelist)
end

function PlayerRPC.playerNecessitiesSync(player, hunger, thirst)
	player.m_Hunger = hunger
	player.m_Thirst = thirst
	
	-- Update HUD cache
	HUDArea:getSingleton():updateArea()
end
