-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/database/databaseUpdaterMySQL.lua
-- *  PURPOSE:     MySQL specialization for the database updater
-- *
-- ****************************************************************************
DatabaseUpdaterMySQL = inherit(DatabaseUpdater)

function DatabaseUpdaterMySQL:getVersion()
	-- Check if we have our info table
	local infoTableExists = sql:queryFetchSingle("SHOW TABLES LIKE '??_version';", sql:getPrefix()) ~= nil
	
	if not infoTableExists then
		return false
	end
	
	-- Get the version
	return sql:queryFetchSingle("SELECT `Version` FROM `??_version`", sql:getPrefix()).Version
end

function DatabaseUpdaterMySQL:createTable(name, info)
	query = [[CREATE TABLE `??_??` ( ]]
	
	local first = true
	local primary
	for k, v in ipairs(info) do
		if first then
			first = false
		else
			query = query..","
		end
		query = query..([[`%s` %s%s]]):format(v.name, self:getSQLType(v.vartype), self:getSQLOptions(info[k]))
		if v.primaryKey then primary = k end
	end
	
	if primary then
		query = query..(", PRIMARY KEY (`%s`)"):format(info[primary].name)
	end
	
	query = query..");"
	
	sql:queryExec(query, sql:getPrefix(), name)
end

function DatabaseUpdaterMySQL:getSQLType(t)
	if t == "int" 		then return "int" end
	if t == "tinyint"	then return "tinyint" end
	if t == "smallint"	then return "smallint" end
	if t == "mediumint"	then return "mediumint" end
	if t == "bigint"	then return "bigint" end
	if t == "float"		then return "float" end
	if t == "text" 		then return "text" end
	if t == "varchar" 	then return "varchar" end
	
	error("sqltype fail") 
end

function DatabaseUpdaterMySQL:getSQLOptions(list)
	local str = ""
	if list.length 			then str = ("(%d) "):format(list.length) end
	if list.unsigned 		then str = str.." UNSIGNED" end
	if list.autoincrement 	then str = str.." AUTO_INCREMENT" end
	if not list.allowNULL 	then str = str.." NOT NULL" end
	if list.default			then str = str.." DEFAULT "..tostring(list.default) end
	
	return str
end