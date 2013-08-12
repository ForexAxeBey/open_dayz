-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ - Addons
-- *  FILE:        include.lua
-- *  PURPOSE:     Include script that contains the Open MTA:DayZ API
-- *
-- ****************************************************************************

local Addon = {}
local RESOURCE_NAME = "open_dayz"
local classTypes = {}
local SERVER = triggerServerEvent == nil

function Addon.constructor()
	-- Get basic gamemode information (e.g. a list of classes, version)
	local gamemodeInfo = exports[RESOURCE_NAME]:getGamemodeInfo()

	-- Register classes
	for classId, className in pairs(gamemodeInfo.classes) do
		Addon.registerClass(classId, className)
	end
	
	-- Load/copy enums
	for enumName, enumInfo in pairs(gamemodeInfo.enums) do
		for enumValue, enumFieldName in ipairs(enumInfo) do -- Important: Use ipairs here, because pairs would include the field 'maxNum'
			_G[enumFieldName] = enumValue
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, Addon.constructor, true, "high+9999999")

function Addon.registerClass(id, name)
	classTypes[id] = name
	
	_G[name] = setmetatable({},
		{
			__index = function(self, key)
				return function(obj, ...)
					return Addon.receiveExportArguments(exports[RESOURCE_NAME]:callMethod({"api", false, id}, key, ...))
				end
			end;
		}
	)
end

function Addon.receiveExportArguments(args)
	for k, v in ipairs(args) do
		if type(v) == "table" and v[1] == "api" then
			args[k] = v
			setmetatable(args[k], {__index = function(self, key)
				return function(obj, ...) return Addon.receiveExportArguments(exports[RESOURCE_NAME]:callMethod(self, key, ...)) end
			end})
		end
	end
	
	return unpack(args)
end

function Addon.getAPIClass(apiId)
	return _G[classTypes[apiId]]
end

debug.setmetatable(root,
	{
		__index = function(self, key)
			return function(element, ...)
				return Addon.receiveExportArguments(exports[RESOURCE_NAME]:callElementMethod(self, key, ...))
			end
		end;
	}
)

--------------------------
-- Utils

-- Translation
if SERVER then
	function _(message, player)
		return TranslationManager:getSingleton():translate(message, player:getLocale())
	end
else
	function _(message)
		return TranslationManager:getSingleton():translate(message, localPlayer:getLocale())
	end
end
