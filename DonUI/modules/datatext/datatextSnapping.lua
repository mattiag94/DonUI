local T, C, L, G = unpack(Tukui)

if not C.DonUI.snappingDT then return end

C.datatext = {
	guild = 1,
	dur = 1,
	friends = 1,
	fps_ms = 1,
	system = 1,
	gold = 1,
	power = 1,
	wowtime = 1,
	currency = 1,
	bags = 1,
	dps_text = 1,
	hps_text = 1,
	haste = 1,
	crit = 1,
	avd = 1,
	armor = 1,
	hit = 1,
	mastery = 1,
	micromenu = 1,
	regen = 1,
	talent = 1,
	calltoarms = 0
}

local Sticky = LibStub("LibSimpleSticky-1.0")

local DataTextPosition = function(t, o)
	local left = TukuiInfoLeft
	local right = TukuiInfoRight
	local center = TukuiInfoCenter
	
	if o == 1 then
		t:ClearAllPoints()
		t:SetParent(left)
		t:SetPoint('LEFT', left, 3, 0)
	elseif o == 2 then
		t:ClearAllPoints()
		t:SetParent(left)
		t:SetPoint('CENTER', left)
	elseif o == 3 then
		t:ClearAllPoints()
		t:SetParent(left)
		t:SetPoint('RIGHT', left, -3, 0)
	elseif o == 4 then
		t:ClearAllPoints()
		t:SetParent(right)
		t:SetPoint("LEFT", right, 3, 0)
	elseif o == 5 then
		t:ClearAllPoints()
		t:SetParent(right)
		t:SetPoint('CENTER', right)
	elseif o == 6 then
		t:ClearAllPoints()
		t:SetParent(right)
		t:SetPoint("RIGHT", right, -3, 0)
	elseif o == 7 then
		t:ClearAllPoints()
		t:SetParent(center)
		t:SetPoint("LEFT", center, 3, 0)
	elseif o == 8 then
		t:ClearAllPoints()
		t:SetParent(center)
		t:SetPoint('CENTER', center)
	elseif o == 9 then
		t:ClearAllPoints()
		t:SetParent(center)
		t:SetPoint("RIGHT", center, -3, 0)
	end
end

-- Tukui DataText List
local datatext = {
	"Guild",
	"Friends",
	"FPS",
	"System",
	"Bags",
	"Gold",
	"Time",
	"Durability",
	"Heal",
	"Damage",
	"Power",
	"Haste",
	"Crit",
	"Avoidance",
	"Armor",
	"Currency",
	"Hit",
	"Mastery",
	"MicroMenu",
	"Regen",
	"Talent",
}

local anchors = {}
if not TukuiDataPerChar.datatextpos then
	TukuiDataPerChar.datatextpos = {}
end

local create = function()

	for _, data in pairs(datatext) do
		local t = "TukuiStat"
		local frame = _G[t..data]
		local text = _G[t..data.."Text"]

		if frame and  T.findInTable(TukuiDataPerChar.datatextpos, data) then
			
			local f = CreateFrame("Frame", t..data.."Anchor", UIParent)
			f:SetSize(G.Panels.DataTextLeft:GetWidth() /3 -2, G.Panels.DataTextLeft:GetHeight()-4)
			f:SetPoint("CENTER", DonUIMainAnchor, "CENTER", 0, 0)
			f:SetMovable(true)
			f:SetClampedToScreen(true)
			f.Option = frame.Option
			f.DT = data
			f.Snap = false
			f:SetScript("OnMouseDown", function(self) 
				f:StartMoving()
				Sticky:StartMoving(self, anchors, -5, -6, -6, -6)
			end)
			f:SetScript("OnMouseUp", function(self) 
				local r = select(1, Sticky:StopMoving(self))
				if r then
					T.tremovebyval(TukuiDataPerChar.datatextpos, self.DT)
					table.insert(TukuiDataPerChar.datatextpos, self.DT)
				else
					T.tremovebyval(TukuiDataPerChar.datatextpos, self.DT)
				end
				f:StopMovingOrSizing()
				frame.Moved = true
			end)
			
			previous = f
			local tex = previous:CreateTexture()
			tex:SetTexture(unpack(C.general.backdropcolor))
			tex:SetAllPoints()
			text:ClearAllPoints()
			text:SetParent(previous)
			text:SetHeight(previous:GetHeight())
			text:SetPoint("CENTER", previous)
		else
			if text then
				text:Hide()
			end
		end
		
		i = i + 1
	end
