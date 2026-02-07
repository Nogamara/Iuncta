local _, addon = ...

-- hide extra widgets
addon:Hide('BagsBar')

addon:HookAddOn('Blizzard_WeeklyRewards', function()
	-- this feels like an ad blocker
	hooksecurefunc(WeeklyRewardsFrame, 'UpdateOverlay', function()
		addon:Hide('WeeklyRewardsFrame', 'Blackout')
		addon:Hide('WeeklyRewardsFrame', 'Overlay')
	end)
end)
