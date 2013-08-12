-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/classes/Exported.lua
-- *  PURPOSE:     Classes that inherit from this one are able be accessed from an addon
-- *
-- ****************************************************************************
Exported = inherit(Object)
local exportedTypes = {}

function Exported:new(...)
	local object = new(self, ...)
	self.ms_Instances = self.ms_Instances or {}
	object.m_Id = object.m_Id or #self.ms_Instances + 1
	self.ms_Instances[object.m_Id] = object
	
	return object
end

function Exported:getObjectById(objectId)
	return self.ms_Instances[objectId]
end

function Exported:onInherit()
	local typeId = #exportedTypes + 1
	self.m_TypeId = typeId
	exportedTypes[typeId] = self
end

function Exported.getClassTypeById(id)
	return exportedTypes[id]
end

function Exported:getTypeId()
	return self.m_TypeId
end

function Exported.getClassList()
	local result = {}
	for typeId, classt in pairs(exportedTypes) do
		result[typeId] = table.find(_G, classt) -- That's a bit too hacky
	end
	return result
end
