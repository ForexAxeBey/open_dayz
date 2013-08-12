-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/databaseSchema.lua
-- *  PURPOSE:     Schema for the current version of the database
-- *
-- ****************************************************************************
DBSchema = {}

--[[
Add a table into DBSchema to create a new SQL Table the table will be 
prefixed with the sql prefix set in the main config. 

Following Arguments are required:
	string	name
	string 	vartype : one of "int|varchar|text|boolean|float"
	
Following Arguments are optional:
	bool 	autoincrement
	bool 	unsigned
	bool 	allowNULL
	bool 	primatyKey
	int 	length (required for vartype = varchar)
	var		default
		
]]

DBSchema.version = {
{ name = "Version", vartype = "int", unsigned  = true, allowNULL = false, primaryKey = true }
}

DBSchema.player = {
{ name = "Id", 		vartype = "int", 	 autoincrement = true, unsigned = true, allowNULL = false, primaryKey = true };
{ name = "Name", 	vartype = "varchar", length = 32, 		allowNULL = false };
{ name = "Password",vartype = "varchar", length = 32, 		allowNULL = false };
{ name = "Salt", 	vartype = "varchar", length = 32, 		allowNULL = false };
{ name = "Admin",	vartype = "tinyint", unsigned = true, 	allowNULL = false, default = 0 };
{ name = "Locale",	vartype = "varchar", length = 2, 		allowNULL = false, default = "en" };
{ name = "PosX",	vartype = "float", 	 allowNULL = true };
{ name = "PosY",	vartype = "float", 	 allowNULL = true };
{ name = "PosZ",	vartype = "float", 	 allowNULL = true };
{ name = "Rotation",vartype = "float", 	 allowNULL = true };
{ name = "Interior",vartype = "tinyint", allowNULL = true };
{ name = "Inventory",vartype = "int", 	 allowNULL = false, default = -1 };
{ name = "Kills",	vartype = "int",	 unsigned = true, allowNULL = true };
{ name = "Deaths",  vartype = "int",	 unsigned = true, allowNULL = true };
}

DBSchema.inventory = {
{ name = "Id", 				vartype = "int", allowNULL = false, autoincrement = true, unsigned = true, primaryKey = true };
{ name = "GENERIC",			vartype = "int", allowNULL = false, unsigned = true, default = -1 };
{ name = "PRIMARY_WEAPON",	vartype = "int", allowNULL = false, unsigned = true, default = -1 };
{ name = "SECONDARY_WEAPON",vartype = "int", allowNULL = false, unsigned = true, default = -1 };
{ name = "TOOL_HEAD",		vartype = "int", allowNULL = false, unsigned = true, default = -1 };
{ name = "MAIN",			vartype = "int", allowNULL = false, unsigned = true, default = -1 };
{ name = "SIDE",			vartype = "int", allowNULL = false, unsigned = true, default = -1 };
{ name = "TOOLBELT",		vartype = "int", allowNULL = false, unsigned = true, default = -1 };
}

DBSchema.inventory_slot = 
{
{ name = "Id", 	 	vartype = "int",  autoincrement = true, unsigned = true, allowNULL = false, primaryKey = true };
{ name = "Width", 	vartype = "int",  unsigned = true, allowNULL = false };
{ name = "Height", 	vartype = "int",  unsigned = true, allowNULL = false };
{ name = "Content", vartype = "text", unsigned = true, allowNULL = false };
}