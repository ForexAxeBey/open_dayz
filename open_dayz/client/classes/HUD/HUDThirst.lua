-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/HUDThirst.lua
-- *  PURPOSE:     Hunger HUD element class
-- *
-- ****************************************************************************
HUDThirst = inherit(HUDThirst)

function HUDThirst:constructor(posX, posY, width, height, parent)
	HUDElement.constructor(self, posX, posY, width, height, parent)
	TransferManager:getSingleton():requestFilesAsOnce(
	{	"files/images/HUD/Thirst.png";
	}
	, bind(HUDThirst.load, self))
	
	self.m_Active = false
end

function HUDThirst:drawThis()
	if self.m_Active then
		dxDrawImage(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Width, self.m_Height, "files/images/HUD/Thirst.png", 0, 0, 0, tocolor(255-255*(localPlayer:getThirst()/100), 255*(localPlayer:getThirst()/100), 0))
	end
end

function HUDThirst:load()
	self.m_Active = true
end