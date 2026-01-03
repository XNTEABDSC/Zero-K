
local spSetUnitBuildSpeed      = Spring.SetUnitBuildSpeed
local spSetUnitRulesParam      = Spring.SetUnitRulesParam
local INLOS_ACCESS = {inlos = true}
local REPAIR_ENERGY_COST_FACTOR = Game.repairEnergyCostFactor
GG.attRaw_BuildSpeed = {}
local buildSpeedDef = {}

for i = 1, #UnitDefs do
	local ud = UnitDefs[i]
	if (ud.buildSpeed or 0) ~= 0 then
		buildSpeedDef[i] = ud.buildSpeed
	end
end

return {
    ---@type AttributesHandlerFactory
    AbilityDisabled = {
        handledAttributeNames={build=true},
        new = function(unitID, unitDefID)
			local currentBuildMult=nil
			local buildSpeed=buildSpeedDef[unitDefID] or 0
            return {
                newDataHandler = function(frame)
					local buildMult = 1
                    return {
                        fold = function(data)
							buildMult = buildMult * (data.build or 1)
                        end,
                        apply = function()
							local newBuildSpeed=buildSpeed*buildMult
							GG.attRaw_BuildSpeed[unitID] = newBuildSpeed
							spSetUnitRulesParam(unitID, "totalBuildPowerChange", buildMult, INLOS_ACCESS)
							if currentBuildMult~=buildMult then
								spSetUnitBuildSpeed(unitID,
									newBuildSpeed, -- build
									newBuildSpeed / REPAIR_ENERGY_COST_FACTOR, -- repair
									newBuildSpeed, -- reclaim
									0.5*newBuildSpeed) -- rezz
								currentBuildMult=buildMult
							end
                        end
                    }
                end,
                clear = function()
					GG.attRaw_BuildSpeed[unitID] = nil
                end
            }
        end
    }
}