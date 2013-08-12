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
