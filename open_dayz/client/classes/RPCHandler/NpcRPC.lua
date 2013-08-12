-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/RPCHandler/NPC_RPC.lua
-- *  PURPOSE:     NPC RPC class
-- *
-- ****************************************************************************
NpcRPC = inherit(RPC)

function NpcRPC:constructor()
	self:register(RPC_NPC_MOVE			, NpcRPC.npcMove)
	self:register(RPC_NPC_STOP			, NpcRPC.npcStop)
	self:register(RPC_NPC_ATTACK		, NpcRPC.npcAttack)
	self:register(RPC_NPC_SYNCER_CHANGED, NpcRPC.syncerChanged)
end

function NpcRPC.toElement(element)
	return element
end

function NpcRPC.npcMove(npc, tx, ty, tz)
	npc:_move(tx, ty, tz)
end

function NpcRPC.npcStop(npc, _)
	npc:_stopWalking()
end

function NpcRPC.npcAttack(npc, target)
	npc:setTarget(target)
	npc:_attackTarget()
end

function NpcRPC.syncerChanged(npc, newSyncer)
	if newSyncer == localPlayer then
		npc:syncerChanged()
	end
end