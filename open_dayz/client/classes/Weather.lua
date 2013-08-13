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
	local hasWeather = false
	
	self.m_WeatherInfo = {}
	for i = 0, 23 do
		if sweather[("hour_%02d"):format(i)] then 
			hasWeather = true
			self.m_WeatherInfo[#self.m_WeatherInfo+1] = sweather[("hour_%02d"):format(i)]
			self.m_WeatherInfo[#self.m_WeatherInfo].hour = i
		end
	end
	
	if not hasWeather then
		self.m_WeatherInfo[1] = 
		{
			hour = 0;
			sky_gradient = {};
			fog_distance = 400;
			farclip_distance = 400;
		}
	end
	
	-- set the first hour
	local hour, minute = getTime()
	
	while not self.m_Current or hour <= self.m_Current.hour do
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
	if not self.m_Current or hour >= self.m_Current.hour then
		self.m_Current = self.m_WeatherInfo[self.m_NextIndex]
		if self.m_WeatherInfo[self.m_NextIndex+1] then
			self.m_NextIndex = self.m_NextIndex+1
		else
			self.m_NextIndex = 1
		end
	end
	
	-- fade the effects
	local next = self.m_WeatherInfo[self.m_NextIndex]
	local perc
	
	-- do we have something to fade at all?
	if self.m_Current.hour == next.hour then 
		perc = 1
	else	
		-- get a percentage progression to the next timepoint
		local nexthour = next.hour
		local curhour = self.m_Current.hour
		hour = hour + minute * 1/60
		perc = (hour - curhour) / (nexthour - curhour)
	end
	
	local farclip_c = self.m_Current.farclip_distance
	local farclip_n = next.farclip_distance

	setFarClipDistance(farclip_c + (farclip_n - farclip_c) * perc)
	
	local fog_c = self.m_Current.fog_distance
	local fog_n = next.fog_distance
	setFogDistance(fog_c + (fog_n - fog_c) * perc)
	
	local skygradient_c = self.m_Current.sky_gradient
	local skygradient_n = next.sky_gradient
	local skygradient = {}
	
	skygradient[1] = skygradient_c.topr + (skygradient_n.topr - skygradient_c.topr) * perc
	skygradient[2] = skygradient_c.topg + (skygradient_n.topg - skygradient_c.topg) * perc
	skygradient[3] = skygradient_c.topb + (skygradient_n.topb - skygradient_c.topb) * perc
	skygradient[4] = skygradient_c.botr + (skygradient_n.botr - skygradient_c.botr) * perc
	skygradient[5] = skygradient_c.botg + (skygradient_n.botg - skygradient_c.botg) * perc
	skygradient[6] = skygradient_c.botb + (skygradient_n.botb - skygradient_c.botb) * perc

	setSkyGradient(unpack(skygradient))
end