-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/manager/TransferManager.lua
-- *  PURPOSE:     Class to transfer stuff to the client
-- *
-- ****************************************************************************
TransferManager = inherit(Singleton)

function TransferManager:constructor()
	-- Create an index of downloadable files
	-- DownloadableFiles[filepath] = onDemand (bool)
	self.m_DownloadableFiles = { }
	local xmlroot = xmlLoadFile("meta.xml")
	
	for k, v in pairs(xmlNodeGetChildren(xmlroot)) do
		if xmlNodeGetName(v) == "transferfile" then
			self.m_DownloadableFiles[xmlNodeGetAttribute(v, "src")] = { onDemand = xmlNodeGetAttribute(v, "onDemand") == "true"; file = CachedFile.Open(xmlNodeGetAttribute(v, "src")) }
		end
	end
	xmlUnloadFile(xmlroot)
	
	-- Build the to-be-downloaded-on-connect list
	self.m_OnConnectList = {}
	for k, v in pairs(self.m_DownloadableFiles) do
		if v.onDemand == false then 
			self.m_OnConnectList[k] = v.file:md5()
		end
	end
end

function TransferManager:getOnConnectList()
	return self.m_OnConnectList
end

function TransferManager:getFile(player, filelist)
	if core:get("transfermanager", "use_external_webserver") then return end
	
	-- Validate the input
	for k, file in pairs(filelist) do
		if self.m_DownloadableFiles[file] == nil then
			return 
		end
	end
	
	local data = {}
	for k, file in pairs(filelist) do
		data[file] = self.m_DownloadableFiles[file].file:getContent()
	end
	
	triggerLatentClientEvent(player, "transferManager", core:get("transfermanager", "player_max_transferspeed"), false, resourceRoot, data)
end
