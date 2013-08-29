-- ****************************************************************************
-- *
-- *  PROJECT:     	Open MTA:DayZ
-- *  FILE:        	server/defaultConfig.lua
-- *  PURPOSE:     	Default configuration
-- *
-- ****************************************************************************
local defaultConfig = 
{
	sql = {
		dbtype 				= "sqlite";
		prefix				= "dayz";
		sqlite_path 		= "dayz_sqlite.db";
		
		mysql_host 			= "changeme";
		mysql_user 			= "changeme";
		mysql_password 		= "changeme";
		mysql_database 		= "changeme";
		mysql_unix_socket	= "";
	};
	
	transfermanager = {
		use_external_webserver = false;
		external_webserver_url = "";
		player_max_transferspeed = 100000;
	};
	
	filecache = {
		timeout = 30000; 
	};
	
	anticheat = {
		allow_d3d9 			= true;
		allow_texture 		= true;
		allow_weapon_model 	= true;
		allow_vehicle_model	= true;
		allow_skin_model 	= true;
		allow_object_model 	= true;
	};
	
	client = {
		weather = {}
	};
	
	player = {
		respawntime = 2000;
		talkdistance = 100;
	};
	
	global = {
		timescale = 1.0;
		weather = {
			-- ToDo: Make this scary
			hour_00 = {
				sky_gradient = { 
					topr = 0;
					topg = 100;
					topb = 196;
					botr = 136;
					botg = 170;
					botb = 212 
				};
				farclip_distance = 200;
				fog_distance = 100;
			};
				
			hour_12 = {
				sky_gradient = { 
					topr = 0;
					topg = 100;
					topb = 196;
					botr = 136;
					botg = 170;
					botb = 212 
				};
				farclip_distance = 500;
				fog_distance = 100;
			};
			
			hour_18 = {
				sky_gradient = { 
					topr = 0;
					topg = 100;
					topb = 196;
					botr = 136;
					botg = 170;
					botb = 212 
				};
				farclip_distance = 300;
				fog_distance = 100;
			};
		};
	};
	

	statistics = {
		masterserver_url = "http://dayz.jusonex.net/statistics.php";
	}
}

function Core:applyDefaultConfig()
	self.m_ClientConfig = defaultConfig["client"]
	
	for group, info in pairs(defaultConfig) do	
		if group ~= "client" then
			for key, value in kspairs(info) do
				if self.m_MainConfig:get(group, key) == nil then
					self.m_MainConfig:set(group, key, value)
				end
			end
		end
	end
	
	self.m_ClientConfig["weather"] = self.m_MainConfig:get("global", "weather")
end
