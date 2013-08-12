-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Version.lua
-- *  PURPOSE:     Version information class
-- *
-- ****************************************************************************
Version = inherit(Singleton)

function Version:constructor()
	self.m_VersionString = VERSION_LABEL

	self.m_VersionLabel = guiCreateLabel(screenWidth - 255, screenHeight - 30, 250, 18, self.m_VersionString, false)
	guiSetAlpha(self.m_VersionLabel, 0.8)
	guiLabelSetHorizontalAlign(self.m_VersionLabel, "right")
end

function Version:getVersion()
	return self.m_VersionString
end

function Version:setVersion(versionString)
	checkArgs("Version:setVersion", "string")
	
	self.m_VersionString = versionString
	guiSetText(self.m_VersionLabel, self.m_VersionString)
end
