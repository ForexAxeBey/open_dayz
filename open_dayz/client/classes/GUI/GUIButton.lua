-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/GUIButton.lua
-- *  PURPOSE:     GUI button class
-- *
-- ****************************************************************************

GUIButton = inherit(GUIElement)
inherit(GUIFontContainer, GUIButton)
inherit(GUIColorable, GUIButton)

local GUI_BUTTON_BORDER_MARGIN = 5

function GUIButton:constructor(posX, posY, width, height, text, parent)
	checkArgs("CGUIButton:constructor", "number", "number", "number", "number", "string")
	
	GUIElement.constructor(self, posX, posY, width, height, parent)
	GUIFontContainer.constructor(self, text, 1.5)
	GUIColorable.constructor(self)

	self.m_Path = "files/images/GUI/Button.png"
end

function GUIButton:drawThis()
	dxSetBlendMode("modulate_add")

	dxDrawImage(math.floor(self.m_AbsoluteX), math.floor(self.m_AbsoluteY), math.floor(self.m_Width), math.floor(self.m_Height), self.m_Path)
	dxDrawText(self:getText(), self.m_AbsoluteX + GUI_BUTTON_BORDER_MARGIN, self.m_AbsoluteY + GUI_BUTTON_BORDER_MARGIN,
		self.m_AbsoluteX + self.m_Width - GUI_BUTTON_BORDER_MARGIN, self.m_AbsoluteY + self.m_Height - GUI_BUTTON_BORDER_MARGIN, self:getColor(), self:getFontSize(), "default", "center", "center", false, true)

	dxSetBlendMode("blend")
end

function GUIButton:onInternalHover()
	self.m_Path = "files/images/GUI/Button_hover.png"
	self:anyChange()
end

function GUIButton:onInternalUnhover()
	self.m_Path = "files/images/GUI/Button.png"
	self:anyChange()
end
