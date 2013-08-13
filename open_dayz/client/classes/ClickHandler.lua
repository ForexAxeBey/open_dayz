-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/ClickHandler.lua
-- *  PURPOSE:     Class that handles clicks on elements
-- *
-- ****************************************************************************
ClickHandler = inherit(Object)

function ClickHandler:constructor()
	self.m_OpenMenus = {}
	self.m_Menu = {
		player = PlayerMouseMenu;
		vehicle = VehicleMouseMenu;
	}
	addEventHandler("onClientClick", root, bind(self.dispatchClick, self))
end

function ClickHandler:dispatchClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, element)
	if button == "right" and state == "up" then
		if not element or not isElement(element) then
			return
		end
	
		local elementType = getElementType(element)
		if self.m_Menu[elementType] --[[and not element == localPlayer]] then
			table.insert(self.m_OpenMenus, self.m_Menu[elementType]:new(absoluteX, absoluteY))
		end
	elseif button == "left" and state == "up" then
		-- Close all currently opened menus
		for k, menu in ipairs(self.m_OpenMenus) do
			delete(menu)
		end
	end
end
