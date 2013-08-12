-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/HUDElement.lua
-- *  PURPOSE:     HUD element super class
-- *
-- ****************************************************************************
HUDElement = inherit(DxElement)

function HUDElement:constructor(posX, posY, width, height, parent)
	DxElement.constructor(self, posX, posY, width, height, parent)
end