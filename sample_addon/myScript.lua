addEventHandler("onResourceStart", resourceRoot,
	function()
		
		inv = Inventory:new(1, 2)
		inv:save()
		
		if getRandomPlayer() then
			getRandomPlayer():sendMessage("Hello world", 255, 0, 0)
			getRandomPlayer():sendMessage( _("Hello world", getRandomPlayer()), 255, 255, 0)
		end
		
		TranslationManager:getSingleton():loadTranslation("de", "server.de.po")
		
		outputDebugString(VEHICLE_COMPONENT_DOOR_LF)
	end
)

addEventHandler("onPlayerLoggedIn", root,
	function(username)
		source:setLocale("de")
		source:sendMessage("You're logged in now as "..username.."! Shut up!", 0, 255, 0)
		source:sendMessage(_("A house", source), 255, 255, 0)
	end
)
