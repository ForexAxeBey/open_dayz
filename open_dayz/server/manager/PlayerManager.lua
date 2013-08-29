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
	addEventHandler("onPlayerChat", root, bind(self.playerChat, self))
	
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

function PlayerManager:playerChat(msg, mtype)
	-- NOTE: IF YOU HAVE FREEROAM ENABLED YOU MAY GET DOUBLE MESSAGES
	
	-- Check if the message type is a normal one
	if mtype == 0 then
		-- Cancel the event so the message isn't displayed for all
		cancelEvent()
	
		-- Get the sender position
		local x, y, z = getElementPosition(source)
		
		-- Iterate over all the players
		for k, v in ipairs(getElementsByType("player")) do
			-- Get player position
			local x2, y2, z2 = getElementPosition(v)
			
			-- Check if the distance is less than the talkDistance value
			if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < core:get("player", "talkdistance") then
				-- If it is then display the message for him
				v:sendMessage(getPlayerName(source).."#E7D9B0: "..msg, v, 231, 217, 176)
			end
		end
	end
end