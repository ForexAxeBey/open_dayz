-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/items.lua
-- *  PURPOSE:     Items
-- *
-- ****************************************************************************
enum("ITEM_SLOT_GENERIC", 			"item_slot") -- Anything holding stuff (aka. trunk of a vehicle, backpack etc.)
enum("ITEM_SLOT_PRIMARY_WEAPON", 	"item_slot") -- 1 Slot
enum("ITEM_SLOT_SECONDARY_WEAPON", 	"item_slot") -- 1 Slot
enum("ITEM_SLOT_TOOL_HEAD", 		"item_slot") -- 2 Slots
enum("ITEM_SLOT_MAIN", 				"item_slot") -- 12 Slots
enum("ITEM_SLOT_SIDE", 				"item_slot") -- 8 Slots
enum("ITEM_SLOT_TOOLBELT", 			"item_slot") -- 8 Slots


-- Notes: 
-- 	UID has to be static even between versions, this is to ensure database compatibilty
--  Leave a few free Ids so we can add some items in order later
-- 	Max Stack == 0 means unstackable
Items = {
-- Primary Weapons (UID 1 to 9)
-- Name  		UID	Written Name				Weight	Size		Max Stack 	Slot	
M4 			= {	1, 	"M4",						3,		{1,1},		0,			ITEM_SLOT_PRIMARY_WEAPON },
CZ550 		= {	2, 	"CZ 550",					3,		{1,1},		0,			ITEM_SLOT_PRIMARY_WEAPON },
WINCHESTER 	= { 3, 	"Winchester 1866",			3,		{1,1},		0,			ITEM_SLOT_PRIMARY_WEAPON },
SPAZ		= { 4, 	"SPAZ-12 Combat Shotgun",	3,		{1,1},		0,			ITEM_SLOT_PRIMARY_WEAPON },
SHOTGUN		= { 5,  "Sawn-Off Shotgun",			3,		{1,1},		0,			ITEM_SLOT_PRIMARY_WEAPON },
AK_47		= { 6,  "AK-47",					3,		{1,1},		0,			ITEM_SLOT_PRIMARY_WEAPON },
LEE_ENFIELD	= { 7,  "Lee Enfield",				3,		{1,1},		0,			ITEM_SLOT_PRIMARY_WEAPON },

-- Secondary Weapons (UID 10 to 30)
-- Name  		UID	Written Name	Weight		Size		Max Stack 	Slot	
M1911 		= { 10, "M1911", 		2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
M9SD	 	= { 11, "M9 SD", 		2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
PDW 		= { 12, "PDW", 			2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
MP5A5 		= { 13, "MP5A5", 		3,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
DEAGLE		= { 14, "Desert Eagle", 2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
KNIFE		= { 15, "Hunting Knife",1,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
HATCHET 	= { 16, "Hatchet", 		2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
BASEBALLBAT = { 17, "Baseball Bat", 2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
SHOVEL 		= { 18, "Shovel", 		2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },
GOLF 		= { 19, "Golf Club", 	2,			{1,1},		0,			ITEM_SLOT_SECONDARY_WEAPON },

-- Toolbelt
MEDICKIT	= { 20, "Medic Kit",	1,			{1,1},		5,			ITEM_SLOT_TOOLBELT,			ItemMedicKit },
RADAR		= { 21, "Radar",		1,			{1,1},		0,			ITEM_SLOT_TOOLBELT,			ItemRadar },

-- Add more below
}

-- Apply some magic to allow accessing stuff in a nice way
local NiceItems = {}
for k, v in pairs(Items) do
	NiceItems[k] = { UID = v[1], Name = v[2], Weight = v[3], Size = v[4], MaxStack = v[5], Slot = v[6], Class = v[7] }
	NiceItems[v[1]] = NiceItems[k]
end
Items = NiceItems