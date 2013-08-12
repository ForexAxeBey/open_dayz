-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Weather.lua
-- *  PURPOSE:     Weather class
-- *
-- ****************************************************************************
Weather = inherit(Singleton)

function Weather:constructor()
	self.m_WeatherInfo = {}
	self.m_NextIndex = 1
	self.m_Current = nil

	self:buildInfo()
	self:update()
	setTimer(bind(Weather.update, self), 1000*60, 0)
end

function Weather:buildInfo()
	-- get the server settings for day/night fade
	local sweather = server:get("weather")
	
	self.m_WeatherInfo = {}
	for i = 1, 24 do
		if sweather[("hour_%02d"):format(i)] then 
			self.m_WeatherInfo[#self.m_WeatherInfo+1] = sweather[("hour_%02d"):format(i)]
			self.m_WeatherInfo[#self.m_WeatherInfo].hour = i
		end
	end
	
	-- set the first hour
	local hour, minute = getTime()
	
	while not self.m_Current or hour >= self.m_Current.hour do
		self.m_Current = self.m_WeatherInfo[self.m_NextIndex]
		if self.m_WeatherInfo[self.m_NextIndex+1] then
			self.m_NextIndex = self.m_NextIndex+1
		else
			self.m_NextIndex = 1
		end
	end
end

function Weather:update()
	local hour, minute = getTime()
	
	-- get the server settings for day/night fade
	-- for the previous and next entry
	if not self.m_Current or  hour >= self.m_Current.hour then
		self.m_Current = self.m_WeatherInfo[self.m_NextIndex]
		if self.m_WeatherInfo[self.m_NextIndex+1] then
			self.m_NextIndex = self.m_NextIndex+1
		else
			self.m_NextIndex = 1
		end
	end
	
	-- fade the effects
	
	-- get a percentage progression to the next timepoint
	local next = self.m_WeatherInfo[self.m_NextIndex]
	local nexthour = next.hour
	hour = hour + minute * 1/60
	local perc = (1 - (nexthour - hour) / nexthour) 
	
	local farclip_c = self.m_Current.farclip_distance
	local farclip_n = next.farclip_distance

	setFarClipDistance(farclip_c + (farclip_n - farclip_c) * perc)
	
	local fog_c = self.m_Current.fog_distance
	local fog_n = next.fog_distance
	setFogDistance(fog_c + (fog_n - fog_c) * perc)
	
	local skygradient_c = self.m_Current.sky_gradient
	local skygradient_n = next.sky_gradient
	local skygradient = {}
	for k, v in pairs(skygradient_c) do
		skygradient[k] = v + (skygradient_n[k] - v) * perc
	end
	setSkyGradient(unpack(skygradient))
end