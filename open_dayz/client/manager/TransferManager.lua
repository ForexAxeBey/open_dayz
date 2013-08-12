-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/manager/TransferManager.lua
-- *  PURPOSE:     Manager to receive stuff on the client
-- *
-- ****************************************************************************
TransferManager = inherit(Singleton)

function TransferManager:constructor()
	self.m_Callbacks = {}
	self.m_CallbackList = {}
	
	localPlayer:rpc(RPC_TRANSFER_REQUEST_FILELIST)
	
	addEvent("transferManager", true)
	addEventHandler("transferManager", resourceRoot, bind(TransferManager.receiveFiles, self))
end

function TransferManager:receiveOnConnectList(list)
	self:requestMissingFiles(list)
end

function TransferManager:requestMissingFiles(filemd5map)
	local request = {}
	for file, md5 in pairs(filemd5map) do
		local fh = File.Open(file)
		if fh then
			if fh:md5() ~= md5 then request[#request+1] = file end
			fh:close()
		else
			request[#request+1] = file 
		end
	end
	self:requestFiles(request)
end

function TransferManager:receiveFile(filename, filedata)
	if fileExists(filename) then fileDelete(filename) end
	local fh = fileCreate(filename)
	fileWrite(fh, filedata)
	fileClose(fh)
	
	if self.m_Callbacks[filename] then self.m_Callbacks[filename](filename) end
end

function TransferManager:receiveFiles(files)
	for k, v in pairs(files) do
		self:receiveFile(k, v)
	end
end

function TransferManager:requestFiles(list, callback)
	for k, v in pairs(list) do
		self.m_Callbacks[v] = callback
	end
	
	if server:get("use_external_webserver") then
		for k, v in pairs(list) do
			fetchRemote(server:get("external_webserver_url")..v, 
				function(data, errno, filename)
					if errno == 0 then
						TransferManager:getSingleton():receiveFile(filename, data)
					else
						error("TransferManager.requestFiles - fetchRemote returned error "..tostring(errno))
					end
				end,
				"", false, k)
		end
	else
		-- use latent events
		localPlayer:rpc(RPC_TRANSFER_REQUEST_FILES, list)
	end
end

function TransferManager:requestFilesAsOnce(list, callback)
	self.m_CallbackList[list] = callback
	for k, v in pairs(list) do
		self.m_Callbacks[v] = TransferManager.listCallback
	end
	
	if server:get("use_external_webserver") then
		for k, v in pairs(list) do
			fetchRemote(server:get("external_webserver_url")..v, 
				function(data, errno, filename)
					if errno == 0 then
						TransferManager:getSingleton():receiveFile(filename, data)
					else
						error("TransferManager.requestFiles - fetchRemote returned error "..tostring(errno))
					end
				end,
				"", false, k)
		end
	else
		-- use latent events
		localPlayer:rpc(RPC_TRANSFER_REQUEST_FILES, list)
	end
end

function TransferManager:requestFile(name, callback)
	self:requestFiles({name}, callback)
end

function TransferManager.listCallback(filename)
	self = TransferManager:getSingleton()
	local found
	for k, v in pairs(self.m_CallbackList) do
		for i, name in pairs(k) do
			if filename == name then
				found = {k, i, v}
				break
			end
		end
	end
	if not found then return end
	
	local k, i, v = unpack(found)
	table.remove(k, i)
	if #k <= 0 then
		v()
	end
	self.m_CallbackList[k] = nil
end