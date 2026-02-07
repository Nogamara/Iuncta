local _, addon = ...
local oUF = addon.oUF

local MANA_CLASSES = {
	DRUID = true,
	MAGE = true,
	PALADIN = true,
	PRIEST = true,
	SHAMAN = true,
	MONK = true,
	EVOKER = true,
	WARLOCK = true,
}

local function overrideDisplayPower()
	-- we only show mana
	return Enum.PowerType.Mana
end

local styleName = addon.unitPrefix .. 'Player'
oUF:RegisterStyle(styleName, function(self, unit)
	Mixin(self, addon.widgetMixin)
	local ufw = 284
	local ufh = 30
	local barTex = "Interface\\AddOns\\Inomena2\\assets\\bars\\Minimalist.tga"

	self:SetScript('OnEnter', addon.unitShared.ShowTooltip)
	self:SetScript('OnLeave', addon.unitShared.HideTooltip)
	self:RegisterForClicks('LeftButtonUp')
	self:SetSize(ufw, ufh)

	--addon.unitShared.AddShiftClick(self, unit)
	--addon.unitShared.AddMiddleClick(self)

	local HealthTempLoss = self:CreateBackdropStatusBar()
	HealthTempLoss:SetAllPoints()
	HealthTempLoss:SetReverseFill(true)
	HealthTempLoss:SetStatusBarTexture('UI-HUD-UnitFrame-Target-PortraitOn-Bar-TempHPLoss')

	local Health = self:CreateStatusBar()
	Health:SetPoint('LEFT')
	Health:SetPoint('TOPRIGHT', HealthTempLoss:GetStatusBarTexture(), 'TOPLEFT')
	Health:SetPoint('BOTTOMRIGHT', HealthTempLoss:GetStatusBarTexture(), 'BOTTOMLEFT')
	Health.colorClass = true
	Health.colorReaction = true
	Health.incomingHealOverflow = 1
	Health.TempLoss = HealthTempLoss
	Health:SetStatusBarTexture(barTex)
	self.Health = Health

	self.HealthPrediction = {}
	self.HealthPrediction.incomingHealOverflow = 1 -- don't let it escape bounds

	local HealingPrediction = Health:CreateStatusBar()
	HealingPrediction:SetPoint('TOP')
	HealingPrediction:SetPoint('BOTTOM')
	HealingPrediction:SetPoint('LEFT', Health:GetStatusBarTexture(), 'RIGHT')
	HealingPrediction:SetStatusBarColor(addon.colors.healing:GetRGBA())
	Health.HealingAll = HealingPrediction

	local DamageAbsorb = Health:CreateStatusBar()
	DamageAbsorb:SetPoint('TOP')
	DamageAbsorb:SetPoint('BOTTOM')
	DamageAbsorb:SetPoint('LEFT', HealingPrediction:GetStatusBarTexture(), 'RIGHT')
	DamageAbsorb:SetStatusBarColor(addon.colors.absorb:GetRGB())
	Health.DamageAbsorb = DamageAbsorb

	local HealAbsorb = Health:CreateStatusBar()
	HealAbsorb:SetPoint('TOP')
	HealAbsorb:SetPoint('BOTTOM')
	HealAbsorb:SetPoint('RIGHT', Health:GetStatusBarTexture())
	HealAbsorb:SetWidth(self:GetWidth())
	HealAbsorb:GetStatusBarTexture():SetAtlas('RaidFrame-Absorb-Overlay', false, nil, nil, 'REPEAT', 'REPEAT')
	HealAbsorb:GetStatusBarTexture():SetHorizTile(true)
	HealAbsorb:GetStatusBarTexture():SetVertTile(true)
	HealAbsorb:GetStatusBarTexture():SetVertexColor(0, 0, 0)
	HealAbsorb:SetReverseFill(true)
	Health.HealAbsorb = HealAbsorb

	local HealthValue = self:CreateText()
	HealthValue:SetPoint('RIGHT', -addon.SPACING, 0)
	HealthValue:SetJustifyH('RIGHT')
	self:Tag(HealthValue, '[|cff43ebe7+$>inomena:absorb<$|r ] [$>inomena:hpcur<$ / ][$>inomena:hpmax<$ \124 ][$>inomena:hpper<$|cff0090ff%|r]')

	-- need to render texts higher than all the healpred stuff
	HealthValue:GetParent():SetFrameLevel(Health:GetFrameLevel() + 5)

	local Status = self:CreateText()
	Status:SetPoint('LEFT', addon.SPACING, 0)
	Status:SetJustifyH('LEFT')
	self:Tag(Status, '[|cffffff00$>group<$|r ][inomena:dead][inomena:resting][inomena:resurrect]')

	if MANA_CLASSES[addon.PLAYER_CLASS] or true then
		local Power = self:CreateBackdropStatusBar()
		Power:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
		Power:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -2)
		Power:SetHeight(ufh)
		Power:SetStatusBarTexture(barTex)
		Power.colorPower = true
		Power.displayAltPower = true -- needed for display override to work
		--Power.GetDisplayPower = overrideDisplayPower
		self.Power = Power
		if true then
		local PowerValue = Power:CreateText()
		PowerValue:SetPoint('RIGHT', -addon.SPACING, 0)
		PowerValue:SetJustifyH('RIGHT')
		self:Tag(PowerValue, '[$>inomena:power<$ / ][inomena:powermax]')
		PowerValue:GetParent():SetFrameLevel(Power:GetFrameLevel() + 5)
		else
		local PowerPrediction = Power:CreateStatusBar()
		PowerPrediction:SetReverseFill(true)
		PowerPrediction:SetPoint('TOP')
		PowerPrediction:SetPoint('BOTTOM')
		PowerPrediction:SetPoint('RIGHT', Power:GetStatusBarTexture())
		PowerPrediction:SetStatusBarColor(0, 0, 0, 0.4) -- render as a shade
		Power.CostPrediction = PowerPrediction
		end

	end

	local Debuffs = self:CreateFrame()
	Debuffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, addon.SPACING)
	Debuffs:SetHeight(self:GetHeight() * 1.5)
	Debuffs.growthX = 'LEFT'
	Debuffs.initialAnchor = 'BOTTOMRIGHT'
	Debuffs.size = self:GetHeight() * 1.2
	Debuffs.spacing = addon.SPACING
	Debuffs.maxCols = 99 -- make sure it never wraps
	Debuffs.CreateButton = addon.unitShared.CreateAura
	Debuffs.PostUpdateButton = addon.unitShared.PostUpdateAura
	Debuffs.PostUpdate = addon.unitShared.PostUpdateAuras
	self.Debuffs = Debuffs

	local PrivateAuras = self:CreateFrame()
	PrivateAuras:SetPoint('BOTTOMRIGHT', Debuffs, 'BOTTOMLEFT', 1, 0) -- is this safe?
	PrivateAuras:SetSize(self:GetWidth(), Debuffs:GetHeight())
	PrivateAuras.size = Debuffs.size
	PrivateAuras.spacing = Debuffs.spacing
	PrivateAuras.growthX = Debuffs.growthX
	PrivateAuras.initialAnchor = Debuffs.initialAnchor
	PrivateAuras.maxCols = Debuffs.maxCols
	PrivateAuras.borderScale = 2.5
	self.PrivateAuras = PrivateAuras

	local RaidIcon = HealthValue:GetParent():CreateTexture('OVERLAY') -- higher parent
	RaidIcon:SetPoint('CENTER', self, 'TOP')
	RaidIcon:SetSize(24, 24)
	self.RaidTargetIndicator = RaidIcon
	
	--local f = CreateFrame("Frame", "nxPlayerFrame", UIParent)
	--f.bg = f:CreateTexture(nil, "BACKGROUND")
	--f.bg:SetColorTexture(0, 0, 0, 0.3)
	--f.bg:SetAllPoints(f)
	--f:SetSize(ufw-40, (ufh*2)+2)
	--f:SetPoint('TOPLEFT', self, -4, 4)
	--f:SetFrameStrata('LOW')
	--f:SetFrameLevel(1)
end)

oUF:SetActiveStyle(styleName)

local player = oUF:Spawn('player')
player:SetPoint('CENTER', -380, -200)
addon:PixelPerfect(player)

-- expose internally
addon.units.player = player
