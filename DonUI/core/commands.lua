local T, C, L, G = unpack(Tukui)

local dps = function(msg)
	DisableAddOn("DonUI_Raid_Healing"); 
	EnableAddOn("DonUI_Raid"); 
	ReloadUI();
end
SlashCmdList.dps = dps
SLASH_dps1 = "/dps"

local heal = function(msg)
	DisableAddOn("DonUI_Raid"); 
	EnableAddOn("DonUI_Raid_Healing"); 
	ReloadUI();
end
SlashCmdList.heal = heal
SLASH_heal1 = "/heal"