-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/LocalPlayer.lua
-- *  PURPOSE:     Local player class
-- *
-- ****************************************************************************
LocalPlayer = inherit(Player)

function LocalPlayer:constructor()
	self.m_Hunger = 100
	self.m_Thirst = 100
end

function LocalPlayer:destructor()
	
end

function LocalPlayer:login(username, password, remember)
	password = sha256("dayz.."..password)
	
	Core:set("login", "remember", remember == true)
	Core:set("login", "password", remember and password)
	Core:set("login", "username", remember and username)
	
	-- Trigger Server RPC
	self:rpc(RPC_PLAYER_LOGIN, username, password)
end

function LocalPlayer:register(username, password)
	password = sha256("dayz.."..password)
	
	-- generate a salt
	local salt = md5(math.random())
	
	-- Trigger Server RPC
	self:rpc(RPC_PLAYER_REGISTER, username, password, salt)
end

function LocalPlayer:rpc(rpc, ...)
	assert(rpc, "Missing RPC called")
	triggerServerEvent("onRPC", resourceRoot, rpc, self, ...)
end

function LocalPlayer:sendMessage(text, r, g, b, ...)
	outputChatBox(text:format(...), r, g, b, true)
end

function LocalPlayer:getLocale()
	return --[[self.m_Locale]]"en"
end

function Player:getHunger()
	return self.m_Hunger
end

function Player:getThirst()
	return self.m_Thirst
end
