-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/HUDThirst.lua
-- *  PURPOSE:     Hunger HUD element class
-- *
-- ****************************************************************************
HUDThirst = inherit(HUDElement)

function HUDThirst:constructor(posX, posY, width, height, parent)
	HUDElement.constructor(self, posX, posY, width, height, parent)
end

function HUDThirst:drawThis()
	dxDrawImage(self.m_PosX, self.m_PosY, self.m_Width, self.m_Height, "files/images/HUD/Thirst.png", 0, 0, 0, tocolor(255-255*(localPlayer:getThirst()/100), 255*(localPlayer:getThirst()/100), 0))
end
