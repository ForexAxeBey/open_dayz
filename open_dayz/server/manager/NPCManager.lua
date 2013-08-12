-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/manager/NPCManager.lua
-- *  PURPOSE:     Class to manage NPC objects
-- *
-- ****************************************************************************
NPCManager = inherit(Singleton)

function NPCManager:constructor()
	self.m_NPCs = {}
	
	addEventHandler("onElementStartSync", root, 
		function(player)
			if getElementType(source) == "ped" then
				source:rpc(RPC_NPC_SYNCER_CHANGED, player)
			end
		end
	)
	
	-- self.m_DesyncCheckQueue = Queue:new(1000, function() return self.m_RPCs end, NPC.checkDesync) -- Jusonex: This should not be necessary as MTA should sync ped positions
end

function NPCManager:addRef(npc)
	table.insert(self.m_NPCs, npc)
	-- Return insert position/index
	return #self.m_NPCs
end