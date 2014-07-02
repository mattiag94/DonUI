 local T, C, L, G = unpack(Tukui)

if not C.unitframes.enable then return end

T.Main, T.ToT, T.Focus, T.Boss = {(G.Panels.DataTextCenter:GetWidth()/2)-6, 45}, {(G.Panels.DataTextCenter:GetWidth()/2)-6, 26}, {200, 30}, {200, 29}
local untiframes = {"Player", "Target", "TargetTarget", "Pet", "Focus", "FocusTarget"}
local player, target

local castbarcolor = {
	["DEATHKNIGHT"] = { 196/255,  30/255,  60/255, 0.8 },
	["DRUID"]	    = { 255/255, 125/255,  10/255, 0.8 },
	["HUNTER"]	    = { 171/255, 214/255, 116/255, 0.8 },
	["MAGE"]	    = { 104/255, 205/255, 255/255, 0.8 },
	["PALADIN"]	    = { 245/255, 140/255, 186/255, 0.8 },
	["PRIEST"]	    = { 212/255, 212/255, 212/255, 0.8 },
	["ROGUE"]       = { 255/255, 243/255,  82/255, 0.8 },
	["SHAMAN"]	    = {	  41/255, 79/255, 155/255, 0.8 },
	["WARLOCK"]	    = { 148/255, 130/255, 201/255, 0.8 },
	["WARRIOR"]	    = { 199/255, 156/255, 110/255, 0.8 },
}

