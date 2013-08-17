-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Inventory.lua
-- *  PURPOSE:     Inventory class
-- *
-- ****************************************************************************
Inventory = inherit(Exported)
--[[

Inventory
- Slot [num]
 - Item [x, y]
  - Data [any]
]]
function Inventory:constructor(id)
	self.m_Slots = {} 
	self.m_Id = id or -1
end

function Inventory:destructor()
	
end

function Inventory:load(id)
	self.m_Id = self.m_Id or id
	assert(self.m_Id)
	
	sql:queryFetchSingle(Async.waitFor(self), "SELECT GENERIC, PRIMARY_WEAPON, SECONDARY_WEAPON, TOOL_HEAD, MAIN, SIDE, TOOLBELT FROM ??_inventory WHERE Id = ?", sql:getPrefix(), self.m_Id)
	local row = Async.wait()
	
	assert(row, "Tried to load an inventory which doesn't exist!")
	
	local slot
	for name, content in pairs(row) do
		slot = _G["ITEM_SLOT_"..name]
		if content ~= -1 then
			self.m_Slots[slot] = InventorySlot:new()
			self.m_Slots[slot]:load(content)
		end
	end
end

function Inventory:save()
	for k, v in pairs(self.m_Slots) do
		v:save()
	end
	
	if self.m_Id == -1 then
		sql:queryExec("INSERT INTO ??_inventory(GENERIC, PRIMARY_WEAPON, SECONDARY_WEAPON, TOOL_HEAD, MAIN, SIDE, TOOLBELT) VALUES (?, ?, ?, ?, ?, ?, ?);", sql:getPrefix(), 
			self.m_Slots[ITEM_SLOT_GENERIC] and self.m_Slots[ITEM_SLOT_GENERIC].m_Id or -1,
			self.m_Slots[ITEM_SLOT_PRIMARY_WEAPON] and self.m_Slots[ITEM_SLOT_PRIMARY_WEAPON].m_Id or -1,
			self.m_Slots[ITEM_SLOT_SECONDARY_WEAPON] and self.m_Slots[ITEM_SLOT_SECONDARY_WEAPON].m_Id or -1,
			self.m_Slots[ITEM_SLOT_TOOL_HEAD] and self.m_Slots[ITEM_SLOT_TOOL_HEAD].m_Id or -1,
			self.m_Slots[ITEM_SLOT_MAIN] and self.m_Slots[ITEM_SLOT_MAIN].m_Id or -1,
			self.m_Slots[ITEM_SLOT_SIDE] and self.m_Slots[ITEM_SLOT_SIDE].m_Id or -1,
			self.m_Slots[ITEM_SLOT_TOOLBELT] and self.m_Slots[ITEM_SLOT_TOOLBELT].m_Id or -1
			)
		self.m_Id = sql:lastInsertId()
	end
	
end

-- totally deletes an inventory, even from the database
function Inventory:purge()
	sql:queryExec("DELETE FROM ??_inventory WHERE `Id` = ?;", sql:getPrefix(), self.m_Id)
	for k, v in pairs(self.m_Slots) do
		v:purge()
	end
end

function Inventory:addSlot(slottype, x, y)
	assert(not self.m_Slots[slottype], "Slot already exists!")
	self.m_Slots[slottype] = InventorySlot:new(x, y)
end

function Inventory:setItem(item, slot, x, y)
	-- slot is either ITEM_SLOT_GENERIC or the item slot for the item
	if slot ~= ITEM_SLOT_GENERIC and slot ~= Items[item].slot then return false end
	if not self.m_Slots[slot] then return false end
	
	-- blocked / out of range slot?
	if self.m_Slots[slot][x][y] then return false end
	if self.m_Slots[slot][x][y] == false then return false end
	
	-- all good!
	self.m_Slots[slot][x][y] = (Items[item].Class or Item):new(item.UID)
	return true
end

function Inventory:getItem(item, slot, x, y)
	-- slot is either ITEM_SLOT_GENERIC or the item slot for the item
	if slot ~= ITEM_SLOT_GENERIC and slot ~= Items[item].slot then return false end
	if not self.m_Slots[slot] then return false end
	
	-- blocked / out of range slot?
	local item = self.m_Slots[slot][x][y]
	if item then return false end
	if item == false then return false end
	
	-- all good!
	return item
end

function Inventory:hasItem(item)
	return false
end
