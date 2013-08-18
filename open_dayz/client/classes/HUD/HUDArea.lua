-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/HUDArea.lua
-- *  PURPOSE:     HUD (cached) area element class
-- *
-- ****************************************************************************
HUDArea = inherit(CacheArea)
inherit(Singleton, HUDArea)

function HUDArea:constructor()
	CacheArea.constructor(self, screenWidth - 120, screenHeight/2 - 350/2, 100, 500)

	self.m_Hunger = HUDHunger:new(0, 0, 100, 100, self)
	self.m_Thirst = HUDThirst:new(0, 150, 100, 100, self)
	self:hide()
end

function HUDArea:show()
	self:setVisible(true)
end

function HUDArea:hide()
	self:setVisible(false)
end