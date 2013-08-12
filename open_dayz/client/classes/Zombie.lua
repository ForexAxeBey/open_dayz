-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Zombie.lua
-- *  PURPOSE:     Zombie class
-- *
-- ****************************************************************************
Zombie = inherit(NPC)

-- Zombie settings:
-- >Visibility distances
ZOMBIE_SETTINGS_CROUCH_DISTANCE 			= 5
ZOMBIE_SETTINGS_CROUCH_WALK_DISTANCE 		= 15
ZOMBIE_SETTINGS_STAND_DISTANCE				= 25
ZOMBIE_SETTINGS_STAND_WALK_DISTANCE			= 30
ZOMBIE_SETTINGS_STAND_JOG_DISTANCE			= 30
ZOMBIE_SETTINGS_SPRINT_DISTANCE				= 40
-- >Sound
ZOMBIE_SETTINGS_WEAPON_DISTANCES = {
--[[     Chainsaw     ]] 	[9]		= 40,
--[[      Pistol      ]] 	[22]	= 50,
--[[  Silenced Pistol ]] 	[23]	= 25,
--[[      Deagle      ]]	[24]	= 60,
--[[     Shotgun      ]]	[25]	= 70,
--[[ Sawn-Off Shotgun ]] 	[26]	= 70,
--[[  Combat Shotgun  ]]	[27]	= 70,
--[[       Uzi        ]] 	[28]	= 70,
--[[       MP5        ]] 	[29]	= 70,
--[[      TEC-9       ]] 	[32]	= 70,
--[[      AK-47       ]]	[30]	= 100,
--[[        M4        ]]	[31]	= 100,
--[[   Country Rifle  ]] 	[33]	= 100,
--[[      Sniper      ]] 	[34]	= 100,
--[[       RPG        ]] 	[35]	= 100,
--[[ Heat-Seeking RPG ]] 	[36]	= 100,
--[[   Flamethrower   ]] 	[37]	= 50,
--[[      Minigun     ]] 	[38]	= 100
}

ZOMBIE_SETTINGS_EXPLOSION_DISTANCE			= 100 -- Not in use yet

ZOMBIE_SETTINGS_VEHICLE_OFF_DISTANCE		= 5
ZOMBIE_SETTINGS_VEHICLE_ON_DISTANCE			= 50
ZOMBIE_SETTINGS_VEHICLE_HONK_DISTANCE		= 70 -- Not in use yet
ZOMBIE_SETTINGS_BIKE_DISTANCE				= 50 -- Not in use yet
ZOMBIE_SETTINGS_AIRCRAFT_DISTANCE			= 100 -- Not in use yet

-- Zombie status:
enum("ZOMBIE_STATUS_CHASING", "zombiestatus") -- Chasing a target
enum("ZOMBIE_STATUS_SEARCHING", "zombiestatus") -- Lost the target (Going to the last known position)


function Zombie:constructor()
	self.m_LastSeen = Vector(0,0,0)
end

function Zombie:update()		
	if self.m_Status == NPC_STATUS_DEAD then
		return
	end
	
	if self.m_Syncer == localPlayer then
		setTimer(function() self:update() end, 200, 1)
	end
	
	-- Check: Do we have a target?
	if self.m_CurrentTarget then
		-- Update the distance
		self:updateDistanceToTarget(self.m_CurrentTarget)
		
		-- Check: Is the target in range?
		if self:isTargetInFollowRange(self.m_CurrentTarget) then
			-- Check: Is the target in attack range
			if self:isTargetInAttackRange(self.m_CurrentTarget) then
				-- Attack!
				self:attackTarget()
			else
				-- Follow
				local x, y, z = getElementPosition(self.m_CurrentTarget)
				self:move(x, y, z)
				self.m_Status = ZOMBIE_STATUS_CHASING
			end
		else
			-- Let him go and go to the position where we saw him last
			self.m_Status = ZOMBIE_STATUS_SEARCHING
			self.m_CurrentTarget = false
			self:move(self.m_LastSeen.X, self.m_LastSeen.Y, self.m_LastSeen.Z)
		end
	else
		-- Check: Are we searching our last target?
		if self.m_Status == ZOMBIE_STATUS_SEARCHING then
			local x, y, z = getElementPosition(self)
			if getDistanceBetweenPoints3D(x, y, z, self.m_LastSeen.X, self.m_LastSeen.Y, self.m_LastSeen.Z) <= 2 then
				-- Stop walking when we are near the position we saw him last
				self.m_Status = NPC_STATUS_IDLE
				self:stopWalking()
			end
		else
			-- Walk around and try to find a target
			self.m_Status = NPC_STATUS_IDLE
			self:walkAround()
		end
		self:findTarget()
	end
