-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/manager/NPCManager.lua
-- *  PURPOSE:     Class to manage NPC objects
-- *
-- ****************************************************************************
NPCManager = inherit(Singleton)

function NPCManager:constructor()
	
end

function NPCManager:addNPCByRef(npc, class)
	-- npc is the ped element -> we call enew, so that NPC:constructor will be calle
	enew(npc, _G[class])
end