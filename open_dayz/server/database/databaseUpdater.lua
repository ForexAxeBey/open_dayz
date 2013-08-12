-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/databaseUpdater.lua
-- *  PURPOSE:     Class to update / create the database
-- *
-- ****************************************************************************
DatabaseUpdater = inherit(Object)
DatabaseUpdater.dbUpdate = {}

-- Increment this if there's a database change. Will also require additional updating code
local CURRENT_DB_VERSION = 0xFFFFFFFF

function DatabaseUpdater:updateDatabase()
	if CURRENT_DB_VERSION == 0xFFFFFFFF and DEBUG then
		-- Database Development Modus, flush everything on each restart
		self:deleteDatabase()
		self:createDatabase()
		return
	end
	
	-- get our version
	local version = self:getVersion()
	if not version then
		-- Assume Empty DB
		self:createDatabase()
		return
	end
	
	
	if version == CURRENT_DB_VERSION then
		-- All good, we're on the current Database Version
		return
	elseif version >= CURRENT_DB_VERSION then
		-- Attempted downgrading or someone manually edited something, abort!
		critical_error("Database Version is higher than the Script Database Version")
		return
	else
		-- Upgrading from a previous version
		local dbversion = version
		while dbversion < CURRENT_DB_VERSION do
			outputDebug(("Updating to Database Version %d"):format(dbversion+1))
			self.dbUpdate[dbversion]()
			dbversion = dbversion+1
		end
	end
end

function DatabaseUpdater:createDatabase()
	for tablename, info in pairs(DBSchema) do
		self:createTable(tablename, info)
	end
	
	sql:queryFetch("INSERT INTO `??_version`(`Version`) VALUES(?);", sql:getPrefix(), CURRENT_DB_VERSION)
end

function DatabaseUpdater:deleteDatabase()
	for tablename, info in pairs(DBSchema) do
		sql:queryFetch("DROP TABLE IF EXISTS `??_??`", sql:getPrefix(), tablename)
	end
end

DatabaseUpdater.createTable 	= pure_virtual
DatabaseUpdater.getSQLType 		= pure_virtual
DatabaseUpdater.getSQLOptions 	= pure_virtual
DatabaseUpdater.getVersion 		= pure_virtual