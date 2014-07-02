local T, C, L = unpack(Tukui)

local function CreateOverlay(f)
	if f.overlay then return end

	local overlay = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
	overlay:ClearAllPoints()
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(C["media"].normTex)
	overlay:SetVertexColor(unpack(C["media"].bordercolor))
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "InnerBorder" or nil, f)
		border:Point("TOPLEFT", T.mult, -T.mult)
		border:Point("BOTTOMRIGHT", -T.mult, T.mult)
		border:SetBackdrop({
			edgeFile = C["media"].blank, 
			edgeSize = T.mult, 
			insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
		})
		border:SetBackdropBorderColor(0,0,0)
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "OuterBorder" or nil, f)
		border:Point("TOPLEFT", -T.mult, T.mult)
		border:Point("BOTTOMRIGHT", T.mult, -T.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = C["media"].blank, 
			edgeSize = T.mult, 
			insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
		})
		border:SetBackdropBorderColor(0,0,0)
		f.oborder = border
	end
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
		
	local sh = T.Scale(h)
	local sw = T.Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, T.Scale(x), T.Scale(y))
	f:SetBackdrop({
	  bgFile = C["media"].blank, 
	  edgeFile = C["media"].blank, 
	  tile = false, tileSize = 0, edgeSize = T.mult, 
	  insets = { left = -T.mult + T.mult + T.mult, right = -T.mult + T.mult + T.mult, top = -T.mult +  T.mult + T.mult, bottom = -T.mult + T.mult + T.mult}
	})
	
	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb)
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end


local function Animate( self, x, y, duration )
	self.anim = self:CreateAnimationGroup( "Move_In" )
	self.anim.in1 = self.anim:CreateAnimation( "Translation" )
	self.anim.in1:SetDuration( 0 )
	self.anim.in1:SetOrder( 1 )
	self.anim.in2 = self.anim:CreateAnimation( "Translation" )
	self.anim.in2:SetDuration( duration )
	self.anim.in2:SetOrder( 2 )
	self.anim.in2:SetSmoothing( "OUT" )
	self.anim.out1 = self:CreateAnimationGroup( "Move_Out" )
	self.anim.out2 = self.anim.out1:CreateAnimation( "Translation" )
	self.anim.out2:SetDuration( duration )
	self.anim.out2:SetOrder( 1 )
	self.anim.out2:SetSmoothing( "IN" )
	self.anim.in1:SetOffset( T.Scale( x ), T.Scale( y ) )
	self.anim.in2:SetOffset( T.Scale( -x ), T.Scale( -y ) )
	self.anim.out2:SetOffset( T.Scale( x ), T.Scale( y ) )
	self.anim.out1:SetScript( "OnFinished", function() self:Hide() end )
end

local function FadeIn( frame )
	UIFrameFadeIn( frame, 1, frame:GetAlpha(), 1 )
end

local function FadeOut( frame )
	UIFrameFadeOut( frame, 0.8, frame:GetAlpha(), 0 )
end

local function SlideIn( self )
	if( not self.anim ) then
		Animate( self )
	end

	self.anim.out1:Stop()
	self:Show()
	self.anim:Play()
end

local function SlideOut( self )
	if( self.anim ) then
		self.anim:Finish()
	end

	self.anim:Stop()
	self.anim.out1:Play()
end


local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
	if not object.AddLogo then mt.AddLogo = AddLogo end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.Animate then mt.Animate = Animate end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
	if not object.SlideIn then mt.SlideIn = SlideIn end
	if not object.SlideOut then mt.SlideOut = SlideOut end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end