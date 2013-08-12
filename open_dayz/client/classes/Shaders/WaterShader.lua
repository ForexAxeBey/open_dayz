-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/shader/WaterShader.lua
-- *  PURPOSE:     Water Vertex Shader
-- *
-- ****************************************************************************
WaterShader = inherit(Shader)

function WaterShader:constructor()
	TransferManager:getSingleton():requestFilesAsOnce(
	{	"files/shader/water.fx";
	}
	, bind(WaterShader.load, self))
	
	self.m_Active = false
	self.m_Wave = 0
	
	WaterShader.constructor = false -- Pseudo-Singleton, hacky
end

function WaterShader:destructor()
	self:unload()
end

function WaterShader:load()
	self.m_Shader, self.m_Tec = dxCreateShader("files/shader/water.fx")
	if not self.m_Shader then
		outputDebug("[WaterShader] Shader Issues - use debugscript 3")
		return
	elseif self.m_Tec == "fail" then
		outputDebug("[WaterShader] Cannot not support shader, disabling")
		self:unload()
		return
	end

	self.m_Active = true
	engineApplyShaderToWorldTexture(self.m_Shader, "waterclear256" )
	addEventHandler("onClientRender", root, bind(WaterShader.render, self))
end

function WaterShader:render()	
	if not self.m_Active then return end
	dxSetShaderValue(self.m_Shader, "gWave", self.m_Wave)
	self.m_Wave = self.m_Wave + 0.05
	if self.m_Wave > 2*math.pi then self.m_Wave = 0 end
end

function WaterShader:unload()
	destroyElement(self.m_Shader)
	self.m_Active = false
end

function WaterShader:set() end
function WaterShader:get() end
