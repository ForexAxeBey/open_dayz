-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/DxElement.lua
-- *  PURPOSE:     Dx element super class
-- *
-- ****************************************************************************
DxElement = inherit(Object)

function DxElement:constructor(posX, posY, width, height, parent)
	self.m_pParent = parent or GUIRenderer.dxroot_t
	
	if self.m_pParent then
		self.m_pParent.m_Children[#self.m_pParent.m_Children+1] = self
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
	while lastElement.m_pParent do
		self.m_AbsoluteX = self.m_AbsoluteX + lastElement.m_PosX
		self.m_AbsoluteY = self.m_AbsoluteY + lastElement.m_PosY
		lastElement = lastElement.m_pParent
	end
end

function DxElement:destructor()
	if self.m_pParent then
		for k, v in pairs(self.m_pParent.m_Children) do
			if v == self then
				table.remove(self.m_pParent.m_Children, k)
			end
		end
	end
end

function DxElement:anyChange()
	local cacheElement = self.m_pParent
	while cacheElement do
		-- Redraw everything in this area
		if cacheElement.updateArea then
			return cacheElement:updateArea()
		end
		cacheElement = cacheElement.m_pParent
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
	while lastElement.m_pParent do
		self.m_AbsoluteX = self.m_AbsoluteX + lastElement.m_PosX
		self.m_AbsoluteY = self.m_AbsoluteY + lastElement.m_PosY
		lastElement = lastElement.m_pParent
	end

	self:anyChange()
end
