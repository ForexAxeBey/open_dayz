-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/HUDHunger.lua
-- *  PURPOSE:     Hunger HUD element class
-- *
-- ****************************************************************************
HUDHunger = inherit(HUDElement)

function HUDHunger:constructor(posX, posY, width, height, parent)
	HUDElement.constructor(self, posX, posY, width, height, parent)
	TransferManager:getSingleton():requestFilesAsOnce(
	{	"files/images/HUD/Hunger.png";
	}
	, bind(HUDHunger.load, self))
	
	self.m_Active = false
end

function HUDHunger:drawThis()
	if self.m_Active then
		dxDrawImage(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Width, self.m_Height, "files/images/HUD/Hunger.png", 0, 0, 0, tocolor(255-255*(localPlayer:getHunger()/100), 255*(localPlayer:getHunger()/100), 0))
	end
end

function HUDHunger:load()
	self.m_Active = true
end

