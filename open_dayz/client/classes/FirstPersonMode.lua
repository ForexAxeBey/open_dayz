-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/FirstPersonMode.lua
-- *  PURPOSE:     First person mode class
-- *
-- ****************************************************************************
FirstPersonMode = inherit(Singleton)
local mouseSensitivity = 0.1 -- Todo: Use a config var for that

function FirstPersonMode:constructor()
	self.m_AngleX = 0 -- 0 is forward (degree)
	self.m_AngleY = 0

	self.m_FuncPreRender = bind(self.update, self)
	self.m_FuncCursorMove = bind(self.cursorMove, self)
	self.m_FuncVehicleEnter = bind(self.vehicleEnter, self)
	self.m_FuncVehicleExit = bind(self.vehicleExit, self)
	
	bindKey("x", "down",
		function()
			if self.m_VehicleState or self.m_OnFootState then
				self:disable()
			else
				self:enable()
			end
		end
	)
end

function FirstPersonMode:update()
	if self.m_VehicleState and isPedInVehicle(localPlayer) then
		self:updateVehicle()
	elseif self.m_OnFootState and not isPedInVehicle(localPlayer) then
		self:updateOnFoot()
	end
end

function FirstPersonMode:updateVehicle()
	local posX, posY, posZ = getElementPosition(localPlayer)
	local _, _, rotation = getElementRotation(localPlayer)
	posZ = posZ + 0.6
	
	local lookAtX, lookAtY, lookAtZ = posX + math.cos(math.rad(rotation + self.m_AngleX + 90)), posY + math.sin(math.rad(rotation + self.m_AngleX + 90)), posZ + math.sin(math.rad(self.m_AngleY))
	setCameraMatrix(posX, posY, posZ, lookAtX, lookAtY, lookAtZ)
end

function FirstPersonMode:updateOnFoot()
	local posX, posY, posZ = getElementPosition(localPlayer)
	local _, _, rotation = getElementRotation(localPlayer)
	posZ = posZ + 0.6
	
	local lookAtX, lookAtY, lookAtZ = posX + math.cos(math.rad(self.m_AngleX + 90)), posY + math.sin(math.rad(self.m_AngleX + 90)), posZ + math.sin(math.rad(self.m_AngleY))
	setCameraMatrix(posX, posY, posZ, lookAtX, lookAtY, lookAtZ)
end

function FirstPersonMode:cursorMove(_, _, absoluteX, absoluteY)
	if isCursorShowing() or isMTAWindowActive() then
		return
	end
	
	-- Calculate moved distance
	local movedX, movedY = absoluteX - screenWidth/2, absoluteY - screenHeight/2
	self.m_AngleX, self.m_AngleY = self.m_AngleX + -movedX * mouseSensitivity, self.m_AngleY + -movedY * mouseSensitivity
end

function FirstPersonMode:vehicleEnter(vehicle, seat)
	-- Reset camera angle if enabled
	if self.m_VehicleState then
		self.m_AngleX, self.m_AngleY = 0, 0
	end
end

function FirstPersonMode:vehicleExit(vehicle, seat)
	-- Reset camera target if disabled
	if not self.m_OnFootState then
		setCameraTarget(localPlayer)
	end
end

function FirstPersonMode:enable(vehicleOnly, onfootOnly)
	vehicleOnly = vehicleOnly == nil and true
	onfootOnly = onfootOnly == nil and true
	
	self.m_VehicleState = vehicleOnly
	self.m_OnFootState = onfootOnly

	if vehicleOnly or onfootOnly then
		addEventHandler("onClientPreRender", root, self.m_FuncPreRender)
		addEventHandler("onClientCursorMove", root, self.m_FuncCursorMove)
		addEventHandler("onClientPlayerVehicleEnter", localPlayer, self.m_FuncVehicleEnter)
		addEventHandler("onClientPlayerVehicleExit", localPlayer, self.m_FuncVehicleExit)
	else
		self:disable()
	end
end

function FirstPersonMode:disable()
	removeEventHandler("onClientPreRender", root, self.m_FuncPreRender)
	removeEventHandler("onClientCursorMove", root, self.m_FuncCursorMove)
	removeEventHandler("onClientPlayerVehicleEnter", localPlayer, self.m_FuncVehicleEnter)
	removeEventHandler("onClientPlayerVehicleExit", localPlayer, self.m_FuncVehicleExit)
	
	setCameraTarget(localPlayer)
	self.m_VehicleState = false
	self.m_OnFootState = false
end
