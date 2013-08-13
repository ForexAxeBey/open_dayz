-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/GUIRenderer.lua
-- *  PURPOSE:     GUI renderer class
-- *
-- ****************************************************************************

GUIRenderer = {}

function GUIRenderer.constructor()	
	GUIRenderer.dxroot = GUIElement:new(0, 0, screenWidth, screenHeight)
	GUIRenderer.dxroot_t = DxElement:new(0, 0, screenWidth, screenHeight) -- Todo: Use the same dxroot
	
	GUIRenderer.cache = {}
	
	addEventHandler("onClientPreRender", root, GUIRenderer.updateAll)
	addEventHandler("onClientRender", root, GUIRenderer.drawAll)
	addEventHandler("onClientRestore", root, GUIRenderer.restore)
end

function GUIRenderer.destructor()
	removeEventHandler("onClientPreRender", root, GUIRenderer.updateAll)
	removeEventHandler("onClientRender", root, GUIRenderer.drawAll)
end

function GUIRenderer.updateAll()
	GUIRenderer.dxroot:update()
end

function GUIRenderer.drawAll()
	--GUIRenderer.dxroot:draw()
	
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
