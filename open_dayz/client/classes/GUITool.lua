-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUITool.lua
-- *  PURPOSE:     A small class which provides you some GUI creation tools
-- *
-- ****************************************************************************
GUITool = inherit(Singleton)

function GUITool:constructor()
	self.m_FuncDraw = function() self:draw() end
	
	addEventHandler("onClientRender", root, self.m_FuncDraw)
end

function GUITool:destructor()
	removeEventHandler("onClientRender", root, self.m_FuncDraw)
end

function GUITool:draw()
	local cursorX, cursorY = getCursorPosition()
	if not cursorX then
		return
	end
	
	cursorX, cursorY = cursorX*screenWidth, cursorY*screenHeight
	dxDrawText(("AbsX: %d AbsY: %d"):format(cursorX, cursorY), screenWidth-250, 3, nil, nil, Color.White, 2)
	if GUIElement.getHoveredElement() then
		local posX, posY = GUIElement.getHoveredElement():getPosition(true)
		dxDrawText(("OffX: %d OffY: %d"):format(cursorX-posX, cursorY-posY), screenWidth-250, 33, nil, nil, Color.White, 2)
	end
end
