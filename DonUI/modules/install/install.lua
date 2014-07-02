local T, C, L, G = unpack(Tukui)

local install = G.Install.Frame

local InstallSound = [[Interface\Addons\DonUI\media\sound\Install.mp3]]

if install ~= nil then
	local logo = CreateFrame("Button", "LogoFrame1", install)
	logo:Width(128)
	logo:Height(128)
	logo:Point("TOPRIGHT", install, "TOPLEFT", -5, -2)
	logo.texture =logo:CreateTexture(nil, 'BACKGROUND')
	logo.texture:SetAllPoints(logo);
	logo.texture:SetTexture([[Interface\AddOns\DonUI\media\texture\donUI.tga]])
	logo:CreateBackdrop("Default")
	
	local logo2 = CreateFrame("Button", "LogoFrame2", install)
	logo2:Width(128)
	logo2:Height(128)
	logo2:Point("TOPLEFT", install, "TOPRIGHT", 5, -2)
	logo2.texture =logo2:CreateTexture(nil, 'BACKGROUND')
	logo2.texture:SetAllPoints(logo2);
	logo2.texture:SetTexture([[Interface\AddOns\DonUI\media\texture\donUI.tga]])
	logo2:CreateBackdrop("Default")
end

local function positionsetup()
	-- reset saved variables on char
	TukuiDataPerChar = {}
	
	-- reset movable stuff into original position
	for i = 1, getn(T.AllowFrameMoving) do
		if T.AllowFrameMoving[i] then T.AllowFrameMoving[i]:SetUserPlaced(false) end
	end
end

local step0 = function()
	G.Install.Close:Show()
	G.Install.StatusBar:Hide()
	G.Install.Frame.Header:SetText("Welcome on DonUI!")
	G.Install.Frame.Text2:SetText("Hi "..T.myname.." welcome on DonUI "..T.DonVersion.."!")
	G.Install.Frame.Text3:SetText("Major changes in this version:\r\n \r\n -Unit Frames High Reso fully working \r\n -High reso three bottom bars layout fixed \r\n -Custom install module created")
	if IsAddOnLoaded("DonUI_Raid_Healing") and IsAddOnLoaded("DonUI_Raid") then
		G.Install.Frame.Text4:SetText("It seems that you have both raid layout addons active, please choose your role.\r\n \r\n Have fun with DonUI!")
		G.Install.Option1:Show()

		G.Install.Option1.Text:SetText("Healer")
		G.Install.Option2.Text:SetText("DPS - Tank")

		G.Install.Option1:SetScript("OnClick", function()
			install:Hide()
			local ms = GetCVar("gxMultisample")
			if ms ~= "1" then
				SetCVar("gxMultisample", 1)
				RestartGx()
			end
			DisableAddOn("DonUI_Raid")
			positionsetup()
			T.ChatSetup()
			PlaySoundFile(InstallSound)
			TukuiDataPerChar.install = true
			ReloadUI()
		end)
		G.Install.Option2:SetScript("OnClick", function()
			install:Hide()
			local ms = GetCVar("gxMultisample")
			if ms ~= "1" then
				SetCVar("gxMultisample", 1)
				RestartGx()
			end
			DisableAddOn("DonUI_Raid_Healing")
			positionsetup()
			T.ChatSetup()
			PlaySoundFile(InstallSound)
			TukuiDataPerChar.install = true
			ReloadUI()
		end)
	else
		G.Install.Frame.Text4:SetText("In order to have your UI fully functional press the Install UI button below. \r\n \r\n Have fun with DonUI!")
	
		-- G.Install.Frame.Text4:SetText("Enjoy DonUI!")

		G.Install.Option1:Show()

		G.Install.Option1.Text:SetText("Close")
		G.Install.Option2.Text:SetText("Install UI")

		G.Install.Option1:SetScript("OnClick", function() install:Hide() end)
		G.Install.Option2:SetScript("OnClick", function()
			install:Hide()
			local ms = GetCVar("gxMultisample")
			if ms ~= "1" then
				SetCVar("gxMultisample", 1)
				RestartGx()
			end
			positionsetup()
			T.ChatSetup()
			PlaySoundFile(InstallSound)
			TukuiDataPerChar.install = true
			ReloadUI()
		end)
	end
end

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	-- create empty saved vars if they doesn't exist.
	if (TukuiData == nil) then TukuiData = {} end
	if (TukuiDataPerChar == nil) then TukuiDataPerChar = {} end

	if T.screenwidth < 1200 then
			SetCVar("useUiScale", 0)
			T.ShowPopup("TUKUIDISABLE_UI")
	else		
		-- install default if we never ran Tukui on this character.
		if not TukuiDataPerChar.install or ( IsAddOnLoaded("DonUI_Raid_Healing") and IsAddOnLoaded("DonUI_Raid")) then			
			install:Show() step0()
		end
	end
		
	if IsAddOnLoaded("Tukui_Raid") or IsAddOnLoaded("Tukui_Raid_Healing") then
		-- stupid protection because I know lots of peoples will not read our blog or the changelog
		if IsAddOnLoaded("Tukui_Raid") then
			DisableAddOn("Tukui_Raid")
		end
		
		if IsAddOnLoaded("Tukui_Raid_Healing") then
			DisableAddOn("Tukui_Raid_Healing")
		end
		
		T.ShowPopup("TUKUI_DISABLE_OLD_ADDONS")
	end
end)

SLASH_RESETUI1 = "/resetui"
SlashCmdList.RESETUI = function() install:Show() step0() end

SLASH_YY1 = "/yy"
SlashCmdList.YY = function() TukuiDataPerChar = {} ReloadUI() end
