-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/FormTest.lua
-- *  PURPOSE:     Test form
-- *
-- ****************************************************************************
FormTest = inherit(GUIForm)

function FormTest:constructor()
	GUIForm.constructor(self, 100, 100, 512, 300)
	
	--self.m_pWindow = CGUIWindow(0, 0, self.m_Width, self.m_Height, "My awesome testform", true, true, self)
	--self.m_pMemo = CGUIMemo(0, 0, 400, 200, "Test", self)
	
	--[[local mouseMenu = GUIMouseMenu:new(200, 150, 300, 300, self)
	mouseMenu:addItem("Hi", function() end)
	mouseMenu:addItem("Hello", function() outputChatBox("Hello world!") end)
	mouseMenu:addItem("fsaf", function() end)--]]
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()

		FormTest:new()

	end
)
