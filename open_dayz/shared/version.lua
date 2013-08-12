-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/version.lua
-- *  PURPOSE:     Version
-- *
-- ****************************************************************************
VERSION = "0.1"
BUILD = "development"
--BUILD = "stable"
--BUILD = "unstable"
REVISION = 0

if BUILD == "development" then
	VERSION_LABEL = ("Open MTA:DayZ %sdev r%d"):format(VERSION, REVISION)
elseif BUILD == "unstable" then
	VERSION_LABEL = ("Open MTA:DayZ %s unstable"):format(VERSION)
else
	VERSION_LABEL = ("Open MTA:DayZ %s"):format(VERSION)
end