for _, frame in pairs(untiframes) do 
	
	local self = nil
	local unit = string.lower(frame)
	local color = RAID_CLASS_COLORS[T.myclass]

	if (unit == "player") then
		self = G.UnitFrames.Player
	elseif (unit == "target") then
		self = G.UnitFrames.Target
	elseif (unit == "targettarget") then
		self = G.UnitFrames.TargetTarget
	elseif (unit == "pet") then
		self = G.UnitFrames.Pet
	elseif (unit == "focus") then
		self = G.UnitFrames.Focus
	elseif (unit == "focustarget") then
		self = G.UnitFrames.FocusTarget
	end
	
	self:ClearAllPoints()
	self:SetBackdrop(nil)
	self:SetBackdropColor(0, 0, 0)

	if (unit == "player") then
		self:Point("BOTTOMLEFT", InvTukuiActionBarBackground, "TOPLEFT", 2,40)
		self:SetSize(unpack(T.Main))
		player = self
	elseif (unit == "target") then
		self:Point("BOTTOMRIGHT", InvTukuiActionBarBackground, "TOPRIGHT", -2,40)
		self:SetSize(unpack(T.Main))
		target = self
	elseif (unit == "targettarget") then
		self:Point("TOP", target, "BOTTOM", 0, -7)
		self:SetSize(unpack(T.ToT))
	elseif (unit == "pet") then
		self:Point("TOP", player, "BOTTOM", 0, -7)
		self:SetSize(unpack(T.ToT))
	elseif (unit == "focus") then
		self:Point("BOTTOMLEFT", InvTukuiActionBarBackground, "TOPLEFT", -140, 450)
		self:SetSize(unpack(T.Focus))
	elseif (unit == "focustarget") then
		self:Point("BOTTOM", TukuiFocus, "TOP", 0, 35)
		self:SetSize(unpack(T.Focus))
	end
	
	if self.shadow then
		self.shadow:Kill()
	end
	if self.panel then
		self.panel:Kill()
	end

	------------------------------------------------------------------------
	--	Player and Target units layout (mostly mirror'd)
	------------------------------------------------------------------------

	if (unit == "player") or (unit == "target") then
		local health = self.Health
		local power = self.Power
		local castbar = self.Castbar
		local portrait = TukuiPlayer.Portrait
		

		health.bg:SetTexture(0, 0, 0, 1)

		health:CreateBackdrop("Default")
		power:CreateBackdrop("Default")
		
		health:Height(30)
		health.value = T.SetFontString(health,  C.media.uffont, C.media.ufsize, "THINOUTLINE")
		health.value:Point("RIGHT", health, "RIGHT", -4, 1)
		
		power:Height(5)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -4)
		power.value = T.SetFontString(health,  C.media.uffont, C.media.ufsize, "THINOUTLINE")
		power.value:ClearAllPoints()
		power.value:Point("BOTTOMLEFT", health, "BOTTOMLEFT", 2, 2)
		-- power.PostUpdate = T.PostUpdatePower
		
		if C["unitframes"].unicolor == true then
			health:SetStatusBarColor(.150, .150, .150, 1)
			health.bg:SetVertexColor(0, 0, 0, 1)
			power.colorReaction = true
		end
		
		if C["unitframes"].charportrait == true then
			G.UnitFrames.Player.Portrait:ClearAllPoints()
			G.UnitFrames.Player.Portrait:Point("TOPRIGHT", G.UnitFrames.Player.Health, "TOPLEFT", -7, 0)
			G.UnitFrames.Player.Portrait:Point("BOTTOMRIGHT", G.UnitFrames.Player.Power, "BOTTOMLEFT", -7, 0)
			G.UnitFrames.Player.Portrait:Width(G.UnitFrames.Player.Portrait:GetHeight())
			G.UnitFrames.Player.Portrait:SetAlpha(1)
			G.UnitFrames.Player.Portrait.SetAlpha = T.dummy
			G.UnitFrames.Player.Portrait:SetFrameLevel(8)
			G.UnitFrames.Player.Portrait.SetFrameLevel = T.dummy
			G.UnitFrames.Player.Portrait:CreateBackdrop("Default")
			
			G.UnitFrames.Player.Health:ClearAllPoints()
			G.UnitFrames.Player.Health:SetPoint("TOPLEFT", 0,0)
			G.UnitFrames.Player.Health:SetPoint("TOPRIGHT")		
			
			G.UnitFrames.Target.Portrait:ClearAllPoints()
			G.UnitFrames.Target.Portrait:Point("TOPLEFT", G.UnitFrames.Target.Health, "TOPRIGHT", 7, 0)
			G.UnitFrames.Target.Portrait:Point("BOTTOMLEFT", G.UnitFrames.Target.Power, "BOTTOMRIGHT", 7, 0)
			G.UnitFrames.Target.Portrait:Width(G.UnitFrames.Target.Portrait:GetHeight())
			G.UnitFrames.Target.Portrait:SetAlpha(1)
			G.UnitFrames.Target.Portrait.SetAlpha = T.dummy
			G.UnitFrames.Target.Portrait:SetFrameLevel(8)
			G.UnitFrames.Target.Portrait.SetFrameLevel = T.dummy
			G.UnitFrames.Target.Portrait:CreateBackdrop("Default")
			
			G.UnitFrames.Target.Health:ClearAllPoints()
			G.UnitFrames.Target.Health:SetPoint("TOPLEFT", 0,0)
			G.UnitFrames.Target.Health:SetPoint("TOPRIGHT")		
		end
		-- player additional bars
		if (unit == "player") then
			if C.unitframes.classbar then
				self.TopBar = health
				if T.myclass == "MONK" then
					self.HarmonyBar:CreateBackdrop("Default")
					self.HarmonyBar:SetSize(unpack(T.Main))
					self.HarmonyBar:Height(8)
					for i = 1, 5 do
						if i == 5 then
							self.HarmonyBar[i]:Width(self.HarmonyBar:GetWidth()/5)
						else	
							self.HarmonyBar[i]:Width(self.HarmonyBar:GetWidth()/5-1)
						end
					end
					self.HarmonyBar:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					
					self.Statue:CreateBackdrop("Default")
					self.Statue:SetSize(unpack(T.Main))
					self.Statue:Height(8)
					self.Statue:Point("BOTTOMLEFT", self.HarmonyBar, "TOPLEFT", 0, 5)
					
					self.TopBar = self.Statue
				end
				if T.myclass == "WARRIOR" and C.unitframes.showstatuebar then
					self.Statue:CreateBackdrop("Default")
					self.Statue:SetSize(unpack(T.Main))
					self.Statue:Height(8)
					self.Statue:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					
					self.TopBar = self.Statue
				end
				if T.myclass == "PRIEST" then
					self.ShadowOrbsBar:CreateBackdrop("Default")
					self.ShadowOrbsBar:SetSize(unpack(T.Main))
					self.ShadowOrbsBar:Height(8)
					self.ShadowOrbsBar:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					self.Statue:CreateBackdrop("Default")
					self.Statue:SetSize(unpack(T.Main))
					self.Statue:Height(8)
					self.Statue:Point("BOTTOMLEFT", self.ShadowOrbsBar, "TOPLEFT", 0, 5)
					
					self.TopBar = self.Statue
				end
				if T.myclass == "SHAMAN" then
					local TotemBar = self.TotemBar
					for i = 1, 4 do
						TotemBar[i]:Width(select(1, unpack(T.Main))/4)
						TotemBar[i]:ClearAllPoints()
					end
					TotemBar[2]:Width(select(1, unpack(T.Main))/4- 3)
					TotemBar[2]:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					TotemBar[1]:Point("LEFT", TotemBar[2], "RIGHT", 1, 0)
					TotemBar[3]:Point("LEFT", TotemBar[1], "RIGHT", 1, 0)
					TotemBar[4]:Point("LEFT", TotemBar[3], "RIGHT", 1, 0)
					
					local bg = CreateFrame("Frame", nil, G.UnitFrames.Player)
					bg:Point("TOPLEFT", TotemBar[2], "TOPLEFT", 0, 0)
					bg:Point("BOTTOMRIGHT", TotemBar[4], "BOTTOMRIGHT", 0, 0)
					bg:CreateBackdrop()
					
					self.TopBar = bg
				end
				if T.myclass == "DEATHKNIGHT" then
					self.Runes:CreateBackdrop("Default")
					self.Runes:SetSize(unpack(T.Main))
					self.Runes:Height(8)
					self.Runes:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					for i = 1, 6 do
						self.Runes[i]:Width(self.Runes:GetWidth()/6)
						self.Runes[i]:Height(8)
						if (i == 1) then
							self.Runes[i]:Point("TOPLEFT", self.Runes, "TOPLEFT", 0, 0)
							self.Runes[i]:Point("BOTTOMLEFT", self.Runes, "BOTTOMLEFT", 0, 0)
							self.Runes[i]:Width(self.Runes:GetWidth()/6-4)
						else
							self.Runes[i]:Point("LEFT", self.Runes[i-1], "RIGHT", 1, 0)
						end
					end
					
					self.TopBar = self.Runes
				end
				if T.myclass == "PALADIN" then
					self.HolyPower:CreateBackdrop("Default")
					self.HolyPower:SetSize(unpack(T.Main))
					self.HolyPower:Height(8)
					for i = 1, 5 do
						self.HolyPower[i]:Width(self.HolyPower:GetWidth()/5)
					end
					self.HolyPower:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					self.Statue:CreateBackdrop("Default")
					self.Statue:SetSize(unpack(T.Main))
					self.Statue:Height(8)
					self.Statue:Point("BOTTOMLEFT", self.Statue, "TOPLEFT", 0, 5)
					
					self.TopBar = self.Statue
				end
				if T.myclass == "WARLOCK" then
					self.WarlockSpecBars:CreateBackdrop("Default")
					self.WarlockSpecBars:SetSize(unpack(T.Main))
					self.WarlockSpecBars:Height(8)
					for i = 1, 4 do
						self.WarlockSpecBars[i]:Width(self.WarlockSpecBars:GetWidth()/4)
					end
					self.WarlockSpecBars:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					
					self.TopBar = self.WarlockSpecBars
				end
				if T.myclass == "DRUID" then
					self.EclipseBar:CreateBackdrop("Default")
					self.EclipseBar:SetSize(unpack(T.Main))
					self.EclipseBar:Height(8)
					self.EclipseBar:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					
					local m = self.WildMushroom
					m:SetSize(unpack(T.Main))
					m:SetHeight(8)
					m:CreateBackdrop()
					m:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					for i = 1, 3 do
						m[i]:Height(8)
						if i == 1 then
							m[i]:Width(m:GetWidth()/3-3)
							m[i]:Point("LEFT", m, "LEFT", 0, 0)
						else
							m[i]:Width(m:GetWidth()/3)
							m[i]:Point("LEFT", m[i-1], "RIGHT", 1, 0)
						end
					end
					
					self.TopBar = self.EclipseBar
				end
				if T.myclass == "MAGE" then
					self.ArcaneChargeBar:CreateBackdrop("Default")
					self.ArcaneChargeBar:SetSize(unpack(T.Main))
					self.ArcaneChargeBar:Height(8)
					for i = 1, 4 do
						self.ArcaneChargeBar[i]:Width(self.ArcaneChargeBar:GetWidth()/4)
					end
					self.ArcaneChargeBar:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					
					self.RunePower:CreateBackdrop("Default")
					self.RunePower:SetSize(unpack(T.Main))
					self.RunePower:Height(8)
					for i = 1, 2 do
						self.RunePower[i]:Width(self.RunePower:GetWidth()/2)
					end
					self.RunePower:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 6)
					
					self.TopBar = self.RunePower
				end
				if T.myclass == "ROGUE" then
					local CP = self.ComboPointsBar
					CP:Width(unpack(T.Main))
					CP:Height(8)
					CP:ClearAllPoints()
					CP:CreateBackdrop()
					
					for i = 1, 5 do
						CP[i]:Height(8)
						-- CP[i]:SetStatusBarTexture(normTex)
						CP[i]:SetFrameLevel(CP:GetFrameLevel() + 1)
						if i == 1 then
							CP[i]:Width(CP:GetWidth() / 5 )
							CP[i]:Point("LEFT", CP, "LEFT", 1, 0)
						else
							CP[i]:Point("LEFT", CP[i-1], "RIGHT", 1, 0)
							CP[i]:Width(CP:GetWidth() / 5 -1)
						end					
					end
					CP:Point("BOTTOM", health, "TOP", 0, 6)
					
					self.TopBar = CP
				end
			end
			castbar:ClearAllPoints()
			castbar:Point("TOPLEFT", G.Panels.DataTextCenter, "TOPLEFT", 1, -1)
			castbar:Point("BOTTOMRIGHT", G.Panels.DataTextCenter, "BOTTOMRIGHT", -1, 1)
			
			if C["unitframes"].cbicons == true then
				castbar.button:ClearAllPoints()
				castbar.button:SetSize(castbar:GetHeight()+3, castbar:GetHeight()+3)
				castbar.button:Point("RIGHT", castbar, "LEFT", -6 ,0)
			end
			castbar:SetStatusBarColor(unpack(T.UnitColor["class"][T.myclass]))	
			
			castbar.time:ClearAllPoints()
			castbar.time:Point("RIGHT", castbar.bg, "RIGHT", -4, 0)
			castbar.time:SetTextColor(1, 1, 1)
			castbar.time:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
			
			castbar.Text:ClearAllPoints()
			castbar.Text:Point("LEFT", castbar.bg, "LEFT", 4, 0)
			castbar.Text:Point("RIGHT", castbar.time, "LEFT", -4, 0)
			castbar.Text:SetTextColor(1, 1, 1)
			castbar.Text:SetFont(C.media.uffont, C.media.ufsize, "MOCHROMEOUTLINE")
			
			castbar:CreateBackdrop("Default")
		
			castbar.PostCastStart = T.PostCastStart
			castbar.PostChannelStart = T.PostCastStart
			
			self.Combat:Kill()
			local combat = CreateFrame("Button", "CatFrame", UIParent)
			combat:Width(G.UnitFrames.Player.Portrait:GetWidth()/2 - 1 )
			combat:Height(G.UnitFrames.Player.Portrait:GetWidth()/2 - 1)
			combat:Point("BOTTOMRIGHT", health, "TOPLEFT", -7, 6)
			combat.texture =combat:CreateTexture(nil, 'BACKGROUND')
			combat.texture:SetAllPoints(combat);
			combat.texture:SetTexture([[Interface\AddOns\DonUI\media\texture\combat.tga]])
			combat:CreateBackdrop("Default")
			self.Combat = combat
			
			self.Leader:Kill()
			local leader = CreateFrame("Button", "CatFrame", UIParent)
			leader:Width(G.UnitFrames.Player.Portrait:GetWidth()/2 - 1)
			leader:Height(G.UnitFrames.Player.Portrait:GetWidth()/2 - 1)
			leader:Point("RIGHT", combat, "LEFT", -2, 0)
			leader.texture =leader:CreateTexture(nil, 'BACKGROUND')
			leader.texture:SetAllPoints(leader);
			leader.texture:SetTexture([[Interface\AddOns\DonUI\media\texture\leader.tga]])
			leader:CreateBackdrop("Default")
			self.Leader = leader
			
			self.MasterLooter:Kill()
			-- local looter = CreateFrame("Button", "CatFrame", UIParent)
			-- looter:Width(G.UnitFrames.Player.Portrait:GetWidth()/2-1)
			-- looter:Height(G.UnitFrames.Player.Portrait:GetWidth()/2-1)
			-- looter:Point("RIGHT", leader, "LEFT", -2, 0)
			-- looter.texture =looter:CreateTexture(nil, 'BACKGROUND')
			-- looter.texture:SetAllPoints(looter);
			-- looter.texture:SetTexture([[Interface\AddOns\DonUI\media\texture\masterLoot.tga]])
			-- looter:CreateBackdrop("Default")
			-- self.MasterLooter = looter
			
			--FlashInfo
			self.FlashInfo:Kill()

			-- pvp status text
			self.Status:Kill()
			
			-- exp Bar
			local o
			if T.level ~= MAX_PLAYER_LEVEL then
				local Experience = self.Experience
				local Resting = self.Resting
				o = Experience
				Experience:Size(G.Maps.Minimap:GetWidth()-4, 5)
				Experience:ClearAllPoints()
				
				Experience:Point("TOPLEFT", G.Maps.Minimap, "BOTTOMLEFT", 2, -5)
				
				Experience:SetAlpha(1)
				Experience:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
				Experience:HookScript("OnLeave", function(self) self:SetAlpha(1) end)
				Experience:CreateBackdrop("Default")
				
				Resting:SetTexture(nil)
			end
			
			-- Rep bar "EXPERIENCE NAME IS FAKE!"
			if T.level == MAX_PLAYER_LEVEL then
				local Experience = self.Reputation
				Experience:Size(G.Maps.Minimap:GetWidth()-4, 5)
				Experience:ClearAllPoints()
				Experience:Point("TOPLEFT", G.Maps.Minimap, "BOTTOMLEFT", 2, -5)
				Experience:SetAlpha(1)
				Experience:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
				Experience:HookScript("OnLeave", function(self) self:SetAlpha(1) end)
				Experience:CreateBackdrop("Default")
			end
		end
		if (unit == "target") then			
			local Name = self.Name
			Name:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
			Name:SetShadowColor(0, 0, 0)
			Name:SetShadowOffset(1.25, -1.25)
			
			castbar:ClearAllPoints()
			
			if(C["unitframes"].targetauras) then
				local buffs = self.Buffs
				local debuffs = self.Debuffs
				
				buffs:ClearAllPoints()
				buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
				debuffs:ClearAllPoints()
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", 0, 3)
				
				castbar:Point("BOTTOMLEFT", self.Debuffs, "TOPLEFT", 0, 10)
			else
				castbar:Point("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 10)
			end
			
			castbar:SetStatusBarColor(unpack(T.UnitColor["class"]["MAGE"]))	
			
			castbar:Width(G.UnitFrames.Target:GetWidth())
			castbar:Height(20)
			castbar.time:ClearAllPoints()
			castbar.time:Point("RIGHT", castbar.bg, "RIGHT", -4, 0)
			castbar.time:SetTextColor(1, 1, 1)
			castbar.time:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
			
			castbar.button:ClearAllPoints()
			castbar.button:Size(castbar:GetHeight()+4,castbar:GetHeight()+4)
			castbar.button:Point("LEFT", castbar.bg, "RIGHT", 5, 0)
			
			castbar.Text:ClearAllPoints()
			castbar.Text:Point("LEFT", castbar.bg, "LEFT", 4, 0)
			castbar.Text:Point("RIGHT", castbar.time, "LEFT", -4, 0)
			castbar.Text:SetTextColor(1, 1, 1)
			castbar.Text:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
			
			castbar:CreateBackdrop("Default")
		
			castbar.PostCastStart = T.PostCastStart
			castbar.PostChannelStart = T.PostCastStart
		end
	end
	
	-- ToT
	if (unit == "targettarget") then
	
		local health = self.Health
		local Name = self.Name
		
		-- Border for ToT
		health:CreateBackdrop("Default")
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Size(target.Health:GetWidth(), 2)
		power:Point("TOP", health, "BOTTOM", 0, -4)
		power:SetStatusBarTexture(C.media.normTex)
		
		-- Border for Power
		power:CreateBackdrop("Default")

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(C.media.normTex)
		powerBG.multiplier = 0.3
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			power.colorTapping = true
			power.colorClass = true
			power.colorReaction = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end
		
		self.Power = power
		self.Power.bg = powerBG
		
		self:EnableElement('Power')
		
		Name:ClearAllPoints()
		Name:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
		Name:Point("CENTER", health, "CENTER", 0, 1)
	end
	if (unit == "pet") then
	
		local health = self.Health
		local Name = self.Name
		
		-- Border for ToT
		health:CreateBackdrop("Default")
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Size(target.Health:GetWidth(), 2)
		power:Point("TOP", health, "BOTTOM", 0, -4)
		power:SetStatusBarTexture(C.media.normTex)
		
		-- Border for Power
		power:CreateBackdrop("Default")

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(C.media.normTex)
		powerBG.multiplier = 0.3
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			power.colorTapping = true
			power.colorClass = true
			power.colorReaction = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end
		
		self.Power = power
		self.Power.bg = powerBG
		
		self:EnableElement('Power')
		
		Name:ClearAllPoints()
		Name:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
		Name:Point("CENTER", health, "CENTER", 0, 1)
	end
	if (unit == "focus") then
		self.Name:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
		self.Power:CreateBackdrop("Default")
		self.Health:CreateBackdrop("Default")
		
		self.Power:ClearAllPoints()
		self.Power:Point("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)
		self.Power:Height(5)
		self.Power:Width(self.Health:GetWidth())
	end
	if (unit == "focustarget") then
		self.Name:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
		self.Power:CreateBackdrop("Default")
		self.Health:CreateBackdrop("Default")
		
		self.Power:ClearAllPoints()
		self.Power:Point("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)
		self.Power:Height(5)
		self.Power:Width(self.Health:GetWidth())
	end
	if (unit and unit:find("arena%d") and C["unitframes"].arena == true) or (unit and unit:find("boss%d") and C["unitframes"].showboss == true) then
		self.Power:CreateBackdrop("Default")
		self.Health:CreateBackdrop("Default")
		
		self.Name:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
		
		self.Power:ClearAllPoints()
		self.Power:Point("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)
		self.Power:Height(5)
		self.Power:Width(self.Health:GetWidth())
	end
end




















