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
		weather = {
			-- ToDo: Make this scary
			hour_01 = {
				sky_gradient = { 0, 100, 196, 136, 170, 212 };
				farclip_distance = 100;
				fog_distance = 100;
			};
			
			hour_12 = {
				sky_gradient = { 0, 100, 196, 136, 170, 212 };
				farclip_distance = 50;
				fog_distance = 100;
			};

			hour_24 = {
				sky_gradient = { 0, 100, 196, 136, 170, 212 };
				farclip_distance = 100;
				fog_distance = 100;
			};
		}
	};
	
	player = {
		respawntime = 2000;
	};
	
	global = {
		timescale = 1.0;
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
end
