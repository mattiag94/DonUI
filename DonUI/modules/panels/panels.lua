local T, C, L, G = unpack(Tukui)

-- Hiding lines, I hate them
G.Panels.BottomLeftVerticalLine:Hide()
G.Panels.BottomRightVerticalLine:Hide()
G.Panels.BottomLeftLine:Hide()
G.Panels.BottomRightLine:Hide()

-- Hiding cubes
if not C.chat.background then
	G.Panels.BottomLeftCube:Hide()
	G.Panels.BottomRightCube:Hide()
end

-- hiding minimap datatext
G.Panels.DataTextMinimapLeft:Hide()
G.Panels.DataTextMinimapRight:Hide()

-- moving something
G.Panels.DataTextLeft:ClearAllPoints()
G.Panels.DataTextLeft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 10)
G.Panels.DataTextRight:ClearAllPoints()
G.Panels.DataTextRight:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10)

-- Now i have to create a new datatext anchor, at bottom center
-- INFO CENTER (FOR STATS)
local icenter = CreateFrame("Frame", "TukuiInfoCenter", UIParent)
icenter:SetTemplate()
icenter:Size((T.buttonsize * 12) + (T.buttonspacing * 13) - 1, 23)
icenter:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 10)
icenter:SetFrameLevel(2)
icenter:SetFrameStrata("BACKGROUND")
G.Panels.DataTextCenter = icenter

-- move action bars 
G.ActionBars.Bar1:ClearAllPoints()
G.ActionBars.Bar1:SetPoint("BOTTOM", icenter, "TOP", 0, 2)
G.ActionBars.Bar4:ClearAllPoints()
G.ActionBars.Bar4:SetPoint("BOTTOM", icenter, "TOP", 0, 2)

if C.chat.background then
	G.Panels.LeftDataTextToActionBarLine:Hide()
	G.Panels.RightDataTextToActionBarLine:Hide()
	
	G.Panels.LeftChatBackground.hider = CreateFrame("Frame", "LeftChatHider", G.Panels.LeftChatBackground)
	G.Panels.LeftChatBackground:Size(T.InfoLeftRightWidth, 100)
	G.Panels.LeftChatBackground:Point("BOTTOM", G.Panels.DataTextLeft, "TOP", 0, 2)
	G.Panels.LeftChatBackground:Animate(-500, 0, 0.5)
	
	G.Panels.RightChatBackground.hider = CreateFrame("Frame", "RightChatHider", G.Panels.RightChatBackground)
	G.Panels.RightChatBackground:Size(T.InfoLeftRightWidth, 100)
	G.Panels.RightChatBackground:Point("BOTTOM", G.Panels.DataTextRight, "TOP", 0, 2)
	
	G.Panels.LeftChatTabsBackground:Kill()
	TukuiTabsLeftBackground = nil
	G.Panels.RightChatTabsBackground:Kill()
	TukuiTabsRightBackground = nil
	
	ChatFrame1:ClearAllPoints()
	ChatFrame1:Point("TOPLEFT", G.Panels.LeftChatBackground, "TOPLEFT", 2, -2)
	ChatFrame1:Point("BOTTOMRIGHT", G.Panels.LeftChatBackground, "BOTTOMRIGHT", -2, 2)
end


















