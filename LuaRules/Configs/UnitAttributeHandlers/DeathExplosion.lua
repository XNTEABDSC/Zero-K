
local spSetUnitRulesParam      = Spring.SetUnitRulesParam
local INLOS_ACCESS = {inlos = true}
GG.att_DeathExplodeMult = {}
return {
    ---@type AttributesHandlerFactory
    AbilityDisabled = {
        handledAttributeNames={},
        new = function(unitID, unitDefID)
            return {
                newDataHandler = function(frame)
					local deathExplodeMult = 1
                    return {
                        fold = function(data)
							deathExplodeMult = deathExplodeMult*(data.deathExplode or 1)
                        end,
                        apply = function()
							spSetUnitRulesParam(unitID, "deathExplodeMult", deathExplodeMult, INLOS_ACCESS)
							GG.att_DeathExplodeMult[unitID] = deathExplodeMult
                        end
                    }
                end,
                clear = function()
					GG.att_DeathExplodeMult[unitID] = nil
                end
            }
        end
    }
}