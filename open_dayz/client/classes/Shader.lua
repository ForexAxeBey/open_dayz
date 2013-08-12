-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Shader.lua
-- *  PURPOSE:     Shader base class, should not be instanciated outside of ShaderManager
-- *
-- ****************************************************************************
Shader = inherit(Object)

Shader.constructor 	= pure_virtual
Shader.set	 		= pure_virtual
Shader.get 			= pure_virtual
Shader.onClientRender = function() end
Shader.onClientPreRender = function() end