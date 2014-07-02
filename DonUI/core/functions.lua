local T, C, L, G = unpack(Tukui)

hooksecurefunc(T, "PostNamePosition", function(self)
	self.Name:ClearAllPoints()
	self.Name:Point("TOPLEFT", self.Health, "TOPLEFT", 2, 0)
end)

T.PostCreateAura = function(self, button)
	button:SetTemplate("Default")
	
	-- if self.raid ~= true then
		button.remaining = T.SetFontString(button, C["media"].font, C["unitframes"].auratextscale, "THINOUTLINE")
		button.remaining:Point("CENTER", 1, 0)
	-- end
	
	button.cd.noOCC = true -- hide OmniCC CDs, because we  create our own cd with CreateAuraTimer()
	button.cd.noCooldownCount = true -- hide CDC CDs, because we create our own cd with CreateAuraTimer()
	
	button.cd:SetReverse()
	button.icon:Point("TOPLEFT", 2, -2)
	button.icon:Point("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count:Point("BOTTOMRIGHT", 3, 3)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(C["media"].font, 9, "THICKOUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	--if self.raid ~= true then
		button.remaining:SetParent(button.overlayFrame)
	--end
	
	button.Glow = CreateFrame("Frame", nil, button)
	button.Glow:Point("TOPLEFT", button, "TOPLEFT", -3, 3)
	button.Glow:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
	button.Glow:SetFrameStrata("BACKGROUND")	
	button.Glow:SetBackdrop{edgeFile = C["media"].glowTex, edgeSize = 3, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	button.Glow:SetBackdropColor(0, 0, 0, 0)
	button.Glow:SetBackdropBorderColor(0, 0, 0)
	
	local Animation = button:CreateAnimationGroup()
	Animation:SetLooping("BOUNCE")

	local FadeOut = Animation:CreateAnimation("Alpha")
	FadeOut:SetChange(-.9)
	FadeOut:SetDuration(.6)
	FadeOut:SetSmoothing("IN_OUT")

	button.Animation = Animation
end

T.PostUpdateAura = function(self, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, icon.filter)
	if icon then
		if(icon.filter == "HARMFUL") then
			if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
				icon.icon:SetDesaturated(true)
				icon:SetBackdropBorderColor(unpack(C.media.bordercolor))
			else
				local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
				icon.icon:SetDesaturated(false)
				icon:SetBackdropBorderColor(color.r * 0.8, color.g * 0.8, color.b * 0.8)
			end
		else
			if (isStealable or ((T.myclass == "MAGE" or T.myclass == "PRIEST" or T.myclass == "SHAMAN") and dtype == "Magic")) and not UnitIsFriend("player", unit) then
				if not icon.Animation:IsPlaying() then
					icon.Animation:Play()
				end
			else
				if icon.Animation:IsPlaying() then
					icon.Animation:Stop()
				end
			end
		end
		
		if duration and duration > 0 then
			if C["unitframes"].auratimer == true and self.raid ~= true then
				icon.remaining:Show()
			else
				icon.remaining:Hide()
			end
		else
			icon.remaining:Hide()
		end
	 
		icon.duration = duration
		icon.timeLeft = expirationTime
		icon.first = true
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

T.createAuraWatch = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 2, -5)
	auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 2)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = T.CreateAuraWatchIcon

	if (not C["unitframes"].auratimer) then
		auras.hideCooldown = true
	end

	local buffs = {}

	if (T.buffids["ALL"]) then
		for key, value in pairs(T.buffids["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if (T.buffids[T.myclass]) then
		for key, value in pairs(T.buffids[T.myclass]) do
			tinsert(buffs, value)
		end
	end

	-- "Cornerbuffs"
	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon:Width(10*C["unitframes"].gridscale)
			icon:Height(10*C["unitframes"].gridscale)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(GetSpellTexture(spell[1]))

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(C["media"].uffont, 8*C["unitframes"].gridscale, "THINOUTLINE")
			count:SetPoint("CENTER", unpack(T.countOffsets[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end
	
	self.AuraWatch = auras
end

T.tremovebyval = function(tab, val)
	if tab then
		for k,v in pairs(tab) do
			if(v==val) then
				table.remove(tab, k);
				return true;
			end
		end
	end
   return false;
 end
 
 T.findInTable = function(tab, val)
   for k,v in pairs(tab) do
     if(v==val) then
       return true;
     end
   end
   return false;
 end
 
-- function to update power text on unit frames
T.PostUpdatePower = function(power, unit, min, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = T.UnitColor.power[pToken]
	local _, class = UnitClass(unit)
	local colors = {
		{unpack(self.colors.class[class])},
		{255/255, 147/255, 5/255},
		{255/255, 0/255, 0/255}
	}
	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end
	if unit == "player" then
		if (min/max)>0.9 then
			power:SetStatusBarColor(unpack(colors[1]))
		elseif (min/max)<0.9 and (min/max) > 0.5 then
			power:SetStatusBarColor(unpack(colors[2]))
		elseif (min/max)<0.5 then
			power:SetStatusBarColor(unpack(colors[3]))
		end
	end
	if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), ShortValue(max - (max - min)))
					end
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%%", floor(min / max * 100))
					end
				elseif (unit and unit:find("arena%d")) or unit == "focus" or unit == "focustarget" then
					power.value:SetText(ShortValue(min))
				else
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%% |cffD7BEA5-|r %d", floor(min / max * 100), max - (max - min))
					end
				end
			else
				power.value:SetText(max - (max - min))
			end
		else
			if unit == "pet" or unit == "target" or unit == "focus" or unit == "focustarget" or (unit and unit:find("arena%d")) then
				power.value:SetText(ShortValue(min))
			else
				power.value:SetText(min)
			end
		end
	end
	if self.Name then
		if unit == "target" then T.PostNamePosition(self, power) end
	end
end