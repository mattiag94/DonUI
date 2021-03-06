local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(Tukui)
if not C["unitframes"].enable == true then return end

local font2 = C["media"].uffont
local font1 = C["media"].font
local normTex = C["media"].normTex
local backdrop = {
	bgFile = C["media"].blank,
	insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult},
}

-- healer class that can dispel X debuff type
local filter = {
	["PRIEST"] = {
		["Magic"] = true,
		["Disease"] = true,
	},
	["SHAMAN"] = {
		["Magic"] = true,
		["Curse"] = true,
	},
	["PALADIN"] = {
		["Poison"] = true,
		["Magic"] = true,
		["Disease"] = true,
	},
	["DRUID"] = {
		["Magic"] = true,
		["Curse"] = true,
		["Poison"] = true,
	},
	["MONK"] = {
		["Poison"] = true,
		["Magic"] = true,
		["Disease"] = true,
	},
}

-- Custom aura filter.
local CustomFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)
	local role = T.CheckRole()
	
	if role == "HEALER" then
		-- if we are healer, we will only show debuffs that we can cleanse
		local class = T.myclass
		if filter[class][dtype] then
			return true
		else
			return false
		end
	else
		-- show everything if we are not a healer
		return true
	end
end

local function Shared(self, unit)
	self.colors = T.UnitColor
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	self:SetBackdrop({bgFile = C["media"].blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
	self:SetBackdropColor(0, 0, 0)
	self:CreateShadow()
	
	local health = CreateFrame("StatusBar", nil, self)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:Height(15)
	health:CreateBackdrop("Default")
	health:SetStatusBarTexture(normTex)
	self.Health = health

	health.value = health:CreateFontString(nil, "OVERLAY")
	health.value:SetPoint("RIGHT", health, -3, 1)
	health.value:SetFont(font2, 12, "THINOUTLINE")
	health.value:SetTextColor(1,1,1)
	health.value:SetShadowOffset(1, -1)
	self.Health.value = health.value
	
	health.PostUpdate = T.PostUpdateHealthRaid
	
	health.frequentUpdates = true
	
	if C.unitframes.unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(.3, .3, .3, 1)
	--	health.bg:SetVertexColor(.1, .1, .1, 1)		
	else
		health.colorDisconnected = true
		health.colorClass = true
		health.colorReaction = true			
	end
	
	local power = CreateFrame("StatusBar", nil, self)
	power:Height(3)
	power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -4)
	power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -4)
	power:SetStatusBarTexture(normTex)
	self.Power = power
	
	power.frequentUpdates = true
	power.colorDisconnected = true
	power:CreateBackdrop("Default")

	power.bg = self.Power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(normTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = 0.4
	self.Power.bg = power.bg
	
	if C.unitframes.unicolor == true then
		power.colorClass = true
		power.bg.multiplier = 0.1				
	else
		power.colorPower = true
	end
	
	local name = health:CreateFontString(nil, "OVERLAY")
    name:SetPoint("LEFT", health, "RIGHT", 10, -1)
	name:SetFont(C.media.uffont, C.media.ufsize, "THINOUTLINE")
	name:SetShadowOffset(1, -1)
	self:Tag(name, "[Tukui:namemedium]")
	self.Name = name
	
    local leader = health:CreateTexture(nil, "OVERLAY")
    leader:Height(12)
    leader:Width(12)
    leader:SetPoint("TOPLEFT", 0, 6)
	self.Leader = leader
	
	if C["unitframes"].showsymbols == true then
		local RaidIcon = health:CreateTexture(nil, "OVERLAY")
		RaidIcon:Height(18)
		RaidIcon:Width(18)
		RaidIcon:SetPoint("CENTER", self, "TOP")
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	local ReadyCheck = self.Power:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12)
	ReadyCheck:Width(12)
	ReadyCheck:SetPoint("CENTER")
	self.ReadyCheck = ReadyCheck

	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end
	
	if C["unitframes"].showsmooth == true then
		health.Smooth = true
		power.Smooth = true
	end
	
	if C["unitframes"].healcomm then
		local mhpb = CreateFrame("StatusBar", nil, self.Health)
		mhpb:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		mhpb:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		mhpb:SetWidth(150)
		mhpb:SetStatusBarTexture(normTex)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame("StatusBar", nil, self.Health)
		ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		ohpb:SetWidth(150)
		ohpb:SetStatusBarTexture(normTex)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	
	if T.myclass == "PRIEST" and C["unitframes"].weakenedsoulbar then
		local ws = CreateFrame("StatusBar", self:GetName().."_WeakenedSoul", power)
		ws:SetAllPoints(power)
		ws:SetStatusBarTexture(C.media.normTex)
		ws:GetStatusBarTexture():SetHorizTile(false)
		ws:SetBackdrop(backdrop)
		ws:SetBackdropColor(unpack(C.media.backdropcolor))
		ws:SetStatusBarColor(191/255, 10/255, 10/255)
		
		self.WeakenedSoul = ws
	end

	return self
