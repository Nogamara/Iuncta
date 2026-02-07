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

