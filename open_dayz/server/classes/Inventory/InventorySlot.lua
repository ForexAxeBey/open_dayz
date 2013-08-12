-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Inventory.lua
-- *  PURPOSE:     Inventory class
-- *
-- ****************************************************************************
InventorySlot = inherit(Object)

function InventorySlot:constructor(id_width, width_height, height)
	local mt = getmetatable(self)
	self.__realindex = mt.__index
	mt.__index = InventorySlot.__index
	setmetatable(self, mt)
	
	self.m_Content = {}
	
	if height then
		self.m_Id = id_width or -1
		self.m_Width = width_height
		self.m_Height = height
	elseif width_height then
		self.m_Id = -1
		self.m_Width = id_width
		self.m_Height = width_height
	else
		self.m_Id = id_width or -1
		self.m_Width = -1
		self.m_Height = -1
	end
end

function InventorySlot:save()
	local contentstring = ""
	-- Contentstring has the following format
	--[[
	{$ITEMINFO}{$ITEMINFO}{$ITEMINFO}... (width * height times)
	$ITEMINFO: $id|$stackcount[|]data (seperated by | as key=value pairs)
	]]
	
	contentstring = string.rep("{%s}", self.m_Width * self.m_Height)
	local data = {}
	for x = 1, self.m_Width do
		for y = 1, self.m_Height do
			if self.m_Content[x] and self.m_Content[x][y] then
				data[(x-1)*self.m_Width+y] = self.m_Content[x][y]:serialize()
			else
				data[(x-1)*self.m_Width+y] = ""
			end
		end
	end
	contentstring = contentstring:format(unpack(data))
	
	if self.m_Id == -1 then
		sql:queryExec("INSERT INTO ??_inventory_slot(Width, Height, Content) VALUES (?, ?, ?);", sql:getPrefix(), self.m_Width, self.m_Height, contentstring)
		self.m_Id = sql:lastInsertId()
	else
		sql:queryExec("UPDATE ??_inventory_slot SET `Width` = ?, `Height` = ?, `Content` = ? WHERE Id = ?;", sql:getPrefix(), self.m_Width, self.m_Height, contentstring, self.m_Id)
	end
end

function InventorySlot:load(id)
	self.m_Id = self.m_Id == -1 and id or self.m_Id
	
	sql:queryFetchSingle(Async.waitFor(), "SELECT Width, Height, Content FROM ??_inventory_slot WHERE Id = ?;", sql:getPrefix(), self.m_Id)
	local data = Async.wait()
	
	assert(data)
	self.m_Width = data.Width
	self.m_Height = data.Height
	
	local cont = data.Content:gsub("{}", "{ }"):gsub("}", "")
	local content = split(cont,  string.byte("{"))
	for x = 1, self.m_Width do
		self.m_Content[x] = {}
		for y = 1, self.m_Height do
			if content[(x-1)*self.m_Width+y] ~= " " then
				self.m_Content[x][y] = Item:new();
				self.m_Content[x][y]:unserialize(content[(x-1)*self.m_Width+y])
			end
		end
	end
end

-- use with caution.
function InventorySlot:purge()
	sql:queryExec("DELETE FROM ??_inventory_slot WHERE `Id` = ?;", sql:getPrefix(), self.m_Id)
end



-- This allows the syntax slot[xposition][yposition]
function InventorySlot.__index(self, key)
	if type(key) ~= "number" then
		if self.__realindex then 
			if type(self.__realindex) == "table" then 
				return self.__realindex[key]
			else 
				return self.__realindex(self, key) 
			end
		end
		return
	end
	
	-- attempted to self[number]
	-- check width
	if key > self.m_Width or key < 1 then
		return setmetatable({}, { __index = function() return false end, __newindex = function() error("inventory slot out of range") end})
	end
	
	return setmetatable({ slot = self, x = key }, 
	{
		__index = function(self, key)
			assert(type(key) == "number")
			
			-- attempted InventorySlot[number][number]
			-- check height
			if key > self.slot.m_Height or key < 1 then
				return false
			end
			
			if self.slot.m_Content[self.x] then
				return self.slot.m_Content[self.x][key]
			else
				return nil
			end
		end;
		
		__newindex = function(self, key, value)
			if key > self.slot.m_Height or key < 1 then
				error("inventory slot out of range") 
			end
			self.slot.m_Content[self.x] = self.slot.m_Content[self.x] or {}
			self.slot.m_Content[self.x][key] = value
		end
	})
end