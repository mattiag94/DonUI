local T, C, L, G = unpack(Tukui)


if C.DonUI.threebars == true then
	G.Panels.BottomPanelOverActionBars:SetPoint("TOPLEFT", TukuiBar4)
	G.Panels.BottomPanelOverActionBars:SetPoint("BOTTOMRIGHT", TukuiBar1)
	
	--------------------------------------------------------
	
	--local barHandler = CreateFrame("Frame", "RightBarHandler", UIParent)
	
	
	local bar = TukuiBar7
	bar:SetAlpha(1)
	MultiBarBottomRight:SetParent(bar)

	for i= 1, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:SetSize(T.buttonsize, T.buttonsize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("TOP", bar, 0, -T.buttonspacing)
		else
			b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
		end
		
		G.ActionBars.Bar7["Button"..i] = b
	end

	RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")


	---------------------------------
	G.ActionBars.Bar2:ClearAllPoints()
	
	G.ActionBars.Bar2:SetAlpha(1)
	G.ActionBars.Bar2:SetPoint("BOTTOM", TukuiInfoCenter, "TOP", 0, 3)
	-- G.ActionBars.Bar2.bg = CreateFrame("Frame", "TukuiBar2BG", TukuiInfoCenter)
	-- G.ActionBars.Bar2.bg:SetTemplate()
	-- G.ActionBars.Bar2.bg:Size((T.buttonsize * 12) + (T.buttonspacing * 13), (T.buttonsize * 3) + (T.buttonspacing * 4))
	-- G.ActionBars.Bar2.bg:Point("BOTTOM", TukuiInfoCenter, "TOP", 0, 2)
	-- G.ActionBars.Bar2.bg:SetFrameLevel(5)
	G.ActionBars.Bar2:SetFrameLevel(5)
	G.ActionBars.Bar2:Size((T.buttonsize * 12) + (T.buttonspacing * 13), (T.buttonsize * 3) + (T.buttonspacing * 4))
	InvTukuiActionBarBackground:Point("TOPLEFT", G.ActionBars.Bar2, "TOPLEFT", -2, 2)
	for i= 1, 12 do
			local b = _G["MultiBarBottomLeftButton"..i]
			local b2 = _G["MultiBarBottomLeftButton"..i-1]
			b:SetSize(T.buttonsize, T.buttonsize)
			b:ClearAllPoints()
			b:SetFrameStrata("BACKGROUND")
			b:SetFrameLevel(15)
			
			if i == 1 then
				b:SetPoint("TOPLEFT", TukuiBar2, T.buttonspacing, -T.buttonspacing)
			else
				b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
			end
		end

	G.ActionBars.Bar5:Width((T.buttonsize * 2) + (T.buttonspacing * 3))
	G.ActionBars.Bar7:Point("LEFT", G.ActionBars.Bar5, "LEFT", 0, 0)
	-- kill the show/hide button because they doesn't fit my new bar layout
	TukuiBar2Button:Kill()
	TukuiBar3Button:Kill()
	TukuiBar4Button:Kill()
	TukuiBar5ButtonTop:Kill()
	TukuiBar5ButtonBottom:Kill()
	
	-- hide unuseful action bars background
	G.ActionBars.Bar3:SetAlpha(0)
	
end