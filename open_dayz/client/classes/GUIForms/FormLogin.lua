-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/FormLogin.lua
-- *  PURPOSE:     Login form
-- *
-- ****************************************************************************
FormLogin = inherit(GUIForm)

function FormLogin:constructor()
	-- Call base class constructor
	GUIForm.constructor(self, screenWidth/2 - 600/2, screenHeight/2 - 383/2, 800, 383) -- 600

	-- Create GUI elements
	self.m_pWindow       = GUIWindow:new(0, 0, self.m_Width, self.m_Height, "Login", false, false, self)
	--self.m_pImageLogo    = GUIImage(203, 20, 256, 256, "files/images/serverlogo.png", self.m_pWindow)
	self.m_pEditUsername = GUIEdit:new(130, 131, 340, 37, self.m_pWindow)
	self.m_pEditPassword = GUIEdit:new(130, 179, 340, 37, self.m_pWindow)
	--self.m_pCheckLogin   = GUICheckbox(131, 226, 129, 18, "Save Login", self.m_pWindow)
	self.m_pButtonLogin  = GUIButton:new(130, 270, 153, 37, "Login", self.m_pWindow)

	-- Apply "properities"
	self.m_pEditUsername:setCaption("Username")
	self.m_pEditUsername:setFont("arial")
	self.m_pEditPassword:setCaption("Password")
	self.m_pEditPassword:setFont("tahoma")
	self.m_pEditPassword:setMasked()
	self.m_pEditUsername:setFontSize(1.5)
	self.m_pEditPassword:setFontSize(1.5)
	--self.m_pCheckLogin:setColorRGB(0, 0, 0, 127)
	self.m_pButtonLogin:setFont("tahoma")

	-- Add event handlers
	self.m_pButtonLogin.onLeftClick = bind(FormLogin.ButtonLogin_Click, self)

	-- Add rpc handlers
	--rpc_register("onClientPlayerLoggedIn", bind(FormLogin.RPC_onClientPlayerLoggedIn, self))

	showCursor(true)
end

function FormLogin:destructor()
end

function FormLogin.ButtonLogin_Click(loginForm)
	if loginForm.m_pEditUsername:getText() ~= "" and loginForm.m_pEditPassword:getText() ~= "" then
		rpc_call("onLogin", loginForm.m_pEditUsername:getText(), loginForm.m_pEditPassword:getText())
	else
		localPlayer:sendMessage("Please insert a valid username and password", 255, 0, 0)
	end
end

function FormLogin.RPC_onClientPlayerLoggedIn(self)
	-- Close us
	self:close()
	showCursor(false)
end
