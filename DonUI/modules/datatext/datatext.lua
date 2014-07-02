local T, C, L, G = unpack(Tukui)
if C.DonUI.snappingDT then return end

-- datatext
local DataTextPosition = function(f, t, o)
	local left = TukuiInfoLeft
	local right = TukuiInfoRight
	local center = TukuiInfoCenter
	
	if o == 1 then
		t:ClearAllPoints()
		t:SetParent(left)
		t:SetHeight(left:GetHeight())
		t:SetPoint("LEFT", left, 30, 0)
		t:SetPoint('TOP', left)
		t:SetPoint('BOTTOM', left)
	elseif o == 2 then
		t:ClearAllPoints()
		t:SetParent(left)
		t:SetHeight(left:GetHeight())
		t:SetPoint('TOP', left)
		t:SetPoint('BOTTOM', left)
	elseif o == 3 then
		t:ClearAllPoints()
		t:SetParent(left)
		t:SetHeight(left:GetHeight())
		t:SetPoint("RIGHT", left, -30, 0)
		t:SetPoint('TOP', left)
		t:SetPoint('BOTTOM', left)
	elseif o == 4 then
		t:ClearAllPoints()
		t:SetParent(right)
		t:SetHeight(right:GetHeight())
		t:SetPoint("LEFT", right, 30, 0)
		t:SetPoint('TOP', right)
		t:SetPoint('BOTTOM', right)
	elseif o == 5 then
		t:ClearAllPoints()
		t:SetParent(right)
		t:SetHeight(right:GetHeight())
		t:SetPoint('TOP', right)
		t:SetPoint('BOTTOM', right)
	elseif o == 6 then
		t:ClearAllPoints()
		t:SetParent(right)
		t:SetHeight(right:GetHeight())
		t:SetPoint("RIGHT", right, -30, 0)
		t:SetPoint('TOP', right)
		t:SetPoint('BOTTOM', right)
	elseif o == 7 then
		t:ClearAllPoints()
		t:SetParent(center)
		t:SetHeight(center:GetHeight())
		t:SetPoint("LEFT", center, 30, 0)
		t:SetPoint('TOP', center)
		t:SetPoint('BOTTOM', center)
	elseif o == 8 then
		t:ClearAllPoints()
		t:SetParent(center)
		t:SetHeight(center:GetHeight())
		t:SetPoint('TOP', center)
		t:SetPoint('BOTTOM', center)
	elseif o == 9 then
		t:ClearAllPoints()
		t:SetParent(center)
		t:SetHeight(center:GetHeight())
		t:SetPoint("RIGHT", center, -30, 0)
		t:SetPoint('TOP', center)
		t:SetPoint('BOTTOM', center)
	else
		f:Hide()
		t:Hide()
	end
end

-- Tukui DataText List
local datatext = {
	"Guild",
	"Friends",
	"Gold",
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
	"CallToArms",
}

-- Overwrite & Update Show/Hide/Position of all Datatext
for _, data in pairs(datatext) do
	local t = "TukuiStat"
	local frame = _G[t..data]
	local text = _G[t..data.."Text"]

	if frame and frame.Option then
		DataTextPosition(frame, text, frame.Option)
	end
end