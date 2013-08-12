-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/NPC.lua
-- *  PURPOSE:     NPC class
-- *
-- ****************************************************************************
NPC = inherit(Object)

-- NPC status:
enum("NPC_STATUS_IDLE", "npcstatus") -- Doing nothing / Walking around
enum("NPC_STATUS_CHASING", "npcstatus") -- Chasing a target
enum("NPC_STATUS_ATTACKING", "npcstatus") -- Attacking a target
enum("NPC_STATUS_DEAD", "npcstatus") -- NPC is dead

function NPC:new(skin, posX, posY, posZ, rotation)
	local ped = createPed(skin, posX, posY, posZ, rotation)
	enew(ped, self)
	return ped
end

function NPC:constructor()
	self.m_CurrentTarget 	= false
	self.m_Status 			= NPC_STATUS_IDLE
	self.m_DistanceToTarget = math.huge
	
	-- Register the NPC reference
	NPCManager:getSingleton():addRef(self)
	
	-- Tell all clients that the world has got a new NPC now
	self:rpc(RPC_NPC_CREATE, ped, "Zombie")
end

function NPC:move(targetX, targetY, targetZ)
	self:rpc(RPC_NPC_MOVE, targetX, targetY, targetZ)
end

function NPC:stopWalking()
	self:rpc(RPC_NPC_STOP)
end

function NPC:attack(player)
	self.m_CurrentTarget = player
	self.m_Status = NPC_STATUS_ATTACKING
	
	self:rpc(RPC_NPC_ATTACK, player)
end

function NPC:checkDesync(posX, posY, posZ, rotation)
	local x, y, z = getElementPosition(self)
	
	-- Don't correct the position if the server position is about the same as the one from the syncer to prevent bucking
	if getDistanceBetweenPoints3D(x, y, z, posX, posY, posZ) >= 0.5 then
		setElementPosition(self, posX, posY, posZ)
	end
	
	if isPedDead(self) then
		self.m_Status = NPC_STATUS_DEAD
	end
end

function NPC:isSyncer(player)
	return getElementSyncer(self) == player
end
