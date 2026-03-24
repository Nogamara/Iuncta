local _, addon = ...
local oUF = addon.oUF

local styleName = addon.unitPrefix .. 'Pet'
oUF:RegisterStyle(styleName, function(self)
	Mixin(self, addon.widgetMixin)

	self:RegisterForClicks('AnyUp')
	self:SetSize(284, 30)

	local Health = self:CreateBackdropStatusBar()
	Health:SetPoint('TOP')
	Health:SetSize(284, 30)
	Health.colorReaction = true
	self.Health = Health

	--if addon.units.player.Power then
		-- offset when the player has mana (i.e. for warlocks)
		--Health:SetPointsOffset(0, -30)
	--end

	local Status = self:CreateText()
	Status:SetPoint('RIGHT', -addon.SPACING, 0)
	self:Tag(Status, '[inomena:dead][inomena:name<$|r]')
end)

oUF:SetActiveStyle(styleName)

local pet = oUF:Spawn('pet')
pet:SetPoint('TOPLEFT', addon.units.player, 'BOTTOMLEFT', 0, -35)
addon:PixelPerfect(pet)

-- expose internally
addon.units.pet = pet
