local T, C, L, G = unpack(Tukui)

-- Functions
local OnFinishedHoriz = function(self)
	self:SetScript("OnUpdate", nil)
	self.Sliding = false
end

local OnUpdateHoriz = function(self)
    local Point, RelativeTo, RelativePoint, XOfs, YOfs = self:GetPoint()
    
    if (self.Type == "Positive") then
        if (XOfs + self.SlideSpeed > self.EndX) then
            self:SetPoint(Point, RelativeTo, RelativePoint, XOfs + 1, YOfs)
        else
            self:SetPoint(Point, RelativeTo, RelativePoint, XOfs + self.SlideSpeed, YOfs)
        end
        
        if (XOfs >= self.EndX) then
            self:SetScript("OnUpdate", OnFinishedHoriz)
            self:Point(Point, RelativeTo, RelativePoint, self.EndX, YOfs)
        end
    else
        if (XOfs - self.SlideSpeed < self.EndX) then
            self:SetPoint(Point, RelativeTo, RelativePoint, XOfs - 1, YOfs)
        else
            self:SetPoint(Point, RelativeTo, RelativePoint, XOfs - self.SlideSpeed, YOfs)
        end
        
        if (XOfs <= self.EndX) then
            self:SetScript("OnUpdate", OnFinishedHoriz)
            self:Point(Point, RelativeTo, RelativePoint, self.EndX, YOfs)
        end
    end
end
local MoveFrameHorizontal = function(obj, x, speed)
    obj.SlideSpeed = speed
    if (x < 0) then
        obj.Type = "Negative"
    else
        obj.Type = "Positive"
    end
	obj.Sliding = true
    obj.EndX = select(4, obj:GetPoint()) + x
    obj:SetScript("OnUpdate", OnUpdateHoriz)
end

local OnFinished = function(self)
	self:SetScript("OnUpdate", nil)
	self.Sizing = false

	if self.Full then
		self:Height(self.Min)
	else
		self:Height(self.Max)
	end
end

local OnUpdate = function(self)
	local Height = self:GetHeight()
	
	if self.Full then
		if (Height - self.Speed <= self.Min) then
			self:SetHeight(Height - 1)
		else
			self:SetHeight(Height - self.Speed)
		end

		if (Height <= self.Min) then
			OnFinished(self)
			self.Full = false
		end
	else
		if (Height + self.Speed >= self.Max) then
			self:SetHeight(Height + 1)
		else
			self:SetHeight(Height + self.Speed)
		end

		if (Height >= self.Max) then
			OnFinished(self)
			self.Full = true
		end
	end
end

local StartSizing = function(self)
	if self.Sizing or self.Sliding or self.Anim then
		return
	end
	
	self:SetScript("OnUpdate", OnUpdate)
	self.Sizing = true
end

local SetFrameToGrow = function(self, min, max, speed, size)
	self.Sizing, self.OrigFull, self.Min, self.Max, self.Speed = false, size, min, max, speed
	self.Full = self.OrigFull
	
	local enter, oexit
	if self.OrigFull == false then
		enter = false
		oexit = true
	else
		enter = true
		oexit = false
	end
	--self:SetScript("OnMouseDown", StartSizing) -- For clicking
	self:SetScript("OnEnter", function(self) StartSizing(self) self.Full = enter end)
	self:SetScript("OnLeave", function(self) StartSizing(self) self.Full = oexit end)
end

-- Expand/Open animation
local OnExpandFinished = function(self)
	self:SetScript("OnUpdate", nil)
	
	if self.Minimized then
		self:SetHeight(self.NormalHeight)
		self:SetWidth(self.NormalWidth)
	end
end

local Open = function(self)
	self.Anim = true
	local CurHeight = self:GetHeight()
	local MaxHeight = self.NormalHeight
	
	local CurWidth = self:GetWidth()
	local MaxWidth = self.NormalWidth
	
	if (CurWidth < MaxWidth) then
		if (CurWidth + self.MoveSpeed > MaxWidth) then
			self:SetWidth(CurWidth + 1)
		else
			self:SetWidth(CurWidth + self.MoveSpeed)
		end
	else
		if (CurHeight < MaxHeight) then
			if (CurHeight + self.MoveSpeed > MaxHeight) then
				self:SetHeight(CurHeight + 1)
			else
				self:SetHeight(CurHeight + self.MoveSpeed)
			end
		else
			OnExpandFinished(self)
			self.Anim = false
			self.Minimized = false
		end
	end
end

local Close = function(self)
	self.Anim = true
	local CurHeight = self:GetHeight()
	local MaxHeight = self.MinHeight
	
	local CurWidth = self:GetWidth()
	local MaxWidth = self.MinWidth
	
	if (CurHeight > 1) then
		if (CurHeight - self.MoveSpeed < 1) then
			self:SetHeight(CurHeight - 1)
		else
			self:SetHeight(CurHeight - self.MoveSpeed)
		end
	else
		if (CurWidth > 1) then
			if (CurWidth - self.MoveSpeed < 1) then
				self:SetWidth(CurWidth - 1)
			else
				self:SetWidth(CurWidth - self.MoveSpeed)
			end
		else
			OnExpandFinished(self)
			self:Hide()
			self.Minimized = true
			self.Anim = false
		end
	end
end

local SetExpandParams = function(self, width, height, minwidth, minheight, speed)
	if (not self.ParamsSet) then
		self.NormalWidth = width
		self.MinWidth = minwidth
		self.NormalHeight = height
		self.MinHeight = minheight
		self.MoveSpeed = speed
		self.Anim = false
		self.ParamsSet = true
	end