end
	
function Zombie:isTargetInAttackRange(target)
	return self.m_DistanceToTarget <= 2.0
end
	
--ToDo: Check sound
function Zombie:isTargetInFollowRange(target)
	if not target then
		target = self.m_CurrentTarget
		if not self.m_CurrentTarget then return false end
	end
	local x,y,z = getPedBonePosition(self, 7)--head
	local tx,ty,tz = getPedBonePosition(target, 7)-- Head
	local hit ,_,_,_, hitElement = processLineOfSight(x,y,z, tx,ty,tz, true, true, false)-- Visibility check
	local inRange = false
	-- Check: Can we see our target?
	if not hit then		
		local moveState = getPedMoveState(target)
		if moveState == "crouch" and self.m_DistanceToTarget <= ZOMBIE_SETTINGS_CROUCH_DISTANCE then
			inRange = true
		elseif isPedDucked(target) and self.m_DistanceToTarget <= ZOMBIE_SETTINGS_CROUCH_WALK_DISTANCE then
			inRange = true
		elseif moveState == "stand" and self.m_DistanceToTarget <= ZOMBIE_SETTINGS_STAND_DISTANCE then
			inRange = true
		elseif moveState == "walk" and self.m_DistanceToTarget <= ZOMBIE_SETTINGS_STAND_WALK_DISTANCE then
			inRange = true
		elseif moveState == "jog" and self.m_DistanceToTarget <= ZOMBIE_SETTINGS_STAND_JOG_DISTANCE then
			inRange =  true
		elseif moveState == "sprint" and self.m_DistanceToTarget <= ZOMBIE_SETTINGS_SPRINT_DISTANCE then
			inRange = true
		end
		
		if inRange then
			self.m_LastSeen.X = tx
			self.m_LastSeen.Y = ty
			self.m_LastSeen.Z = tz-1
			return inRange
		end
		
		--Check: Is he shooting?
		if getPedControlState(target, "fire") then
			local weapon = getPedWeapon(localPlayer)
			for id, wpDist in pairs(ZOMBIE_SETTINGS_WEAPON_DISTANCES) do
				if id == getPedWeapon(localPlayer) and getDistanceBetweenPoints3D(x,y,z, tx,ty,tz) <= wpDist then
					inRange = true
				end
			end
		end
	elseif hitElement and hitElement == getPedOccupiedVehicle(target) then
		--Check: Vehicle
		if getVehicleEngineState(hitElement) and getDistanceBetweenPoints3D(x,y,z, tx,ty,tz) <= ZOMBIE_SETTINGS_VEHICLE_ON_DISTANCE then
			inRange = true
		elseif not getVehicleEngineState(hitElement) and getDistanceBetweenPoints3D(x,y,z, tx,ty,tz) <= ZOMBIE_SETTINGS_VEHICLE_OFF_DISTANCE then
			inRange = true
		end
		if inRange then
			self.m_LastSeen.X = tx
			self.m_LastSeen.Y = ty
			self.m_LastSeen.Z = tz
		end
	end
	return inRange
end

function Zombie:walkAround()
	-- Check: Are we walking?
	if not getPedControlState(self, "forwards") then
		-- Walk or do nothing
		if math.random(10) == 1 then
			-- Walk in random direction
			self:move(math.random(-9999, 9999), math.random(-9999, 9999), 0)
			setTimer(function() self:stopWalking() end, math.random(1, 3)*1000, 1)
		end
	end
end

function Zombie:findTarget()
	local players = getElementsByType("player")
	local closestPlayer = false
	local dist = 9999
	
	-- Loop through all players
	for _, thePlayer in ipairs(players) do
		-- Set current player as target
		self:setTarget(thePlayer)
		-- Check: Is the target in range?
		if self:isTargetInFollowRange() then
			local x, y, z = getElementPosition(self)
			local tx, ty, tz = getElementPosition(self.m_CurrentTarget)
			currDist = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
			-- Check: Is the current player the closest until now?
			if(currDist < dist)then
				dist = currDist
				closestPlayer = thePlayer
			end
		end
	end
	self:setTarget(closestPlayer)
end

function Zombie:syncerChanged()
	self.m_Syncer = localPlayer
	self:update()
end
