-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/manager/PlayerManager.lua
-- *  PURPOSE:     Player manager
-- *
-- ****************************************************************************
PlayerManager = inherit(Singleton)

function PlayerManager:constructor()
	-- Add events
	addEventHandler("onPlayerJoin", root, bind(self.playerJoin, self), true, "high+999")
	addEventHandler("onPlayerWasted", root, bind(self.playerWasted, self))
	
	for _, player in ipairs(getElementsByType("player")) do
		enew(player, Player)
	end
	
	self.m_NecessityQueue = Queue:new(5000, function() return getElementsByType("player") end, Player.processNecessities)
	if not DEBUG then self.m_SavingQueue = Queue:new(10000, function() return getElementsByType("player") end, Player.save) end
end

function PlayerManager:playerJoin()
	--source:rpc(RPC_SHOW_LOGIN)
end

function PlayerManager:playerWasted(totalAmmo, killer, killerWeapon, bodypart, isStealth)
	-- Respawn the player
	setTimer(function(player) player:respawn() end, core:get("player", "respawntime"), 1, source)
	
	-- Increment kills + deaths
	source:addDeaths(1)
	if killer then
		killer:addKills(1)
	end
end
