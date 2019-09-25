--[[ Extension functions for CDOTA_BaseNPC

-HasLearnedAbility(abilityName)
  Checks if the unit has at least one point in ability abilityName.
  Primarily for checking if talents have been learned.
--]]

-- This file is also loaded on client (currently just for GetAttackRange)
-- but client doesn't have FindAbilityByName
if IsServer() then
  function CDOTA_BaseNPC:HasLearnedAbility(abilityName)
    local ability = self:FindAbilityByName(abilityName)
    if ability then
      return ability:GetLevel() > 0
    end
    return false
  end

  function CDOTA_BaseNPC:GetValueChangedByStatusResistance(value)
    if self and value then
      local reduction = self:GetStatusResistance()

      -- Min and Max cases
      if reduction >= 1 then
        return value*0.99
      end
      if reduction <= 0 then
        return value
      end

      return value*(1-reduction)
    end
  end
end

if CDOTA_BaseNPC then
  function CDOTA_BaseNPC:GetAttackRange()
    return self:Script_GetAttackRange()
  end

  function CDOTA_BaseNPC:IsNeutralCreep( notAncient )
    local targetFlags = bit.bor( DOTA_UNIT_TARGET_FLAG_DEAD, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO )

    if notAncient then
      targetFlags = bit.bor( targetFlags, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS )
    end

    return ( UnitFilter( self, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, targetFlags, DOTA_TEAM_NEUTRALS ) == UF_SUCCESS and not self:IsControllableByAnyPlayer() )
  end
end
