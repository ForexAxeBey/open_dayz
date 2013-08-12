-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/classes/Singleton.lua
-- *  PURPOSE:     Singleton class
-- *
-- ****************************************************************************
Singleton = {}

function Singleton:getSingleton()
	if not self.ms_Instance then
		self.ms_Instance = self:new()
	end
	return self.ms_Instance
end

function Singleton:new(...)
	self.new = function() error("You cannot instantiate singleton classes twice!") end
	local inst = new(self, ...)
	self.ms_Instance = inst
	return inst
end
