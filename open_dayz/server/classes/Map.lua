-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Map.lua
-- *  PURPOSE:     Map class
-- *
-- ****************************************************************************
Map = inherit(Singleton)

function Map:constructor()
	self.m_Maps = {}
	self.m_Spawnpoints = {}
	self.m_SpawnAreas = {}
	self.m_NoZombieAreas = {}

	local info
	for k, res in pairs(getResources()) do
		if getResourceState(res) == "running" then
			info = getResourceInfo(res, "gamemode") 
			if info == "open_dayz" then 
				self:startMap(res)
			end
		end
	end
	self:startMap(getThisResource())
	
	self:rebuildLists()
end

function Map:destructor()
end

function Map:rebuildLists()
	self.m_Spawnpoints = {}
	self.m_SpawnAreas = {}
	self.m_NoZombieAreas = {}	

	for k, v in pairs(self.m_Maps) do
		self.m_Spawnpoints = table.append(self.m_Spawnpoints, v.spawnpoint) 
		self.m_SpawnAreas = table.append(self.m_SpawnAreas, v.spawnarea) 
		self.m_NoZombieAreas = table.append(self.m_NoZombieAreas, v.nozombiearea) 
	end
	
	-- Rebuild Spawnareas into spawnpoints
	for k, v in pairs(self.m_SpawnAreas) do
		local x, y, z = getElementPosition(v)
		local w, h 	  = getElementData(v, "width"), getElementData(v, "height")
		
		for px = x, x+w, math.ceil(w/5) do
			for py = y, y+h, math.ceil(h/5) do
				local id = #self.m_Spawnpoints+1
				self.m_Spawnpoints[id] = createElement("spawnpoint")
				setElementPosition(self.m_Spawnpoints[id], px, py, pz)
			end
		end
	end
end

function Map:startMap(resource)
	local maproot = getResourceRootElement(resource)
	self.m_Maps[resource] = { 
		spawnpoint 	= getElementsByType("spawnpoint", maproot);
		spawnarea 	= getElementsByType("spawnarea", maproot);
		nozombiearea= getElementsByType("nozombiearea", maproot);
	}
end

function Map:getSpawnpoint()
	return getElementPosition(self.m_Spawnpoints[math.random(1, #self.m_Spawnpoints)])
end