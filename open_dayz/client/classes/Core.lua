-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Core.lua
-- *  PURPOSE:     Core class
-- *
-- ****************************************************************************
Core = inherit(Object)

function Core:constructor()
	-- Small hack to get the global core immediately
	core = self

	-- Initialize debug system
	Debugging:new()
	Version:new()
	
	-- Initialize Server
	server = Server:new()
	
	-- Initialize GUI system
	GUIRenderer.constructor()
	GUICursor:new()
	ClickHandler:new()
	
	-- Initialize HUD system
	HUDArea:new()
	
	FirstPersonMode:new()

	-- Initialize RPC system
	RPCHandler:new()
	PlayerRPC:new()
	ServerRPC:new()
	NpcRPC:new()
	VehicleRPC:new()
	
	-- Initialize managers
	PlayerManager:new()
	TranslationManager:new()
	TransferManager:new()
	NPCManager:new()
	ShaderManager:new()
	ModManager:new()
	Weather:new()
end

function Core:destructor()
	delete(GUICursor:getSingleton())
	
	-- Delete managers
	delete(PlayerManager)
	delete(TranslationManager)
	delete(TransferManager)
	delete(NPCManager)
	delete(ShaderManager)
	delete(ModManager)
end

function Core:onConfigRetrieve()
	Weather:getSingleton():rebuild()
end

function Core:set(group, key, value)

end

function Core:get(group, key)

end