-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/database/databaseUpdaterSQLite.lua
-- *  PURPOSE:     SQLite specialization for the database updater
-- *
-- ****************************************************************************
DatabaseUpdaterSQLite = inherit(DatabaseUpdater)

function DatabaseUpdaterSQLite:getVersion()
	-- Check if we have our info table
	local infoTableExists = sql:queryFetchSingle("SELECT count(*) AS `exists` FROM sqlite_master WHERE type='table' AND name='??_version';", sql:getPrefix()).exists == 1
	
	if not infoTableExists then
		return false
	end
	
	-- Get the version
	return sql:queryFetchSingle("SELECT `Version` FROM `??_version`", sql:getPrefix()).Version
end

function DatabaseUpdaterSQLite:createTable(name, info)
	query = [[CREATE TABLE "main"."??_??" ( ]]
	
	local first = true
	local primary
	for k, v in ipairs(info) do
		if first then
			first = false
		else
			query = query..","
		end
		query = query..([[`%s` %s%s]]):format(v.name, self:getSQLType(v.vartype), self:getSQLOptions(info[k]))
		if v.primaryKey and not v.autoincrement then primary = k end
	end
	
	if primary then
		query = query..(", PRIMARY KEY (`%s`)"):format(info[primary].name)
	end
	query = query..");"
	
	sql:queryFetch(query, sql:getPrefix(), name)
end

function DatabaseUpdaterSQLite:getSQLType(t)
	if t == "int" 		then return "INTEGER" end
	if t == "tinyint"	then return "INTEGER" end
	if t == "smallint"	then return "INTEGER" end
	if t == "mediumint"	then return "INTEGER" end
	if t == "bigint"	then return "INTEGER" end
	if t == "float"		then return "REAL" end
	if t == "text" 		then return "TEXT" end
	if t == "varchar" 	then return "TEXT" end
	
	error("sqltype fail") 
end

function DatabaseUpdaterSQLite:getSQLOptions(list)
	local str = ""
	if list.length 			then str = ("(%d) "):format(list.length) end
	if list.autoincrement and list.primaryKey then str = str.." PRIMARY KEY" end
	if list.autoincrement 	then str = str.." AUTOINCREMENT" end
	if not list.allowNULL 	then str = str.." NOT NULL" end
	if list.default			then str = str.." DEFAULT "..tostring(list.default) end
	return str
end