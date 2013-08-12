-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/manager/PlayerManager.lua
-- *  PURPOSE:     Player manager
-- *
-- ****************************************************************************
PlayerManager = inherit(Singleton)

function PlayerManager:constructor()
	enew(localPlayer, LocalPlayer)
end
