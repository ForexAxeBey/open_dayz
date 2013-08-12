-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/database/dbUpdate.lua
-- *  PURPOSE:     Sample Database Update
-- *
-- ****************************************************************************

--[[ 
	Guide to Database Updates
	
	Add your dbUpdate to DatabaseUpdater.dbUpdate[index]
	for index, use the OLD database version which should be upgraded
]]
DatabaseUpdater.dbUpdate[000] = function()
	if true then return end -- this is a sample which should not be applied
	
	-- Example condition:
	-- In db version -1 we had no table called 'funkystuff' so we need to create this
	self:createTable("funkystuff", DBSchema.funkystuff)
	
	-- Add more examples
end
