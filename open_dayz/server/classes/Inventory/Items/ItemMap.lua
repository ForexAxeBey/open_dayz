-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Items/ItemMap.lua
-- *  PURPOSE:     Items: F11 map
-- *
-- ****************************************************************************
ItemMap = inherit(Item)

function ItemMap:enable(player)
	-- Enable radar control
	toggleControl(player, "radar", true)
end

function ItemMap:disable(player)
	-- Disable radar control
	toggleControl(player, "radar", false)

	-- Hide the player's map if visible
	forcePlayerMap(player, false)
end

function ItemMap:use(player)
end
