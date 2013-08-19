-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Items/ItemFood.lua
-- *  PURPOSE:     Items: Food super class
-- *
-- ****************************************************************************
ItemFood = inherit(Item)

function ItemFood:constructor(...)
	-- The Items table is not yet available when this script will be loaded
	if not ItemFood.FoodSizes then
		ItemFood.FoodSizes = {
			[Items.BURGER.UID] = 40,
			[Items.PIZZA.UID] = 70,
		}
	end
	
	Item.constructor(self, ...)
end

function ItemFood:use(player)
	local amount = ItemFood.FoodSizes[self.m_ItemId]
	if amount then
		player:raiseNecessity(NECESSITY_HUNGER, amount)
	end
end
