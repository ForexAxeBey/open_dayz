-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/GUIRenderer.lua
-- *  PURPOSE:     GUI renderer class
-- *
-- ****************************************************************************

GUIRenderer = {cache = {}}

function GUIRenderer.constructor()	
	-- Create a default cache area
	GUIRenderer.guiroot = GUIElement:new(0, 0, screenWidth, screenHeight)
	GUIRenderer.cacheroot = CacheArea:new(0, 0, screenWidth, screenHeight)
	
	addEventHandler("onClientPreRender", root, GUIRenderer.updateAll)
	addEventHandler("onClientRender", root, GUIRenderer.drawAll)
	addEventHandler("onClientRestore", root, GUIRenderer.restore)
end

function GUIRenderer.destructor()
	removeEventHandler("onClientPreRender", root, GUIRenderer.updateAll)
	removeEventHandler("onClientRender", root, GUIRenderer.drawAll)
end

function GUIRenderer.updateAll()
	GUIRenderer.guiroot:update()
end

function GUIRenderer.drawAll()
	for k, v in ipairs(GUIRenderer.cache) do
		v:draw()
	end
end

function GUIRenderer.restore(clearedRenderTargets)
	if clearedRenderTargets then
		-- Redraw render target(s)
		GUIRenderer.dxroot:anyChange()
	end
end
