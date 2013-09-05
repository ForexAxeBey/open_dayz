-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Core.lua
-- *  PURPOSE:     Core class
-- *
-- ****************************************************************************
Core = inherit(Singleton)

function Core:constructor()
	-- Small hack to get the global core immediately
	core = self
	
	outputDebugString "Core instantiated"
		
	-- Add Event handlers
	addEventHandler("onConfigChange", resourceRoot, bind(Core.onConfigChange, self))
	
	-- Initialize debug system
	Debugging:new()
	
	-- Initialize config system
	self.m_MainConfig = ConfigXML:new("config.xml")
	self:applyDefaultConfig()
	
	-- Establish database connection
	local dbtype = self:get("sql", "dbtype")
	if dbtype == "sqlite" then
		local sqlpath = self:get("sql", "sqlite_path")
		sql = SQLite:new(sqlpath)
		sql:setPrefix(self:get("sql", "prefix"))
		DatabaseUpdaterSQLite:updateDatabase()
		
	elseif dbtype == "mysql" then
		local host = self:get("sql", "mysql_host")
		local user = self:get("sql", "mysql_user")
		local database = self:get("sql", "mysql_database")
		local port = self:get("sql", "mysql_port")
		local password = self:get("sql", "mysql_password")
		local unixsocket = self:get("sql", "mysql_unix_socket")
		
		sql = MySQL:new(host, port, user, password, database, unixsocket)
		sql:setPrefix(self:get("sql", "prefix"))
		
		DatabaseUpdaterMySQL:updateDatabase()
	else
		critical_error("Invalid Database Type specified")
	end
	
	-- Initialize RPC system
	RPCHandler:new()
	PlayerRPC:new()
	NpcRPC:new()
	VehicleRPC:new()
	
	-- Initialize managers
	TransferManager:new()
	PlayerManager:new()
	TranslationManager:new()
	NPCManager:new()
	VehicleManager:new()
	
	-- Apply Time Settings
	local realtime = getRealTime()
	setTime(realtime.hour, realtime.minute)
    setMinuteDuration(60000*self:get("global", "timescale"))
	
	-- Chat Rooms
	self.m_GlobalChat = ChatRoom:new()
	self.m_GlobalChat.m_Players = "all"
	self.m_AdminChat = ChatRoom:new()
	
	-- Disable statistics if debugging mode is on
	if not DEBUG then
		Statistics:new()
	end
end


function Core:destructor()
	PlayerManager:getSingleton():delete()

	Debugging:getSingleton():delete()
	
	self.m_MainConfig:delete()
	sql:delete()
end

function Core:get(group, key)
	if not self.m_MainConfig then outputConsole(debug.traceback()) end
	if group == "client" then
		return self.m_ClientConfig[key]
	else
		return self.m_MainConfig:get(group, key)
	end
end

function Core:set(group, key, value)
	if group == "client" then
		local ev = triggerEvent("onConfigChange", root, self.m_ClientConfig, group, key, self.m_ClientConfig[key], value)
	
		if ev == false then return end
		self.m_ClientConfig[key] = value
	else
		return self.m_MainConfig:set(group, key, value)
	end
end

function Core:getClientConfig()
	return self.m_ClientConfig
end

function Core:onConfigChange(config, group, key, oldvalue, newvalue)
	-- Sync some settings to the client
	if group == "client" then
		for k, v in pairs(getElementsByType("player")) do
			v:rpc(RPC_SERVER_SET_CONFIG, key, newvalue)
		end
	elseif group == "transfermanager" and (
		key == "use_external_webserver" or
		key == "external_webserver_url"
	) then
		triggerEvent("onConfigChange", root, self.m_ClientConfig, "client", key, self.m_ClientConfig[key], newvalue)
		self.m_ClientConfig[key] = newvalue
	elseif group == "weather" then
		self.m_ClientConfig["weather"][key] = self.m_ClientConfig["weather"][key] or {}
		self.m_ClientConfig["weather"][key] = newvalue
	end
end

function Core:getGlobalChat()
	return self.m_GlobalChat
end

function Chat:getAdminChat()
	return self.m_AdminChat
end