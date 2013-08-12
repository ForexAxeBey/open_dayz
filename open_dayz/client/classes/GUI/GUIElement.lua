-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/GUIElement.lua
-- *  PURPOSE:     Base class for all GUI elements
-- *
-- ****************************************************************************

GUIElement = inherit(Object)

function GUIElement:constructor(posX, posY, width, height, parent)
	checkArgs("CGUIElement:constructor", "number", "number", "number", "number")
	assert(type(parent) == "table" or parent == nil, "Bad argument #5 @ GUIElement.constructor")

	self.m_pParent = parent or GUIRenderer.dxroot
	
	if self.m_pParent then
		self.m_pParent.m_Children[#self.m_pParent.m_Children+1] = self
	end
	
	self.m_PosX   = posX
	self.m_PosY   = posY
	self.m_Width  = width
	self.m_Height = height
	self.m_Children = {}

	-- Hover / Click Events
	self.m_LActive = false
	self.m_RActive = false
	self.m_Hover  = false
	
	-- Caching in Rendertargets
	self:anyChange()
	self.m_CurrentRenderTarget = false

	-- AbsX and AbsY
	self.m_AbsoluteX, self.m_AbsoluteY = posX, posY
	local lastElement = parent or {}
	while lastElement.m_pParent do
		self.m_AbsoluteX = self.m_AbsoluteX + lastElement.m_PosX
		self.m_AbsoluteY = self.m_AbsoluteY + lastElement.m_PosY
		lastElement = lastElement.m_pParent
	end
end


function GUIElement:destructor()
	if self.m_pParent then
		for k, v in pairs(self.m_pParent.m_Children) do
			if v == self then
				table.remove(self.m_pParent.m_Children, k)
			end
		end
	end
	self = {}
end

function GUIElement:performChecks(mouse1, mouse2, cx, cy)
	local inside = (self.m_AbsoluteX <= cx and self.m_AbsoluteY <= cy and self.m_AbsoluteX + self.m_Width > cx and self.m_AbsoluteY + self.m_Height > cy)
	
	if self.m_LActive and not mouse1 then
		if self.onLeftClickUp			then self:onLeftClickUp()			end
		if self.onInternalLeftClickUp	then self:onInternalLeftClickUp()	end
		self.m_LActive = false
	end
	if self.m_RActive and not mouse2 then
		if self.onRightClickUp			then self:onRightClickUp()			end
		if self.onInternalRightClickUp	then self:onInternalRightClickUp()	end
		self.m_RActive = false
	end
	
	if not inside then
		-- Call on*Events (disabling)
		if self.m_Hover then
			if self.onUnhover		  then self:onUnhover()         end
			if self.onInternalUnhover then self:onInternalUnhover() end
			self.m_Hover = false
		end
		
		return 
	end

	-- Call on*Events (enabling)
	if not self.m_Hover then
		if self.onHover			then self:onHover()			end
		if self.onInternalHover then self:onInternalHover() end
		self.m_Hover = true
		GUIElement.HoveredElement = self
	end
	if mouse1 and not self.m_LActive then
		if self.onLeftClick			then self:onLeftClick()			end
		if self.onInternalLeftClick then self:onInternalLeftClick() end
		self.m_LActive = true

		-- Check whether the focus changed
		GUIInputControl.checkFocus(self)
	end
	if mouse2 and not self.m_RActive then
		if self.onRightClick			then self:onRightClick()			end
		if self.onInternalRightClick	then self:onInternalRightClick()	end
		self.m_RActive = true
	end


	if self.m_LActive and not mouse1 then
		self.m_LActive = false
	end

	if self.m_RActive and not mouse2 then
		self.m_RActive = false
	end
	
	-- Check on children
	for k, v in pairs(self.m_Children) do
		v:performChecks(mouse1, mouse2, cx, cy)
	end
end

function GUIElement:update()
	-- Check for hovers, clicks, ...
	local relCursorX, relCursorY = getCursorPosition()
	if relCursorX then
		local cursorX, cursorY = relCursorX * screenWidth, relCursorY * screenHeight

		self:performChecks(getKeyState("mouse1"), getKeyState("mouse2"), cursorX, cursorY)
	end
end

function GUIElement:draw(incache)
	if not incache and getmetatable(self).__index == GUIElement then
		if self:drawCached() then return end
	end

	if self.m_Visible == false then
		return
	end
	
	--[[if self ~= CGUIRenderer.dxroot then
		debugMsg("COND: "..tostring(getmetatable(self).__index == CGUILabel))
	end]]

	-- Draw Self
	if self.drawThis then self:drawThis(incache) end

	-- Draw Children
	for k, v in ipairs(self.m_Children) do
		if v.draw then v:draw(incache) end
	end
end

function GUIElement:drawCached()
	if self.m_ChangedSinceLastFrame or not self.m_CurrentRenderTarget then
		if not self.m_CurrentRenderTarget then
			self.m_CurrentRenderTarget = dxCreateRenderTarget(self.m_Width, self.m_Height, true)
		end
		
		if not self.m_CurrentRenderTarget then
			-- We cannot cache (probably video memory low )
			-- Just draw normally and retry next frame
			-- Maybe add a timeout
			return false
		end
		
		-- We got a render Target so go on and render to it
		dxSetRenderTarget(self.m_CurrentRenderTarget, true)
		
		-- Per definition we cannot have a drawThis method as only GUIElement instances
		-- may be cached (to avoid caching single texts / images etc.)
		
		-- Draw Children
		for k, v in ipairs(self.m_Children) do
			if v.draw then v:draw(true) end
		end
		
		-- Restore render target
		dxSetRenderTarget(nil)
		self.m_ChangedSinceLastFrame = false
	end
	
	-- Render! :>
	dxSetBlendMode("add")
	dxDrawImage(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Width, self.m_Height, self.m_CurrentRenderTarget)
	dxSetBlendMode("blend")
	
	return true
end

function GUIElement.getHoveredElement()
	return GUIElement.HoveredElement
end

function GUIElement:isCursorWithinBox(x1, y1, x2, y2)
	local relCursorX, relCursorY = getCursorPosition()
	if not relCursorX then
		return false
	end

	local cursorX, cursorY = relCursorX * screenWidth, relCursorY * screenHeight
	if cursorX >= (self.m_AbsoluteX + x1) and cursorY >= (self.m_AbsoluteY + y1) and cursorX < (self.m_AbsoluteX + x2) and cursorY < (self.m_AbsoluteY + y2) then
		return true
	end

	return false
end

GUIElement._change = {}
function GUIElement:anyChange()
	self.m_ChangedSinceLastFrame = true
	-- Go up the tree
	if self.m_pParent then self.m_pParent:anyChange() end
end

function GUIElement:getChildren()
	return self.m_Children
end

function GUIElement:isVisible()
	return self.m_Visible
end

function GUIElement:setVisible(visible)
	self.m_Visible = visible
	self:anyChange()
end

function GUIElement:getPosition()
	return self.m_PosX, self.m_PosY
end

function GUIElement:setPosition(posX, posY)
	self.m_PosX, self.m_PosY = posX, posY

	self.m_AbsoluteX, self.m_AbsoluteY = posX, posY
	local lastElement = parent or {}
	while lastElement.m_pParent do
		self.m_AbsoluteX = self.m_AbsoluteX + lastElement.m_PosX
		self.m_AbsoluteY = self.m_AbsoluteY + lastElement.m_PosY
		lastElement = lastElement.m_pParent
	end

	self:anyChange()
end


function GUIElement._change:m_PosX(newval)
	-- Recalculate AbsX
	self.m_AbsoluteX = self.m_AbsoluteX - self.m_PosX + newval
	self:anyChange()
end

function GUIElement._change:m_PosY(newval)
	-- Recalculate AbsY
	self.m_AbsoluteY = self.m_AbsoluteY - self.m_PosY + newval
	self:anyChange()
end

GUIElement._change.m_Width = GUIElement.anyChange
GUIElement._change.m_Height = GUIElement.anyChange

