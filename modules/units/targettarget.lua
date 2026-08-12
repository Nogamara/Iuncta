local _, addon = ...
local oUF = addon.oUF

local styleName = addon.unitPrefix .. 'TargetTarget'
oUF:RegisterStyle(styleName, function(self)
	Mixin(self, addon.widgetMixin)

	self:RegisterForClicks('AnyUp')
	self:SetSize(150, 30)
	local barTex = "Interface\\AddOns\\Iuncta\\assets\\bars\\Minimalist.tga"

	local Health = self:CreateBackdropStatusBar()
	Health:SetAllPoints()
	Health.colorReaction = true -- we only set these so oUF registers events
	Health.colorSelection = true
	Health:SetStatusBarTexture(barTex)
	Health.UpdateColor = addon.unitShared.UpdateColorHealth
	self.Health = Health

	local Name = Health:CreateText()
	Name:SetPoint('LEFT', addon.SPACING, 0)
	Name:SetJustifyH('LEFT')
	self:Tag(Name, '[inomena:reactioncolor][inomena:name<$|r]')

	local Debuffs = self:CreateAuras({
		layoutLimit = math.huge,
		growthX = 'RIGHT',
		growthY = 'UP', -- default
		initialAnchor = 'BOTTOMLEFT',
	})
	Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 4, 4)
	Debuffs.elementSpacing = addon.SPACING
	Debuffs.lineSpacing = addon.SPACING
	Debuffs.showCount = true
	Debuffs.size = self:GetHeight() * 1.2
	Debuffs.tooltipAnchor = 'ANCHOR_TOPLEFT'
	Debuffs.tooltipOffsetX = -1
	Debuffs.tooltipOffsetY = 3
	Debuffs.PostCreateButton = addon.unitShared.PostCreateAura
	Debuffs:AddGroup('HARMFUL', {
		-- these are mostly for showing debuffs on co-tank
		candidateFilters = {
			isBossOrRoleAura = true
		}
	})
end)

oUF:SetActiveStyle(styleName)

local targettarget = oUF:Spawn('targettarget')
targettarget:SetPoint('LEFT', addon.units.target, 'RIGHT', addon.SPACING, 0)
addon:PixelPerfect(targettarget)

-- expose internally
addon.units.targettarget = targettarget
