editorHelper = {}
outputDebugString("editorHelper loaded")

addEvent("onClientElementCreate")
addEvent("onClientElementDrop")
addEvent("onClientElementSelect")

function editorHelper:constructor()
	-- Add event handlers
	addEventHandler("onClientElementCreate", root, function() self:Event_elementCreate() end)
	addEventHandler("onClientElementDrop", root, function() self:Event_elementDrop() end)
	addEventHandler("onClientElementSelect", root, function(...) self:Event_elementSelect(...) end)
	addEventHandler("onClientRender", root, function(...) self:Event_preRender(...) end)
end

function editorHelper:Event_elementCreate()
	if getElementType(source) == "nozombiearea" then
		--setElementAlpha(getRepresentation(source, "object"), 0)
	end
end

function editorHelper:Event_elementDrop()
	removeEventHandler("onClientRender", root, self.m_FuncDraw)
end

function editorHelper:Event_elementSelect()
	if getElementType(source) ~= "nozombiearea" and getElementType(getElementParent(source)) == "nozombiearea" then
		source = getElementParent(source)
	end
	
	if getElementType(source) == "nozombiearea" then
		outputChatBox("Zombiearea selected")
		
	end
end

function createTexture(width, height, text)
	local texture = dxCreateRenderTarget(width, height, true)
	dxSetRenderTarget(texture)
	
	dxDrawRectangle(0, 0, width, height, tocolor(255, 0, 0, 200))
	dxDrawText(text, width/2, height/2, width/2, height/2, tocolor(0, 0, 0), 2, "arial", "center", "center")
	dxSetRenderTarget(nil)
	return texture
end

local texture = createTexture(1024, 1024, "Zombie free area")
function editorHelper:Event_preRender(elapsedTime)
	for k, v in ipairs(getElementsByType("nozombiearea")) do
		local element = getRepresentation(v, "object")
		local x, y, z = getElementPosition(element)
		local width, height = exports.edf:edfGetElementProperty(element, "width"), exports.edf:edfGetElementProperty(element, "height")
		if width and height then
			dxDrawMaterialLine3D(x, y, z, x+width, y+width, z, texture, height, tocolor(255,255,255), x, y, z+10)
		end
	end
end

function onStart()
	local mt = setmetatable({}, {__index = editorHelper})
	mt:constructor()
end

function getRepresentation(element,type)
	local elemTable = {}
	for i,elem in ipairs(getElementsByType(type,element)) do
		if elem ~= exports.edf:edfGetHandle ( elem ) then
			table.insert(elemTable, elem)
		end
	end
	if #elemTable == 0 then
		return false
	elseif #elemTable == 1 then
		return elemTable[1]
	else
		return elemTable
	end
end