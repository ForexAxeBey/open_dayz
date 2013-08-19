-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Items/ItemRadar.lua
-- *  PURPOSE:     Items: Radar map
-- *
-- ****************************************************************************
ItemRadar = inherit(Item)

function ItemRadar:enable(player)
	-- Show the radar
	showPlayerHudComponent(player, "radar", true)
end

function ItemRadar:disable(player)
	-- Hide the radar
	showPlayerHudComponent(player, "radar", false)
end

function ItemRadar:use(player)
end
