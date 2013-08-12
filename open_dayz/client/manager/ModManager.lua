-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/manager/ModManager.lua
-- *  PURPOSE:     Mod manager
-- *
-- ****************************************************************************
ModManager = inherit(Singleton)

function ModManager:loadMod(modfile, modid)
	-- do we have this mod stored on the local disk?
	if not fileExists(modfile) then
		self.m_IDMapping[modfile] = modid
		TransferManager:getSingleton():requestFile(modfile, ModManager.modDownloaded)
		return
	end
	
	-- We have the mod, therefore we can apply it
	self:applyMod(modfile, modid)
end

-- expects a table in the format
-- { [filepath] = id; }
function ModManager:loadMods(modlist)
	local missing = {}
	for path, id in pairs(modlist) do
		if not fileExists(path) then
			missing[path] = id
		else
			self:applyMod(path, id)
		end
	end
	
	if table.size(missing) > 0 then
		local requestlist = {}
		for k, v in pairs(missing) do		
			requestlist[#requestlist+1] = v
			self.m_IDMapping[v] = k
		end
		TransferManager:getSingleton():requestFiles(requestList, ModManager.modDownloaded)
	end
end

function ModManager:applyMod(modfile, modid)
	if not modid then
		modid = self.m_IDMapping[modfile]
		assert(modid)
	end
	
	if modfile:sub(-4) == ".dff" then
		local dff = engineLoadDFF(modfile, modid)
		engineReplaceModel(dff, modid)
	elseif modfile:sub(-4) == ".txd" then
		local txd = engineLoadTXD(modfile, true)
		engineImportTXD(txd, modid)
	elseif modfile:sub(-4) == ".col" then
		local col = engineLoadCOL(modfile)
		engineReplaceCol(col, modid)
	end
end

function ModManager.modDownloaded(modfile)
	ModManager:getSingleton():applyMod(modfile)
end