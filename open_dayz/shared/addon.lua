-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        shared/addon.lua
-- *  PURPOSE:     Addon API
-- *
-- ****************************************************************************
function prepareExportArguments(...)
	local args = {...}
	for k, v in ipairs(args) do
		if type(v) == "table" and instanceof(v, Exported) then
			args[k] = { "api", v:getId(), v:getTypeId() }
		end
	end
	return args
end

function callMethod(self, func, ...)
	local typeId, objId = self[3], self[2]
	local classt = Exported.getClassTypeById(typeId)
	if classt and objId then
		-- Method call
		local object = classt:getObjectById(objId)
		return prepareExportArguments(classt[func](object, receiveExportArguments({...})))
	end
	if classt and not objId then
		-- Static call
		return prepareExportArguments(classt[func](classt, receiveExportArguments({...})))
	end
end

function callElementMethod(self, func, ...)
	return prepareExportArguments(self[func](self, receiveExportArguments({...})))
end

function receiveExportArguments(args)
	for k, v in ipairs(args) do
		if type(v) == "table" and v[1] == "api" then
			args[k] = Exported.getClassTypeById(v[3]):getObjectById(v[2])
		end
	end
	
	return unpack(args)
end

function getGamemodeInfo()
	return {
		classes = Exported.getClassList();
		enums = getEnums();
		version = VERSION;
	}
end

function callEvent(eventName, sourceElement, ...)
	return triggerEvent(eventName, sourceElement, unpack(prepareExportArguments(...)))
end
