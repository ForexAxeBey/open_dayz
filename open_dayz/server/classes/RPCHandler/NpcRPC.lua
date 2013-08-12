-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/RPCHandler/NPC_RPC.lua
-- *  PURPOSE:     NPC RPC class
-- *
-- ****************************************************************************
NpcRPC = inherit(RPC)

function NpcRPC:constructor()
	self:register(RPC_NPC_MOVE	, NpcRPC.npcMove)
	self:register(RPC_NPC_STOP	, NpcRPC.npcStop)
	self:register(RPC_NPC_ATTACK, NpcRPC.npcAttack)
end

function NpcRPC.toElement(element)
	return element
end

function NpcRPC.npcMove(npc, triggeredBy, targetX, targetY, targetZ)
	if not NpcRPC.checkSyncer(npc, triggeredBy) then return end
	
	npc:move(targetX, targetY, targetZ)
end

function NpcRPC.npcStop(npc, triggeredBy)
	if not NpcRPC.checkSyncer(npc, triggeredBy) then return end
	
	npc:stopWalking()
end

function NpcRPC.npcAttack(npc, triggeredBy, target)
	if not NpcRPC.checkSyncer(npc, triggeredBy) then return end
	
	npc:attack(target)
end


-- Some helper functions
function NpcRPC.checkSyncer(npc, syncer)
	if not npc:isSyncer(triggeredBy) then
		local syncerName = "No syncer"
		local syncer = getElementSyncer(npc)
		if syncer then
			syncerName = getPlayerName(syncer)
		end
		outputDebugString("Canceled NPC sync from "..getPlayerName(triggeredBy)..". Syncer: "..syncerName)
		return false
	end
	return true
end

