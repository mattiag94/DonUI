local T, C, L, G = unpack(Tukui)

if not C.unitframes.enable then return end
if not C.DonUI.combatHide then return end

local untiframes = {"Player", "Target", "TargetTarget", "Pet", "Focus", "FocusTarget"}

local hider = CreateFrame("Frame", "DonUIHider", InvTukuiActionBarBackground)

for _, frame in pairs(untiframes) do 
	local self = _G["Tukui"..frame]
	
	self:SetParent(DonUIHider)
end
G.UnitFrames.Player.Castbar:SetParent(InvTukuiActionBarBackground)

hider:RegisterEvent("PLAYER_REGEN_ENABLED")
hider:RegisterEvent("PLAYER_REGEN_DISABLED")
hider:RegisterEvent("PLAYER_ENTERING_WORLD")
hider:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
		self:FadeOut()
	else
		self:FadeIn()
	end
end)




















