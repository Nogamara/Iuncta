local addonName, addon = ...

addon.PATH = ([[Interface\AddOns\%s\assets\]]):format(addonName)
addon.TEXTURE = [[Interface\ChatFrame\ChatFrameBackground]]
addon.GLOW = { -- backdrop
	edgeFile = addon.PATH .. 'glow', edgeSize = 4
}

-- modified version of AvantGarde to include cyrillic characters, by muleyo @ wowui discord
addon.FONT = addon.PATH .. 'FRIZQT__.ttf'