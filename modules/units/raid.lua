local _, addon = ...
local oUF = addon.oUF

local raidStyle = addon.unitPrefix .. 'Raid'
oUF:RegisterStyle(raidStyle, function(self, unit)
	style(self, unit)

	-- debuffs inside the raid frame
	self.Debuffs.filter = 'HARMFUL'
	self.Debuffs.size = 16
	self.Debuffs.num = 3
	self.Debuffs.growthX = 'LEFT'
	self.Debuffs.initialAnchor = 'BOTTOMRIGHT'
	self.Debuffs.disableCooldownText = true -- custom option
	self.Debuffs:SetPoint('BOTTOMRIGHT', -3, 3)
	self.Debuffs:SetSize(self:GetWidth(), self.Debuffs.size)
	self.Debuffs:SetFrameLevel(self.Name:GetParent():GetFrameLevel() + 1) -- render high

	self.PrivateAuras:SetPoint('TOPRIGHT', -2, -4)
	self.PrivateAuras:SetSize(self:GetWidth(), self.Debuffs:GetHeight())
	self.PrivateAuras.spacing = 3
	self.PrivateAuras.size = self.Debuffs.size + 3
	self.PrivateAuras.growthX = self.Debuffs.growthX
	self.PrivateAuras.initialAnchor = self.Debuffs.initialAnchor
	self.PrivateAuras.disableCooldownText = self.Debuffs.disableCooldownText
	self.PrivateAuras.borderScale = 1
end)