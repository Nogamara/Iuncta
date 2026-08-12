local _, addon = ...

-- don't accidentally deny summons and invites
StaticPopupDialogs.PARTY_INVITE.hideOnEscape = nil
StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
StaticPopupDialogs.AREA_SPIRIT_HEAL.hideOnEscape = nil

-- click through toasts
hooksecurefunc(EventToastManagerFrame, 'DisplayToast', function(self)
	self:EnableMouse(false)

	if self.currentDisplayingToast then
		self.currentDisplayingToast:EnableMouse(false)
		self.currentDisplayingToast.TitleTextMouseOverFrame:EnableMouse(false)
		self.currentDisplayingToast.SubTitleMouseOverFrame:EnableMouse(false)
	end
end)
