local _, addon = ...
local oUF = addon.oUF
local tags = oUF.Tags

tags.Events['inomena:power'] = 'UNIT_POWER_FREQUENT UNIT_POWER_UPDATE UNIT_MAXPOWER'
tags.Methods['inomena:power'] = function(unit)
	if UnitPowerType(unit) ~= Enum.PowerType.Mana or true then
		return C_StringUtil.TruncateWhenZero(UnitPower(unit))
	end
end

tags.Events['inomena:powermax'] = 'UNIT_POWER_FREQUENT UNIT_POWER_UPDATE UNIT_MAXPOWER'
tags.Methods['inomena:powermax'] = function(unit)
	if UnitPowerType(unit) ~= Enum.PowerType.Mana or true then
		return C_StringUtil.TruncateWhenZero(UnitPowerMax(unit))
	end
end

tags.Events['inomena:hpmax'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
tags.Methods['inomena:hpmax'] = function(unit)
	if not UnitIsDeadOrGhost(unit) then
		return addon:AbbreviateNumbers(UnitHealthMax(unit))
	end
end

tags.Events['inomena:level'] = 'UNIT_HEALTH'
tags.Methods['inomena:level'] = function(unit)
    local lvl = UnitLevel(unit)
    if UnitIsPlayer(unit) then
        return tostring(lvl)
    end

    local utype = UnitClassification(unit)

    local isHighLevel = type(lvl) == 'number' and lvl < 0
    if isHighLevel then
        lvl = '??'
    else
        lvl = tostring(lvl)
    end
	if utype == 'worldboss' then
		return '|cnDARKYELLOW_FONT_COLOR:(WB) ' .. lvl .. '|r'
	elseif utype == 'elite' then
        return '|cnDARKYELLOW_FONT_COLOR:(E) ' .. lvl .. '|r'
    elseif utype == 'rareelite' then
        return '|cnLIGHTGRAY_FONT_COLOR:(RE) ' .. lvl .. '|r'
    elseif utype == 'rare' then
        return '|cnLIGHTGRAY_FONT_COLOR:(R) ' .. lvl .. '|r'
    else
        return lvl
		-- UI-HUD-UnitFrame-Target-PortraitOn-Boss-Gold
		-- "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat:14:14:0:0:16:16:0:16:0:16:73:177:73|t Reckful"
	end
end

tags.Events['inomena:role'] = 'PLAYER_ROLES_ASSIGNED ROLE_CHANGED_INFORM'
tags.Methods['inomena:role'] = function(unit)
	if UnitGroupRolesAssigned(unit) == 'HEALER' then
		return '|A:groupfinder-icon-role-large-heal:16:16|a'
	elseif UnitGroupRolesAssigned(unit) == 'TANK' then
		return '|A:groupfinder-icon-role-large-tank:16:16|a'
	else  -- DAMAGER
		return '|A:groupfinder-icon-role-large-dps:16:16|a'
	end
end

