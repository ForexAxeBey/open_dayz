-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/CacheArea.lua
-- *  PURPOSE:     Cached area class
-- *
-- ****************************************************************************
CacheArea = inherit(DxElement)

function CacheArea:constructor(posX, posY, width, height)
	DxElement.constructor(self, posX, posY, width, height)

	table.insert(GUIRenderer.cache, self)

	self.m_RenderTarget = dxCreateRenderTarget(width, height, true)
	
end

function CacheArea:updateArea()
	if not self then outputConsole(debug.traceback()) end

	self.m_ChangedSinceLastFrame = true
	-- Go up the tree
	if self.m_Parent then self.m_Parent:anyChange() end
end

function CacheArea:drawCached()
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
			v:draw(true)
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

function CacheArea:draw(incache)
	if not incache then
		if self:drawCached() then return end
	end

	if self.m_Visible == false then
		return
	end
	
	-- Draw Self
	if self.drawThis then self:drawThis(incache) end

	-- Draw Children
	for k, v in ipairs(self.m_Children) do
		if v.draw then v:draw(incache) end
	end
end
