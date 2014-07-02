local T, C, L, G = unpack( Tukui )
-- GeneralDockManager:Hide()
local function SetTabStyle( frame )
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat .. "Tab"]
	local color = RAID_CLASS_COLORS[T.myclass]
	local name = FCF_GetChatWindowInfo( id )
	_G[chat .. "TabText"]:Hide()
	tab:HookScript("OnEnter", function() _G[chat .. "TabText"]:FadeIn() end )
	tab:HookScript("OnLeave", function() _G[chat .. "TabText"]:FadeOut() end )
	
	if name == LOOT then
	end
	_G[chat .. "TabText"]:Point("CENTER", tab)
	_G[chat .. "TabText"]:SetTextColor(1, 1, 1)
	_G[chat .. "TabText"].SetTextColor = T.dummy
	
end

local function SetupChatStyle( self )
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format( "ChatFrame%s", i )]
		SetTabStyle( frame )
	end
end

TukuiChat:HookScript( "OnEvent", function( self, event, ... )
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format( "ChatFrame%s", i )]
		SetupChatStyle( chat )
	end
end )

BNToastFrame:HookScript( "OnShow", function( TukuiTooltipAnchor )
	TukuiTooltipAnchor:ClearAllPoints()
	TukuiTooltipAnchor:Point( "BOTTOMLEFT", G.Panels.LeftChatBackground, "TOPLEFT", 0, 6 )
end )

T.SetDefaultChatPosition = function( frame )
	if( frame ) then
		local id = frame:GetID()
		local name = FCF_GetChatWindowInfo( id )
		local fontSize = select( 2, frame:GetFont() )

		if( fontSize < 12 ) then
			FCF_SetChatWindowFontSize( nil, frame, 12 )
		else
			FCF_SetChatWindowFontSize( nil, frame, fontSize )
		end

		if( id == 1 ) then
			frame:ClearAllPoints()
			frame:Size(G.Panels.DataTextLeft:GetWidth() - 8, G.Panels.LeftChatBackground:GetHeight() -4)
			-- frame:SetHeight(G.Panels.DataTextLeft:GetHeight() -4)
			frame:Point( "BOTTOM", G.Panels.DataTextLeft, "TOP", 0, 7 )
			frame:Point( "TOP", G.Panels.LeftChatBackground, "TOP", 0, -5 )
			frame:SetParent(G.Panels.LeftChatBackground.hider)
			-- frame:SetClampRectInsets(420, -420, 0, 0);
		elseif( id == 4 and name == LOOT ) then
			if( not frame.isDocked ) then
				frame:ClearAllPoints()
				frame:Size(G.Panels.DataTextRight:GetWidth() - 8, G.Panels.RightChatBackground:GetHeight() -4)
				frame:Point( "BOTTOM", G.Panels.DataTextRight, "TOP", 0, 7 )
				frame:Point( "TOP", G.Panels.RightChatBackground, "TOP", 0, -5 )
				frame:SetParent(G.Panels.RightChatBackground.hider)
				if( C["chat"].justifyRight == true ) then
					frame:SetJustifyH( "RIGHT" )
				else
					frame:SetJustifyH( "LEFT" )
				end
			end
		else
			frame:ClearAllPoints()
			frame:Size(G.Panels.DataTextLeft:GetWidth() - 8, G.Panels.LeftChatBackground:GetHeight() -4)
			-- frame:SetHeight(G.Panels.DataTextLeft:GetHeight() -4)
			frame:Point( "BOTTOM", G.Panels.DataTextLeft, "TOP", 0, 7 )
			frame:Point( "TOP", G.Panels.LeftChatBackground, "TOP", 0, -5 )
			frame:SetParent(nil)
			frame:SetParent(G.Panels.LeftChatBackground.hider)
		end

		if( not frame.isLocked ) then
			FCF_SetLocked( frame, 1 )
		end
	end
end
hooksecurefunc( "FCF_RestorePositionAndDimensions", T.SetDefaultChatPosition )