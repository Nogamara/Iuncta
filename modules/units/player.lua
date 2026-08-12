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
	local barTex = "Interface\\AddOns\\Iuncta\\assets\\bars\\Minimalist.tga"

	self:SetScript('OnEnter', addon.unitShared.ShowTooltip)
	self:SetScript('OnLeave', addon.unitShared.HideTooltip)
	self:RegisterForClicks('LeftButtonUp')
	self:SetSize(ufw, ufh)

	-- addon.unitShared.AddShiftClick(self, unit)
	-- addon.unitShared.AddMiddleClick(self)

	self:RegisterEvent('PLAYER_REGEN_DISABLED', function () addon.inCombat = true end, true)
	self:RegisterEvent('PLAYER_REGEN_ENABLED', function () addon.inCombat = false end, true)

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
	self:Tag(Status, '[|cffffff00$>group<$|r ][inomena:dead][inomena:resting][inomena:resurrect][$>inomena:combat<$]')

	if MANA_CLASSES[addon.PLAYER_CLASS] or true then
		-- local Power = self:CreateBackdropStatusBar()
		local Power = self:CreateBackdropStatusBarForPower('player')
		Power:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
		Power:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -2)
		Power:SetHeight(ufh)
		Power:SetStatusBarTexture(barTex)
		Power.colorPower = true
		Power.displayAltPower = true -- needed for display override to work
		-- Power.GetDisplayPower = overrideDisplayPower
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

	local Buffs = self:CreateAuras({
		-- TODO: set limit of how many total
		layoutLimit = self:GetWidth() - (addon.SPACING * 2),
		growthX = 'RIGHT',
		growthY = 'DOWN',
		initialAnchor = 'TOPLEFT',
	})
	Buffs:SetPoint('CENTER')
	Buffs.disableCooldownText = true -- custom option
	Buffs.elementSpacing = addon.SPACING
	Buffs.lineSpacing = addon.SPACING
	Buffs.tooltipAnchor = 'ANCHOR_TOPRIGHT'
	Buffs.tooltipHideInCombat = true -- TBD
	Buffs.tooltipOffsetX = 1
	Buffs.tooltipOffsetY = 3
	Buffs.size = self:GetHeight() - (addon.SPACING * 2)
	Buffs.PostCreateButton = addon.unitShared.PostCreateAura
	Buffs:AddGroup('HELPFUL|EXTERNAL_DEFENSIVE')
	Buffs:AddGroup('HELPFUL|BIG_DEFENSIVE|!EXTERNAL_DEFENSIVE')

	local Debuffs = self:CreateAuras({
		growthX = 'LEFT',
		growthY = 'UP', -- default
		initialAnchor = 'BOTTOMRIGHT',
	})
	Debuffs:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, addon.SPACING)
	Debuffs.elementSpacing = addon.SPACING
	Debuffs.lineSpacing = addon.SPACING
	Debuffs.showCount = true
	Debuffs.size = self:GetHeight() * 1.2
	Debuffs.tooltipAnchor = 'ANCHOR_TOPLEFT'
	Debuffs.tooltipOffsetX = -1
	Debuffs.tooltipOffsetY = 3
	Debuffs.PostCreateButton = addon.unitShared.PostCreateAura
	Debuffs:AddGroup('HARMFUL')

	addon.unitShared.CreateDispelOverlay(self, true)

	local RaidIcon = HealthValue:GetParent():CreateTexture('OVERLAY') -- higher parent
	RaidIcon:SetPoint('CENTER', self, 'TOP')
	RaidIcon:SetSize(24, 24)
	self.RaidTargetIndicator = RaidIcon
end)

oUF:SetActiveStyle(styleName)

local player = oUF:Spawn('player')
player:SetPoint('CENTER', -380, -200)
addon:PixelPerfect(player)

-- expose internally
addon.units.player = player
