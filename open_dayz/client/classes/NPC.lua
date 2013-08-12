-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/NPC.lua
-- *  PURPOSE:     NPC class
-- *
-- ****************************************************************************
NPC = inherit(Object)

-- NPC status:
enum("NPC_STATUS_IDLE", "npcstatus") -- Doing nothing / Walking around
enum("NPC_STATUS_MOVING", "npcstatus") -- Chasing a target
enum("NPC_STATUS_ATTACKING", "npcstatus") -- Attacking a target
enum("NPC_STATUS_DEAD", "npcstatus") -- NPC is dead

function NPC:constructor()
	self.m_CurrentTarget 	= false
	self.m_Status 			= NPC_STATUS_IDLE
	self.m_DistanceToTarget = math.huge
end

function NPC:destructor()
	if self and isElement(self) then
		destroyElement(self)
	end
end

function NPC:update()		
	
end

function NPC:updateDistanceToTarget(target)
	local x, y, z = getElementPosition(self)
	local tx, ty, tz = getElementPosition(target)
	self.m_DistanceToTarget = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) 
end

-- Just calculating information that is needed to move the NPC and sending to the server
function NPC:move(tx, ty, tz)
	self:rpc(RPC_NPC_MOVE, rot)
end

-- Actually moving the NPC
function NPC:_move(tx, ty, tz)
	local x, y, z = getElementPosition(self)
	local rot = math.deg(math.atan((ty-y)/(tx-x)))
	if (tx-x) < 0 then
		rot = rot + 180
	end

	setPedCameraRotation(self, -rot + 90)
	if not getPedControlState(self, "forwards") then
		setPedControlState(self, "forwards", true)
	end
end

-- Sending stop request
function NPC:stopWalking()
	self:rpc(RPC_NPC_STOP)
end

-- Actually stopping
function NPC:_stopWalking()
	setPedControlState(self, "forwards", false)
end

-- Sending attack request
function NPC:attackTarget()
	self:rpc(RPC_NPC_ATTACK, self.m_CurrentTarget)
end

-- Actually attacking >>>ToDo: Turn ped into targets direction if not in melee range<<<
function NPC:_attackTarget()
	self:_stopWalking()
	local x, y, z = getElementPosition(self.m_CurrentTarget)
	setPedAimTarget(self, x, y, z)
	setPedControlState(self, "fire", true)
	self.m_Status = NPC_STATUS_ATTACKING
	
	setTimer(function() setPedControlState (self, "fire", false) end, 300, 1)
end

function NPC:setTarget(target)
	self.m_CurrentTarget = target
	if target == false then
		self.m_DistanceToTarget = math.huge
	else
		self:updateDistanceToTarget(target)
	end
end

function NPC:syncerChanged()

end