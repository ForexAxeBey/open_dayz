-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Items/ItemMedicKit.lua
-- *  PURPOSE:     Items: Medic Kit
-- *
-- ****************************************************************************
ItemMedicKit = inherit(Item)

function ItemMedicKit:use(player)
	setElementHealth(player, 100)
end
