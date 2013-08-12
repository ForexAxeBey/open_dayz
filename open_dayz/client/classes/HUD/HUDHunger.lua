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
end

function HUDHunger:drawThis()
	dxDrawImage(self.m_PosX, self.m_PosY, self.m_Width, self.m_Height, "files/images/HUD/Hunger.png", 0, 0, 0, tocolor(255-255*(localPlayer:getHunger()/100), 255*(localPlayer:getHunger()/100), 0))
end
