local MAX_NUM_SAVE_TABLE_KEYS = 400;

local cm = nil;
local context = nil;

function ER_InitialiseSaveHelpers(cmObject, contextObject)
    out("EnR: Initialising save helpers");
    cm = cmObject;
    context = contextObject;
end

function ER_SaveActiveRebellions(er)
    out("Enr: Saving active rebellions");
    local er_active_rebellions_header = {};

    local numberOfRebellions = 0;
    local tableCount = 1;
    local nthTable = {};

    for provinceKey, regionData in pairs(er.ActiveRebellions) do
        for index, militaryForceCqi in pairs(regionData.Forces) do
            nthTable[provinceKey.."/"..militaryForceCqi.."/"..regionData.TurnNumber] = {
                provinceKey,
                militaryForceCqi,
                regionData.TurnNumber,
            };
            numberOfRebellions = numberOfRebellions + 1;

            if numberOfRebellions % MAX_NUM_SAVE_TABLE_KEYS == 0 then
                out("Enr: Saving table number "..(tableCount + 1));
                cm:save_named_value("er_active_rebellions_"..tableCount, nthTable, context);
                tableCount = tableCount + 1;
                nthTable = {};
            end
        end
    end
    -- Saving the remaining active rebellions
    cm:save_named_value("er_active_rebellions_"..tableCount, nthTable, context);
    out("Enr: Saving "..numberOfRebellions.." active rebellions");

    er_active_rebellions_header["TotalActiveRebellions"] = numberOfRebellions;
    cm:save_named_value("er_active_rebellions_header", er_active_rebellions_header, context);
end

function ER_SaveActiveRebelForces(er)
    out("Enr: Saving rebel forces");
    local er_rebellion_forces_header = {};

    local numberOfRebelForces = 0;
    local tableCount = 1;
    local nthTable = {};

    for militaryForceCqi, rebelData in pairs(er.RebelForces) do
        nthTable[militaryForceCqi] = {
            rebelData.Target,
            rebelData.SpawnTurn,
            rebelData.SubcultureKey,
            rebelData.AgentSubTypeKey,
            rebelData.ArmyArchetypeKey,
            rebelData.SpawnedOnSea,
        };
        numberOfRebelForces = numberOfRebelForces + 1;

        if numberOfRebelForces % MAX_NUM_SAVE_TABLE_KEYS == 0 then
            out("Enr: Saving table number "..(tableCount + 1));
            cm:save_named_value("er_rebel_forces_"..tableCount, nthTable, context);
            tableCount = tableCount + 1;
            nthTable = {};
        end
    end
    -- Saving the remaining active rebellions
    cm:save_named_value("er_rebel_forces_"..tableCount, nthTable, context);
    out("Enr: Saving "..numberOfRebelForces.." rebel forces");

    er_rebellion_forces_header["TotalRebelForces"] = numberOfRebelForces;
    cm:save_named_value("er_rebellion_forces_header", er_rebellion_forces_header, context);
end

function ER_SavePastRebellions(er)
    out("Enr: Saving past rebellions");
    local er_past_rebellions_header = {};

    local numberOfPastRebellions = 0;
    local tableCount = 1;
    local nthTable = {};

    for regionKey, pastRegionData in pairs(er.PastRebellions) do
        for index, pastRebellionData in pairs(pastRegionData) do
            nthTable[regionKey.."/"..pastRebellionData.SpawnTurn] = { 
                pastRebellionData.SpawnTurn,
                pastRebellionData.SubcultureKey,
                pastRebellionData.AgentSubTypeKey,
                pastRebellionData.ArmyArchetypeKey,
                pastRebellionData.Target,
                pastRebellionData.DestroyedTurn,
            };
            numberOfPastRebellions = numberOfPastRebellions + 1;

            if numberOfPastRebellions % MAX_NUM_SAVE_TABLE_KEYS == 0 then
                out("Enr: Saving table number "..(tableCount + 1));
                cm:save_named_value("er_past_rebellions_"..tableCount, nthTable, context);
                tableCount = tableCount + 1;
                nthTable = {};
            end
        end
    end
    -- Saving the remaining active rebellions
    cm:save_named_value("er_past_rebellions_"..tableCount, nthTable, context);
    out("Enr: Saving "..numberOfPastRebellions.." past rebellions");

    er_past_rebellions_header["TotalPastRebellions"] = numberOfPastRebellions;
    cm:save_named_value("er_past_rebellions_header", er_past_rebellions_header, context);
end