end

local createAnchor = function()
	for i = 1, 9 do
		local f = CreateFrame("Frame", "DonUIDTAnchor"..i, UIParent)
		f:SetSize(G.Panels.DataTextLeft:GetWidth() /3 -2, G.Panels.DataTextLeft:GetHeight()-4)
		-- f:SetTemplate()
		DataTextPosition(f, i)
		table.insert(anchors, f)
	end
end

local resetdt = function()
	TukuiDataPerChar.datatextpos = {}
	-- Overwrite & Update Show/Hide/Position of all Datatext
	local previous = nil
	local YOfs = G.Panels.DataTextLeft:GetHeight() + 10
	local i = 1

	local previous = CreateFrame("Frame", "DonUIMainAnchor", UIParent)
	previous:Point("BOTTOM", G.Panels.LeftChatBackground, "TOP", 0, 5)
	previous:SetSize(G.Panels.DataTextLeft:GetWidth() /3 -2, G.Panels.DataTextLeft:GetHeight())

	for _, data in pairs(datatext) do
		local t = "TukuiStat"
		local frame = _G[t..data]
		local text = _G[t..data.."Text"]

		if frame then
			text:Show()
			local y = i * YOfs
			local f = CreateFrame("Frame", t..data.."Anchor", UIParent)
			f:SetSize(G.Panels.DataTextLeft:GetWidth() /3 -2, G.Panels.DataTextLeft:GetHeight()-4)
			f:SetPoint("CENTER", DonUIMainAnchor, "CENTER", 0, y)
			f:SetMovable(true)
			f:SetClampedToScreen(true)
			f.Option = frame.Option
			f.DT = data
			f:SetScript("OnMouseDown", function(self) 
				f:StartMoving()
				Sticky:StartMoving(self, anchors, -5, -6, -6, -6)
			end)
			f:SetScript("OnMouseUp", function(self) 
				local r = select(1, Sticky:StopMoving(self))
				if r then
					T.tremovebyval(TukuiDataPerChar.datatextpos, self.DT)
					table.insert(TukuiDataPerChar.datatextpos, self.DT)
				else
					T.tremovebyval(TukuiDataPerChar.datatextpos, self.DT)
				end
				f:StopMovingOrSizing()
				frame.Moved = true
			end)
			
			previous = f
			local tex = previous:CreateTexture()
			tex:SetTexture(unpack(C.general.backdropcolor))
			tex:SetAllPoints()
			text:ClearAllPoints()
			text:SetParent(previous)
			text:SetHeight(previous:GetHeight())
			text:SetPoint("CENTER", previous)
		end
		i = i + 1
	end
end
local dthide = function()

	for _, data in pairs(datatext) do
		local t = "TukuiStat"
		local frame = _G[t..data]
		local text = _G[t..data.."Text"]
		local anchor = _G[t..data.."Anchor"]
		
		if frame then
			if not T.findInTable(TukuiDataPerChar.datatextpos, data) then
				frame:Hide()
				if text then
					text:Hide()
				end
				if anchor then
					anchor:Hide()
				end
			else
				-- frame:SetMovable(false)
				frame:EnableMouse(false)
			end
		end
	end
end
create()
createAnchor()

SlashCmdList.dtreset = resetdt
SLASH_dtreset1 = "/dtreset"

SlashCmdList.dthide = dthide
SLASH_dthide1 = "/dthide"










