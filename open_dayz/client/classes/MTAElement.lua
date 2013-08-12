-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/MTAElement.lua
-- *  PURPOSE:     MTA element class
-- *
-- ****************************************************************************
MTAElement = inherit(Object)
--registerElementClass("element", MTAElement)

function MTAElement:constructor()
	self.m_Data = {}
end

function MTAElement:derived_constructor()
	MTAElement.constructor(self)
end

-- Use getData & setData mainly from addons
function MTAElement:getData(key)
	checkArgs("MTAElement:getData", "string")
	
	return self.m_Data[key]
end

function MTAElement:setData(key, value)
	checkArgs("MTAElement:setData", "string")

	self.m_Data[key] = value
end
