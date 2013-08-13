-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/MouseMenu/VehicleMouseMenu.lua
-- *  PURPOSE:     Vehicle mouse menu class
-- *
-- ****************************************************************************
VehicleMouseMenu = inherit(GUIMouseMenu)

function VehicleMouseMenu:constructor(posX, posY)
	GUIMouseMenu.constructor(self, posX, posY, 300, 1) -- height doesn't matter as it will be set automatically
	
	self:addItem("Open trunk", function() localPlayer:sendMessage("I'm sorry, I don't have any item!", 255, 0, 0) end)
	self:addItem("Say something", function() localPlayer:sendMessage("hm, dunno what to say", 255, 255, 0) end)
	self:addItem("Buy", function() localPlayer:sendMessage("Wat, you think you are allowed to buy me? No, bro!", 255, 0, 0) end)
	self:addItem("Sell", function() localPlayer:sendMessage("Bla", 255, 255, 0) end)
end
