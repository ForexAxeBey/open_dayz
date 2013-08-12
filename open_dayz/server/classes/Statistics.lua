-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Statistics.lua
-- *  PURPOSE:     Statistics class
-- *
-- ****************************************************************************
Statistics = inherit(Singleton)

function Statistics:constructor()
	-- Add this server to the server list
	self:addToServerList()
end

function Statistics:sendInfo(action, ...)
	callRemote(core:get("statistics", "masterserver_url"), function() end, action, ...)
end

function Statistics:addToServerList()
	self:sendInfo("serverlist", getServerName(), getServerPort())
end