end

local point = "LEFT"
local columnAnchorPoint = "TOP"
if C.unitframes.raidunitspercolumn == 0 then C.unitframes.raidunitspercolumn = 8 end

if C.unitframes.gridvertical then
	point = "TOP"
	columnAnchorPoint = "LEFT"
end

local function GetAttributes()
	return
	"TukuiRaid", 
	nil, 
	"custom [@raid6,exists] show;hide",
	"oUF-initialConfigFunction", [[
		local header = self:GetParent()
		self:SetWidth(header:GetAttribute("initial-width"))
		self:SetHeight(header:GetAttribute("initial-height"))
	]],
	"initial-width", T.Scale(66*C["unitframes"].gridscale),
	"initial-height", T.Scale(20),
	"showParty", true,
	"showRaid", true,
	"showPlayer", true,
	-- "showSolo", true, -- used to show raid unit in solo, for coding purpose
	"xoffset", T.Scale(3),
	"yOffset", T.Scale(-3),
	"point", point,
	"groupFilter", "1,2,3,4,5,6,7,8",
	"groupingOrder", "1,2,3,4,5,6,7,8",
	"groupBy", "GROUP",
	"maxColumns", math.ceil(40/C.unitframes.raidunitspercolumn),
	"unitsPerColumn", C.unitframes.raidunitspercolumn or 5,
	"columnSpacing", T.Scale(3),
	"columnAnchorPoint", columnAnchorPoint
end
T.RaidFrameAttributes = GetAttributes

if C.unitframes.showraidpets then
	local function GetPetAttributes()
		return
		"TukuiRaidPet", "SecureGroupPetHeaderTemplate", "custom [@raid6,exists] show;hide",
		"showPlayer", true,
		"showParty", true,
		"showRaid", true,
		--"showSolo", true, -- used to show raid pet in solo, for coding purpose
		"maxColumns", math.ceil(40/C.unitframes.raidunitspercolumn),
		"point", point,
		"unitsPerColumn", C.unitframes.raidunitspercolumn or 5,
		"columnSpacing", T.Scale(3),
		"columnAnchorPoint", columnAnchorPoint,
		"yOffset", T.Scale(-3),
		"xOffset", T.Scale(3),
		"initial-width", T.Scale(66*C["unitframes"].gridscale),
		"initial-height", T.Scale(50*C["unitframes"].gridscale),
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]]
	end
	T.RaidFramePetAttributes = GetPetAttributes
end

oUF:RegisterStyle("DonUIRaidDPS", Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("DonUIRaidDPS")

	local raid = self:SpawnHeader("DonUIRaidDPS", nil, "custom [@raid6,exists] hide;show", 
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", T.Scale(150),
		"initial-height", T.Scale(20),	
		"showParty", true, 
		"showPlayer", true, 
		"showRaid", true, 
		-- "showSolo", true,
		"groupFilter", "1,2,3,4,5,6,7,8", 
		"groupingOrder", "1,2,3,4,5,6,7,8", 
		"groupBy", "GROUP", 
		"yOffset", T.Scale(-10)
	)
	raid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -200)
	
	-- NEED TO BE COMPLETED
	--[[
	local pets = {} 
		pets[1] = oUF:Spawn("partypet1", "oUF_TukuiPartyPet1") 
		pets[1]:SetPoint("TOPLEFT", raid, "BOTTOMLEFT", 0, -45)
		pets[1]:Size(200, 40)
	for i =2, 4 do 
		pets[i] = oUF:Spawn("partypet"..i, "oUF_TukuiPartyPet"..i) 
		pets[i]:SetPoint("TOP", pets[i-1], "BOTTOM", 0, T.Scale(-45))
		pets[i]:Size(200, 40)
	end
	--]]
end)