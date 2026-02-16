local _, addon = ...

-- set preferred console variables on login

local CVARS = { -- exposed settings from the interface options

	autoLootDefault = 1,

	Outline = 1,
	chatBubbles = 1, -- (default)
	chatBubblesParty = 0,
	chatBubblesRaid = 0, -- (default)

	showPingsInChat = 0,

	-- Gameplay Enhancements
	cooldownViewerEnabled = 1,
	damageMeterEnabled = 1,

	-- Gameplay Nameplates
	UnitNameOwn = 0, -- (default)
	UnitNameHostleNPC = 0, -- (sic!)
	ShowQuestUnitCircles = 0,
	UnitNameNonCombatCreatureName = 0, -- (default)
	UnitNameFriendlyPlayerName = 1, -- (default)
	UnitNameFriendlyPetName = 0,
	UnitNameFriendlyGuardianName = 0,
	UnitNameFriendlyTotemName = 0,
	UnitNameFriendlyMinionName = 0,
	UnitNameEnemyPlayerName = 1, -- (default)
	UnitNameEnemyPetName = 0,
	UnitNameEnemyGuardian = 0,
	UnitNameEnemyTotem = 0,
	UnitNameEnemyMinion = 0,

	-- Accessibility General
	enableMovePad = 0, -- (default)
	overrideScreenFlash = 1,
	WorldTextMinSize = 10,
	CameraKeepCharacterCentered = 1, -- (default)
	CameraReduceUnexpectedMovement = 1,
	ShakeStrengthCamera = 0.25,
	ShakeStrengthUI = 0,

	occludedSilhouettePlayer = 1,
}

local UVARS = { -- unexposed (hidden) settings
	-- ActionButtonUseKeyDown = 1,
	screenshotFormat = 'png',
	screenshotQuality = 10,
	scriptErrors = 1,
	taintLog = 0, -- goes up to 5, but it freezes the game while it writes
	-- minimapTrackingShowAll = 1, -- to get the full minimap tracking menu back
	AutoPushSpellToActionBar = 0,
	-- calendarShowResets = 0,
	-- raidOptionIsShown = 0,
	-- autoUnshift = 1,
	-- alwaysCompareItems = 0,
	-- cameraDistanceMaxZoomFactor = 2.6,
	-- rawMouseEnable = 1,
	-- SoftTargetInteractArc = 1,
}

function addon:OnLogin()
	for key, value in next, CVARS do
		C_CVar.SetCVar(key, value)
	end

	for key, value in next, UVARS do
		C_CVar.SetCVar(key, value)
	end

	if UnitLevel('player') < GetMaxLevelForPlayerExpansion() then
		-- this is kinda nice while leveling
		C_CVar.SetCVar('AutoPushSpellToActionBar', 1)
	end

	return true
end