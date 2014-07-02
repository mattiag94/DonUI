local T, C, L, G = unpack( Tukui )
local CheckHover = function(f, a)
	local x0 = select(4, f:GetPoint())
	local y0 = select(5, f:GetPoint())
	
	local point = select(1, a:GetPoint())
	local x1 = select(4, a:GetPoint())
	local y1 = select(5, a:GetPoint())
	local w = a:GetWidth()
	local h = a:GetHeight()
	
	if point == "CENTER" then
		if (x0 <= (x1 + w/2) and x0 > (x1 - w/2)) and (y0 <= (y1 + h/2) and y0 >= (y1 - h/2)) then
			return true
		else
			return false
		end
	elseif point == "TOPLEFT" then
		if (x0 <= (x1 + w) and x0 > x1) and (y0 <= (y1) and y0 >= (y1 - h)) then
			return true
		else
			return false
		end
	elseif point == "BOTTOMLEFT" then
		if (x0 <= (x1 + w) and x0 > x1) and (y0 <= (y1+h) and y0 >= (y1)) then
			return true
		else
			return false
		end
	elseif point == "TOPRIGHT" then
		if (x0 <= (x1) and x0 > x1 - w) and (y0 <= (y1) and y0 >= (y1 - h)) then
			return true
		else
			return false
		end
	elseif point == "BOTTOMRIGHT" then
		if (x0 <= (x1) and x0 > x1 - w) and (y0 <= (y1+h) and y0 >= (y1)) then
			return true
		else
			return false
		end
	elseif point == "TOP" then
		if (x0 <= (x1 + w/2) and x0 > x1 - w/2) and (y0 <= (y1) and y0 >= (y1 - h)) then
			return true
		else
			return false
		end
	elseif point == "BOTTOM" then
		if (x0 <= (x1 + w/2) and x0 > x1 - w/2) and (y0 <= (y1 + h) and y0 >= (y1)) then
			return true
		else
			return false
		end
	elseif point == "LEFT" then
		if (x0 <= (x1 + w) and x0 > x1) and (y0 <= (y1 + h/2) and y0 >= (y1 - h/2)) then
			return true
		else
			return false
		end
	elseif point == "RIGHT" then
		if (x0 <= (x1) and x0 > x1 - w) and (y0 <= (y1 + h/2) and y0 >= (y1 - h/2)) then
			return true
		else
			return false
		end
	end
end
--[[
local f = CreateFrame("Frame", "DonUITestFrame", UIParent)
f:SetTemplate()
f:SetSize(200, 200)
f:Point("BOTTOMRIGHT", UIParent, "CENTER")

local b = CreateFrame("Frame", "FrameTest1", UIParent)
b:SetTemplate()
b:SetSize(130, 30)
b:Point("BOTTOM", 0, 300)
b:SetMovable(true)
b:SetScript("OnMouseDown", b.StartMoving)
b:SetScript("OnMouseUp", function()
	FrameTest1:StopMovingOrSizing()
	local r = CheckHover(b, f)
	if r then
		b:SetPoint("CENTER", f, "CENTER", 0, 0)
	end	
end)
b:SetClampedToScreen(true)
local tex = b:CreateTexture()
tex:SetTexture(1,0,0)
tex:SetAllPoints()]]

