-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/FormTest.lua
-- *  PURPOSE:     Test form
-- *
-- ****************************************************************************
FormTest = inherit(GUIForm)

function FormTest:constructor()
	GUIForm.constructor(self, 500, 10, 700, 500)
	
	self.m_Window = GUIWindow:new(0, 0, self.m_Width, self.m_Height, "My awesome testform", true, true, self)
	self.m_Label = GUILabel:new(200, 100, self.m_Width, self.m_Height, "Test", 1.5, self.m_Window)
	self.m_Label:setColor(Color.Black)
	
	self.m_Grid = GUIGridList:new(10, 50, 400, 200, self.m_Window)
	self.m_Grid:addColumn("Column 1", 0.3)
	self.m_Grid:addColumn("Column 2", 0.3)
	self.m_Grid:addColumn("Column 3", 0.3)
	self.m_Grid:addItem("Value 1", "Value 2", "Value 3")
	
	--[[local mouseMenu = GUIMouseMenu:new(200, 150, 300, 300, self)
	mouseMenu:addItem("Hi", function() end)
	mouseMenu:addItem("Hello", function() outputChatBox("Hello world!") end)
	mouseMenu:addItem("fsaf", function() end)--]]
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		--FormTest:new()
	end
)
