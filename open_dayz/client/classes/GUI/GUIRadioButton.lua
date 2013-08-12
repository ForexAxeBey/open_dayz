-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/GUIRadioButton.lua
-- *  PURPOSE:     GUI radio button class
-- *
-- ****************************************************************************
GUIRadioButton = inherit(GUIElement)
inherit(GUIColorable, GUIRadioButton)
inherit(GUIFontContainer, GUIRadioButton)

local GUI_RADIO_TEXT_MARGIN = 5

--- Initialize the GUI radio button
-- @param self object instance
-- @param posX The x-position
-- @param posY The y-position
-- @param width Width of this element (text included)
-- @param height The height of this element (determines the size of the box)
-- @param text The caption
-- @param parent The parent
function GUIRadioButton:constructor(posX, posY, width, height, text, parent)
	checkArgs("GUIRadioButton.constructor", "number", "number", "number", "number")
	if not instanceof(parent, GUIRadioButtonGroup) then
		error("GUIRadioButton's parent should be a GUIRadioButtonGroup")
	end

	GUIElement.constructor(self, posX, posY, width, height, parent)
	GUIFontContainer.constructor(self, text, 1.5)
	GUIColorable.constructor(self)
	
	self.m_Checked = false

	-- Mark first item in radio button group as checked
	if self.m_pParent and not self.m_pParent.m_pCheckedRadio then
		self:setChecked(true)
	end
end

function GUIRadioButton:onInternalLeftClick()
	if self.m_pParent then -- Should always exist
		self:setChecked(not self:isChecked())
	end
end

--- Mark the radio button as checked
-- @param bChecked Checked state
function GUIRadioButton:setChecked(bChecked)
	if bChecked then
		self.m_pParent:setCheckedRadioButton(self)
	end

	self.m_Checked = bChecked
	self:anyChange()
end

--- Get the checked status
-- @return boolean whether the radio button is checked or not
function GUIRadioButton:isChecked()
	return self.m_Checked
end

function GUIRadioButton:drawThis()
	dxSetBlendMode("modulate_add")
	dxDrawImage(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Height, self.m_Height, "files/images/GUI/radiobutton.png")
	dxDrawText(self:getText(), self.m_AbsoluteX + self.m_Height + GUI_RADIO_TEXT_MARGIN, self.m_AbsoluteY, self.m_AbsoluteX + self.m_Width - GUI_RADIO_TEXT_MARGIN, self.m_AbsoluteY + self.m_Height, self:getColor(), self:getFontSize(), self:getFont(), "left", "center", false, true)

	if self.m_Checked then
		dxDrawImage(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Height, self.m_Height, "files/images/GUI/radiobutton_check.png")
	end
	dxSetBlendMode("blend")
end
