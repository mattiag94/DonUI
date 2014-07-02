local C = {}


C.general = {
	autoscale = false,
	overridelowtohigh = false, -- If you wish to use the high resolution layout as low resolution user, set this to true.
	uiscale = .75, -- Changes the UIScale of the UI.
	bordercolor = { .3, .3, .3 }, -- Color of the border.
	blizzardreskin = false,
	unicolor = true,
	charportrait = true,
}

C.DonUI = {
	threebars = true,			-- 3 bars bottom, 2 left
	combatHide = false,			-- hide UFs when in combat
	snappingDT = false,
	animType = "COLLAPSE",
	pixel_layout = true,
}

if C.DonUI.pixel_layout then
	C.media = {
		font = [[Interface\Addons\DonUI\media\fonts\berlin.ttf]], -- general font of tukui
		dmgfont = [[Interface\AddOns\DonUI\media\fonts\pixel.ttf]], -- general font of dmg / sct
		uffont = [[Interface\AddOns\DonUI\media\fonts\pixel.ttf]],
		datatext_font = [[Interface\AddOns\DonUI\media\fonts\pixel.ttf]],
		en_pixelfont = [[Interface\Addons\DonUI\media\fonts\spun.ttf]],	
		ufsize = 15,
	}
else
	C.media = {
		font = [[Interface\Addons\DonUI\media\fonts\berlin.ttf]], -- general font of tukui
		dmgfont = [[Interface\AddOns\DonUI\media\fonts\stylus.ttf]], -- general font of dmg / sct
		uffont = [[Interface\AddOns\DonUI\media\fonts\agencyb.ttf]],
		datatext_font = [[Interface\Addons\DonUI\media\fonts\spun.ttf]],
		en_pixelfont = [[Interface\Addons\DonUI\media\fonts\spun.ttf]],	
		ufsize = 12,
	}
end

C.unitframes = {
	unicolor = true, -- Sets all health bar to grey and power bars to class color, set to false for class coloured health bars.
	showraidpets = false,
	targetpowerpvponly = false,
	charportrait = true,
}

C.layout = {
	bottommap = true,
}

C.datatext = {
	guild = 1,
	dur = 2,
	friends = 3,
	fps_ms = 4,
	system = 5,
	gold = 6,
	power = 7,
	wowtime = 8,
	currency = 0,
	bags = 9,
	dps_text = 0,
	hps_text = 0,
	haste = 0,
	crit = 0,
	avd = 0,
	armor = 0,
	hit = 0,
	mastery = 0,
	micromenu = 0,
	regen = 0,
	talent = 0,
	calltoarms = 0
}

C.chat = {
	background = true,
}

-- Implements our config into Tukui.
TukuiEditedDefaultConfig = C