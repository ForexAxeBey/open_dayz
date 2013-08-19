-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Player.lua
-- *  PURPOSE:     Player element class
-- *
-- ****************************************************************************
Player = inherit(MTAElement)

-- Register MTA element type class
registerElementClass("player", Player)

function Player:constructor()
	self.m_Id = nil
	self.m_Locale = "en"
	self.m_Inventory = false
	self.m_Kills = 0
	self.m_Deaths = 0
end

function Player:destructor()
	self:save()
end

function Player:save()
	if not self:isLoggedIn() then
		return false
	end
	outputDebug("Player "..getPlayerName(self).." has been saved!")

	local posX, posY, posZ = getElementPosition(self)
	local _, _, rotation = getElementRotation(self)
	local interior = getElementInterior(self)

	sql:queryExec("UPDATE ??_player SET PosX = ?, PosY = ?, PosZ = ?, Rotation = ?, Interior = ?, Kills = ?, Deaths = ? WHERE Id = ?", sql:getPrefix(),
		posX, posY, posZ, rotation, interior, self.m_Kills, self.m_Deaths, self.m_Id)
		
	if self.m_Inventory.m_Id == -1 then
		self.m_Inventory:save()
		sql:queryExec("UPDATE ??_player SET Inventory = ? WHERE Id = ?;", sql:getPrefix(), self.m_Inventory.m_Id, self.m_Id)
	else
		self.m_Inventory:save()
	end
end

function Player:load()
	-- Get all necessary data
	sql:queryFetchSingle(Async.waitFor(self), "SELECT Admin, Locale, PosX, PosY, PosZ, Rotation, Interior, Inventory, Kills, Deaths FROM ??_player WHERE Id = ?", sql:getPrefix(), self.m_Id)
	local row = Async.wait()
	
	self.m_Admin 	= tonumber(row.Admin)
	self.m_Locale	= row.Locale
	self.m_Inventory = Inventory:new(row.Inventory)
	self.m_Inventory:load()
	--self.m_Inventory:addClient(self) -- Jusonex: There is no method named "addClient"?!
	self.m_Kills	= tonumber(row.Kills)
	self.m_Deaths	= tonumber(row.Deaths)
	
	spawnPlayer(self, row.PosX, row.PosY, row.PosZ, row.Rotation, 0, row.Interior)
	fadeCamera(self, true)
	setCameraTarget(self, self)
end

function Player:loadDefault()
	self.m_Inventory = Inventory:new()

	-- Spawn the player first (no existing data yet)
	self:respawn()
	
	-- Save him (to be sure that the first database entry has been initialized correctly)
	self:save()
end

function Player:login(username, password)
	if not username or not password then return end
	
	-- Already logged in?
	if self.m_LoggedIn then 
		self:rpc(RPC_PLAYER_LOGIN, RPC_STATUS_ERROR, RPC_STATUS_ALREADY_LOGGED_IN)
		return false
	end
	
	-- Ask SQL to fetch the salt
	sql:queryFetchSingle(Async.waitFor(self), "SELECT Id, Salt FROM ??_player WHERE Name = ? ", sql:getPrefix(), username)
	local row = Async.wait()
	
	if not row or not row.Id then
		self:rpc(RPC_PLAYER_LOGIN, RPC_STATUS_ERROR, RPC_STATUS_INVALID_USERNAME)
		return
	end
	
	-- Ask SQL to attempt a Login
	sql:queryFetchSingle(Async.waitFor(self), "SELECT Id, Salt FROM ??_player WHERE Id = ? AND Password = ?;", sql:getPrefix(), row.Id, sha256(row.Salt..password))
	local row = Async.wait()
	if not row or not row.Id then
		self:rpc(RPC_PLAYER_LOGIN, RPC_STATUS_ERROR, RPC_STATUS_INVALID_PASSWORD)
		return
	end
	
	-- Success! report back and load
	self.m_Id = row.Id
	self:rpc(RPC_PLAYER_LOGIN, RPC_STATUS_SUCCESS)
	self:load()
	
	callEvent("onPlayerLoggedIn", self, username)
