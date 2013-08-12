-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/MouseMenu/PlayerMouseMenu.lua
-- *  PURPOSE:     Player mouse menu class
-- *
-- ****************************************************************************
PlayerMouseMenu = inherit(GUIMouseMenu)

function PlayerMouseMenu:constructor(posX, posY)
	GUIMouseMenu.constructor(self, posX, posY, 300, 1)
	
	self:addItem("Show items", function() localPlayer:sendMessage("I'm sorry, I don't have any item!", 255, 0, 0) end)
	self:addItem("Say something", function() localPlayer:sendMessage("hm, dunno what to say", 255, 255, 0) end)
	self:addItem("Buy", function() localPlayer:sendMessage("Wat, you think you are allowed to buy me? No, bro!", 255, 0, 0) end)
	self:addItem("Kick", function() localPlayer:sendMessage("I'm not a bad boy", 255, 255, 0) end)
end
