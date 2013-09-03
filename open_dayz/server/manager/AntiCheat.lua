-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/manager/AntiCheat.lua
-- *  PURPOSE:     Anti Cheat
-- *
-- ****************************************************************************
AntiCheat = inherit(Singleton)

-- Possible cheats
enum("CHEAT_FUEL_DESYNC", "anticheat")
enum("CHEAT_D3D9_DLL", "anticheat")
enum("CHEAT_TEXTURE_MOD", "anticheat")
enum("CHEAT_WEAPON_MOD", "anticheat")
enum("CHEAT_VEHICLE_MOD", "anticheat")
enum("CHEAT_SKIN_MOD", "anticheat")
enum("CHEAT_OBJECT_MOD", "anticheat")

function AntiCheat:constructor()
	addEventHandler("onPlayerModInfo", root, bind(AntiCheat.onPlayerModInfo, self))
	self.m_WatchedPlayers = {}
	self.m_Log = Log:new("logs/anticheat.log")
end

function AntiCheat:destructor()
	delete(self.m_Log)
end

function AntiCheat:removeCheater(player, violation)
	local reason = ""
	local logmsg = ""
	if violation == CHEAT_D3D9_DLL then
		reason = _("You violated the anti cheating rules of this server (Modified d3d9.dll)", player)
		logmsg = "custom d3d9.dll"
	elseif violation == CHEAT_TEXTURE_MOD then
		reason = _("You violated the anti cheating rules of this server (Texture Mod)", player)
		logmsg = "texture mod"
	elseif violation == CHEAT_WEAPON_MOD then
		reason = _("You violated the anti cheating rules of this server (Weapon Mod)", player)
		logmsg = "weapon mod"
	elseif violation == CHEAT_VEHICLE_MOD then
		reason = _("You violated the anti cheating rules of this server (Vehicle Mod)", player)
		logmsg = "vehicle mod"
	elseif violation == CHEAT_SKIN_MOD then
		reason = _("You violated the anti cheating rules of this server (Skin Mod)", player)
		logmsg = "skin mod"
	elseif violation == CHEAT_OBJECT_MOD then
		reason = _("You violated the anti cheating rules of this server (Object Mod)", player)
		logmsg = "object mod"
	elseif violation == CHEAT_FUEL_DESYNC then
		reason = _("Vehicle fuel desync", player)
		logmsg = "fuel desync"
	end
	
	self.m_Log:log("%s (Serial: %s) has been kicked for an anticheat violation (%s)", getPlayerName(player), getPlayerSerial(player), logmsg)
	kickPlayer(player, "Anticheat", reason)
end

function AntiCheat:reportViolation(player, violation)
	if violation == CHEAT_D3D9_DLL and not core:get("anticheat", "allow_d3d9") then
		return self:removeCheater(player, violation)
	elseif violation == CHEAT_TEXTURE_MOD and not core:get("anticheat", "allow_texture") then
		return self:removeCheater(player, violation)
	elseif violation == CHEAT_WEAPON_MOD and not core:get("anticheat", "allow_weapon_model") then
		return self:removeCheater(player, violation)
	elseif violation == CHEAT_VEHICLE_MOD and not core:get("anticheat", "allow_vehicle_model") then
		return self:removeCheater(player, violation)
	elseif violation == CHEAT_SKIN_MOD and not core:get("anticheat", "allow_skin_model") then
		return self:removeCheater(player, violation)
	elseif violation == CHEAT_OBJECT_MOD and not core:get("anticheat", "allow_object_model") then
		return self:removeCheater(player, violation)
	elseif violation == CHEAT_FUEL_DESYNC then
		-- do this
	end
	
	error ("Invalid Anticheat violation")
end

function AntiCheat:onPlayerModInfo(filename, itemlist)
	
end