-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/classes/CachedFile.lua
-- *  PURPOSE:     Intelligent File Caching, only applies to getContent()
-- *
-- ****************************************************************************
CachedFile = inherit(File)
CachedFile.Instances = {}

function CachedFile.Open(filepath)
	local fh = fileOpen(filepath)
	if not fh then return false end
	return CachedFile:new(fh)
end

function CachedFile.Create(filepath)
	local fh = fileCreate(filepath)
	if not fh then return false end
	return CachedFile:new(fh)
end

function CachedFile.Update()
	local t = getTickCount() - Core:get("filecache", "timeout")
	for k, v in pairs(CachedFile.Instances) do
		if v.m_LastAccess < t then
			v:clearCache()
		end
	end
end

function CachedFile:constructor(fh)
	CachedFile.Instances[self] = self
	self.m_Handle = fh
	self.m_Cache = false
end

function CachedFile:destructor(fh)
	fileClose(self.m_Handle)
	self.m_Handle = nil
	self.m_Cache = nil
	CachedFile.Instances[self] = nil
end

function CachedFile:getContent()
	if not self.m_Cache then
		fileSetPos(self.m_Handle, 0)
		self.m_Cache = self:read(self:getSize())
		self.m_LastAccess = getTickCount()
	end
	return self.m_Cache
end

function CachedFile:clearCache()
	self.m_Cache = false
end
