-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/GUIScrollable.lua
-- *  PURPOSE:     GUI scrollable super class
-- *
-- ****************************************************************************
GUIScrollableArea = inherit(GUIElement)

function GUIScrollableArea:constructor(documentWidth, documentHeight)
	self.m_pPageTarget = dxCreateRenderTarget(documentWidth, documentHeight, true)

	self.m_ScrollX = 0
	self.m_ScrollY = 0
end

function GUIScrollableArea:drawThis()
	-- Draw page = draw render target
	dxDrawImage(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Width, self.m_Height, self.m_pPageTarget)
end

function GUIScrollableArea:draw(incache)
	if self.m_Visible == false then
		return
	end
	
	if self.m_ChangedSinceLastFrame then
	
		-- Absolute X = Real X for drawing on the render target
		for k, v in pairs(self.m_Children) do
			v.m_AbsoluteX = v.m_PosX - self.m_ScrollX
			v.m_AbsoluteY = v.m_PosY - self.m_ScrollY
		end
		
		-- Draw Children to render Target
		dxSetRenderTarget(self.m_pPageTarget, true)
		for k, v in ipairs(self.m_Children) do
			if v.draw then v:draw(incache) end
		end
		dxSetRenderTarget()

		-- Recreate AbsoluteX for the update() method, to allow mouse actions
		for k, v in pairs(self.m_Children) do
			v.m_AbsoluteX = self.m_AbsoluteX + v.m_PosX - self.m_ScrollX
			v.m_AbsoluteY = self.m_AbsoluteY + v.m_PosY - self.m_ScrollY
		end
		
		self.m_ChangedSinceLastFrame = false
	end
	
	-- Draw Self
	if self.drawThis then self:drawThis(incache) end
end

function GUIScrollableArea:scroll(x, y)
	self.m_ScrollX = x
	self.m_ScrollY = y
end

function GUIScrollableArea:resize(documentWidth, documentHeight)
	destroyElement(self.m_pPageTarget)
	self.m_pPageTarget = dxCreateRenderTarget(documentWidth, documentHeight, true)
end

CGUIElement._change.m_ScrollX = CGUIElement.anyChange
CGUIElement._change.m_ScrollY = CGUIElement.anyChange

	
	