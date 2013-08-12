-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Inventory.lua
-- *  PURPOSE:     Inventory class
-- *
-- ****************************************************************************
Item = inherit(Object)

function Item:constructor()
	self.m_ItemId = ITEM_NONE
	self.m_Data = {}
	self.m_StackCount = 0
end

function Item:serialize()
	return ("%s|%s"):format(tostring(self.m_ItemId), tostring(self.m_StackCount))
end

function Item:unserialize(info)
	local infot = split(info, "|")
	self.m_ItemId = tonumber(infot[1])
	self.m_StackCount = tonumber(infot[2])
end

function Item:destructor()
	
end

function Item:getId()
	return self.m_ItemId
end

function Item:set(id)
	self.m_ItemId = id
	self.m_StackCount = 0
	self.m_Data = {}
end

function Item:isStackable()
	return Items[self.m_ItemId].stackable
end

function Item:addStackCount(c)
	self.m_StackCount = self.m_StackCount + c
end

function Item:getStackCount()
	return self.m_StackCount
end

function Item:reduceStackCount(c)
	self.m_StackCount = self.m_StackCount - c 
end

function Item:setData(key, value)
	self.m_Data[key] = value
end

function Item:getData(key)
	return self.m_Data[key]
end

