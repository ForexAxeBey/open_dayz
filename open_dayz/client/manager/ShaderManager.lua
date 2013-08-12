-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/manager/ShaderManager.lua
-- *  PURPOSE:     Shader manager
-- *
-- ****************************************************************************
ShaderManager = inherit(Singleton)

function ShaderManager:constructor()
	self.m_RegisteredShaders = {}
	self.m_Shaders = {}
	
	self:registerShaders()
	-- TODO: Check a client config
	self:loadShader("water")
end

function ShaderManager:registerShaders()
	-- List of all available shaders
	self.m_RegisteredShaders["water"] = WaterShader
end

function ShaderManager:loadShader(name)
	self.m_Shaders[name] = self.m_RegisteredShaders[name]:new()
end

function ShaderManager:unloadShader(shader)
	self.m_Shaders[shader]:unload()
	self.m_Shaders[shader] = nil
end

function ShaderManager:getShaderValue(shader, key)
	return self.m_Shaders[shader]:get(key)
end

function ShaderManager:setShaderValue(shader, key, value)
	return self.m_Shaders[shader]:set(key, value)
end

function ShaderManager:onClientRender()
	for k, v in pairs(self.m_Shaders[shader]) do
		v:onClientRender()
	end
end

function ShaderManager:onClientPreRender()
	for k, v in pairs(self.m_Shaders[shader]) do
		v:onClientPreRender()
	end
end

