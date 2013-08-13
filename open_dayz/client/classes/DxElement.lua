-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/DxElement.lua
-- *  PURPOSE:     Dx element super class
-- *
-- ****************************************************************************
DxElement = inherit(Object)

function DxElement:constructor(posX, posY, width, height, parent)
	self.m_Parent = parent
	if not parent and not instanceof(self, CacheArea) then
		self.m_Parent = GUIRenderer.cacheroot
	end
	
	if self.m_Parent then
		self.m_Parent.m_Children[#self.m_Parent.m_Children+1] = self
	end
	
	self.m_PosX   = posX
	self.m_PosY   = posY
	self.m_Width  = width
	self.m_Height = height
	self.m_Children = {}
	self.m_Visible = true
	
	-- Caching in Rendertargets
	self:anyChange()
	self.m_CurrentRenderTarget = false
	
	-- AbsX and AbsY
	self.m_AbsoluteX, self.m_AbsoluteY = posX, posY
	local lastElement = parent or {}
	while lastElement.m_Parent do
		self.m_AbsoluteX = self.m_AbsoluteX + lastElement.m_PosX
		self.m_AbsoluteY = self.m_AbsoluteY + lastElement.m_PosY
		lastElement = lastElement.m_Parent
	end
end

function DxElement:destructor()
	if self.m_Parent then
		for k, v in pairs(self.m_Parent.m_Children) do
			if v == self then
				table.remove(self.m_Parent.m_Children, k)
			end
		end
	end
end

function DxElement:anyChange()
	local cacheElement = self.m_Parent
	while cacheElement do
		-- Redraw everything in this area
		if cacheElement.updateArea then
			return cacheElement:updateArea()
		end
		cacheElement = cacheElement.m_Parent
	end
	return false
end

function DxElement:draw(incache)
	if self.m_Visible then
		-- Draw me
		if self.drawThis then
			self:drawThis(incache)
		end
		
		-- Draw children
		for k, v in ipairs(self.m_Children) do
			if v.m_Visible and v.draw then
				v:draw(incache)
			end
		end
	end
end

function DxElement:isVisible()
	return self.m_Visible
end

function DxElement:setVisible(visible)
	self.m_Visible = visible
	self:anyChange()
end

function DxElement:getChildren()
	return self.m_Children
end

function DxElement:getPosition()
	return self.m_PosX, self.m_PosY
end

function DxElement:setPosition(posX, posY)
	self.m_PosX, self.m_PosY = posX, posY

	self.m_AbsoluteX, self.m_AbsoluteY = posX, posY
	local lastElement = parent or {}
	while lastElement.m_Parent do
		self.m_AbsoluteX = self.m_AbsoluteX + lastElement.m_PosX
		self.m_AbsoluteY = self.m_AbsoluteY + lastElement.m_PosY
		lastElement = lastElement.m_Parent
	end

	self:anyChange()
end

function DxElement:isCursorWithinBox(x1, y1, x2, y2)
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