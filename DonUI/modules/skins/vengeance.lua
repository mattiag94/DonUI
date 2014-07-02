local T, C, L, G = unpack(Tukui)

if not IsAddOnLoaded("VengeanceStatus") then return end

VengeanceStatus_StatusBar:SetTemplate("Default")
VengeanceStatus_StatusBar.Border:Kill()
VengeanceStatus_StatusBar:Width(select(1, unpack(T.Main)))