end


function Player:register(username, password, salt)
	if not username or not password or not salt then return end
	
	-- Already logged in?
	if self.m_LoggedIn then 
		self:rpc(RPC_PLAYER_REGISTER, RPC_STATUS_ERROR, RPC_STATUS_ALREADY_LOGGED_IN)
		return false
	end
	
	-- Check if we already know that username
	sql:queryFetchSingle(Async.waitFor(self), "SELECT Id FROM ??_player WHERE Name = ?;", sql:getPrefix(), username, password)
	local row = Async.wait()
	
	if row and row.Id then
		self:rpc(RPC_PLAYER_REGISTER, RPC_STATUS_ERROR, RPC_STATUS_DUPLICATE_USER)
		return
	end
	
	-- Create the user
	sql:queryExec("INSERT INTO ??_player(Name, Password, Salt, Admin, Locale) VALUES(?, ?, ?, ?, ?);", sql:getPrefix(), username, sha256(salt..password), salt, 0, "en")
	
	-- Fetch the userid
	self.m_Id = sql:lastInsertId()
	self:rpc(RPC_PLAYER_REGISTER, RPC_STATUS_SUCCESS)
	
	-- Load default data
	self:loadDefault()
	
	callEvent("onPlayerRegister", self, username)
end

function Player:isLoggedIn()
	return self.m_Id ~= nil
end

function Player:rpc(rpc, ...)
	assert(rpc, "Missing RPC called")
	triggerClientEvent(self, "onRPC", resourceRoot, rpc, self, ...)
end

function Player:getLocale()
	return self.m_Locale
end

function Player:setLocale(locale)
	self.m_Locale = locale
end

function Player:sendMessage(text, r, g, b, ...)
	outputChatBox(text:format(...), self, r, g, b, true)
end

function Player:respawn()
	-- Get a random position
	local posX, posY, posZ = Map:getSingleton():getSpawnpoint()
	spawnPlayer(self, 0, posX, posY, posZ)
	
	fadeCamera(self, true)
	setCameraTarget(self, self)
end

function Player:processNecessities()
	if not self:isLoggedIn() then
		return false
	end

	self.m_Hunger = (self.m_Hunger or 100) - 0.1
	self.m_Thirst = (self.m_Thirst or 100) - 0.1
	
	if self.m_Hunger < 0 then self.m_Hunger = 0 end
	if self.m_Thirst < 0 then self.m_Thirst = 0 end
	
	-- Possibility of 1:100 to get an infect
	if chance(1) then
		self.m_Infected = true
		self:sendMessage("Fuck, you are infected!", 255, 0, 0)
	end
	
	-- Inform the client
	self:rpc(RPC_PLAYER_NECESSITIES_SYNC, self.m_Hunger, self.m_Thirst)
end

function Player:getNecessity(necessity)
	if necessity == NECESSITY_HUNGER then
		return self.m_Hunger
	elseif necessity == NECESSITY_THIRST then
		return self.m_Thirst
	end
	error("Invalid necessity passed to Player:getNecessity")
end

function Player:raiseNecessity(necessity, amount)
	if necessity == NECESSITY_HUNGER then
		self.m_Hunger = (self.m_Hunger + amount <= 100) and self.m_Hunger + amount or 100
	elseif necessity == NECESSITY_THIRST then
		self.m_Thirst = (self.m_Thirst + amount <= 100) and self.m_Thirst + amount or 100
	end
	error("Invalid necessity passed to Player:raiseNecessity")
end

function Player:isInfected()
	return self.m_Infected
end

function Player:getKills()
	return self.m_Kills
end

function Player:addKills(n)
	self.m_Kills = self.m_Kills + n
end

function Player:getDeaths()
	return self.m_Deaths
end

function Player:addDeaths(n)
	self.m_Deaths = self.m_Deaths + n
end
