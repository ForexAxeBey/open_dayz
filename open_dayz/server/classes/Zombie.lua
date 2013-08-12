-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Zombie.lua
-- *  PURPOSE:     Zombie class
-- *
-- ****************************************************************************
Zombie = inherit(NPC)

-- Zombie status:
enum("ZOMBIE_STATUS_CHASING", "zombiestatus") -- Chasing a target
enum("ZOMBIE_STATUS_SEARCHING", "zombiestatus") -- Lost the target (Going to the last known position)

function Zombie:constructor()
	-- Call base class constructor
	NPC.constructor(self)

	self.m_LastSeen = Vector(0, 0, 0)
end