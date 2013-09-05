-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/ChatRoom.lua
-- *  PURPOSE:     Chat room class
-- *
-- *****************************************************************************
ChatRoom = inherit(Object)

function ChatRoom:constructor()
	self.m_Players = "all"
	self.m_Range = 0
end

function ChatRoom:sendMessage(player, message)
	if self.updatePlayers then self:updatePlayers() end
	
	local players = self.m_Players
	if players == "all" then players = getElementsByType("player") end
	
	if self.m_Range > 0 then
		local x, y, z = getElementPosition(player)
		
		local playersInRange = {}
		local px, py, pz
		for k, v in pairs(players) do
			px, py, pz = getElementPosition(v)
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= self.m_Range then
				playersInRange[#playersInRange+1] = v
			end
		end
		players = playersInRange
	end
	
	for k, v in pairs(players) do
		v:sendMessage("%s: "..message, getPlayerName(player))
	end
end

function ChatRoom:setRange(range)
	self.m_Range = range
end

function ChatRoom:getRange()
	return self.m_Range
end

function ChatRoom:addPlayer(player)
	assert(type(self.m_Players) == "table")
	self.m_Players[#self.m_Players+1] = player
end

function ChatRoom:removePlayer(player)
	assert(type(self.m_Players) == "table")
	local key 
	for k, v in pairs(self.m_Players) do
		if v == player then key = k break end
	end
	if not key then return false end
	
	table.remove(self.m_Players, key)
end

-- virtual method ChatRoom:updatePlayers
-- is called upon chatting. Can be used to
-- limit chat to an area etc.