end

local ToggleExpand = function(self, minimized)
	
	if self.Sizing or self.Sliding or self.Anim then
		return
	end
	
	if (not self.ParamsSet) then
		SetExpandParams(self, self:GetWidth(), self:GetHeight(), 2, 2, true, 10)
	end
	
	self.Minimized = minimized
	
	if self.Minimized then
		self:Show()
		self.hider:FadeIn()
		self:SetScript("OnUpdate", Open)
	else
		self.hider:FadeOut()
		self:SetScript("OnUpdate", Close)
	end
end

if not C.DonUI.snappingDT then 
	-- Example
	SetExpandParams(G.Panels.LeftChatBackground, G.Panels.LeftChatBackground:GetWidth(), G.Panels.LeftChatBackground:GetHeight(), 2, 2, 10) --  Set up some information on how we want to expand the frame
	SetExpandParams(G.Panels.RightChatBackground, G.Panels.RightChatBackground:GetWidth(), G.Panels.RightChatBackground:GetHeight(), 2, 2, 10) --  Set up some information on how we want to expand the frame

	-- ========================================================
	-- Chat Background
	-- ========================================================
	if C.DonUI.animType == "EXPAND" or C.DonUI.animType == "COLLAPSE" then
		G.Panels.LeftChatBackground.Visible = true
		G.Panels.DataTextLeft:SetScript("OnMouseDown", function(self, btn)
			if G.Panels.LeftChatBackground.Anim then
				return
			end

			if G.Panels.LeftChatBackground.Minimized then
				ToggleExpand(G.Panels.LeftChatBackground, true)
			else
				ToggleExpand(G.Panels.LeftChatBackground, false)
			end
		end)

		G.Panels.RightChatBackground.Visible = true
		G.Panels.DataTextRight:SetScript("OnMouseDown", function(self, btn)
			if G.Panels.RightChatBackground.Anim then
				return
			end

			if G.Panels.RightChatBackground.Minimized then
				ToggleExpand(G.Panels.RightChatBackground, true)
			else
				ToggleExpand(G.Panels.RightChatBackground, false)
			end
		end)
	elseif C.DonUI.animType == "SLIDE" then
		G.Panels.LeftChatBackground.Visible = true
		G.Panels.DataTextLeft:SetScript("OnMouseDown", function(self, btn)
			if G.Panels.LeftChatBackground.Sizing or G.Panels.LeftChatBackground.Sliding or G.Panels.LeftChatBackground.Anim then
				return
			end

			if G.Panels.LeftChatBackground.Visible then
				MoveFrameHorizontal(G.Panels.LeftChatBackground, -600, 10)
				G.Panels.LeftChatBackground.Visible = false
			else
				MoveFrameHorizontal(G.Panels.LeftChatBackground, 600, 10)
				G.Panels.LeftChatBackground.Visible = true
			end
		end)

		G.Panels.RightChatBackground.Visible = true
		G.Panels.DataTextRight:SetScript("OnMouseDown", function(self, btn)
			if G.Panels.RightChatBackground.Sizing or G.Panels.RightChatBackground.Sliding or G.Panels.RightChatBackground.Anim then
				return
			end

			if G.Panels.RightChatBackground.Visible then
				MoveFrameHorizontal(G.Panels.RightChatBackground, 600, 10)
				G.Panels.RightChatBackground.Visible = false
			else
				MoveFrameHorizontal(G.Panels.RightChatBackground, -600, 10)
				G.Panels.RightChatBackground.Visible = true
			end
		end)
	end
end
-- =================================================================
-- Action Bars (only with 3 bottom bars)
-- =================================================================

if C.DonUI.threebars == true then
	local Button = CreateFrame("Button", nil, UIParent)
	Button:Size(20, 100)
	Button:SetTemplate(true)
	Button:Point("RIGHT", 0, 0)
	Button:SetAlpha(0)
	Button:SetScript("OnEnter", function(Button) Button:SetAlpha(1) end)
	Button:SetScript("OnLeave", function(Button) Button:SetAlpha(0) end)

	Button.Text = Button:CreateFontString(nil, "OVERLAY")
	Button.Text:SetFont(C.media.font, 12)
	Button.Text:Point("CENTER", Button, 0, 0)
	Button.Text:SetText(">")
	Button.Text:SetShadowColor(0, 0, 0)
	Button.Text:SetShadowOffset(1.25, -1.25)

	local rbars = true
	Button:SetScript("OnClick", function(self)	
	if TukuiBar5.Sliding then return end
		if rbars == true then
			MoveFrameHorizontal(TukuiBar5, 200, 10)
			Button.Text:SetText("<")
			rbars = false
		else
			MoveFrameHorizontal(TukuiBar5, -200, 10)
			Button.Text:SetText(">")
			rbars = true
		end
	end)
end

SetFrameToGrow(G.Panels.LeftChatBackground, G.Panels.LeftChatBackground:GetHeight(), G.Panels.LeftChatBackground:GetHeight()+70, 4, false)
SetFrameToGrow(G.Panels.RightChatBackground, G.Panels.RightChatBackground:GetHeight(), G.Panels.RightChatBackground:GetHeight()+70, 4, false)
 
if  IsAddOnLoaded("Recount") then 
	Recount.MainWindow:SetResizable(true)
	SetFrameToGrow(Recount.MainWindow, Recount.MainWindow:GetHeight(), G.Panels.LeftChatBackground:GetHeight() + 7 + G.Panels.DataTextLeft:GetHeight(), 4, false)
end