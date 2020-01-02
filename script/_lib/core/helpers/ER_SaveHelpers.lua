local MAX_NUM_SAVE_TABLE_KEYS = 200;

local cm = nil;
local context = nil;

function ER_InitialiseSaveHelpers(cmObject, contextObject)
    out("EnR: Initialising save helpers");
    cm = cmObject;
    context = contextObject;
end

function ER_SaveActiveRebellions(er)
    out("EnR: Saving active rebellions");
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
                out("EnR: Saving table number "..(tableCount + 1));
                cm:save_named_value("er_active_rebellions_"..tableCount, nthTable, context);
                tableCount = tableCount + 1;
                nthTable = {};
            end
        end
    end
    -- Saving the remaining active rebellions
    cm:save_named_value("er_active_rebellions_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfRebellions.." active rebellions");

    er_active_rebellions_header["TotalActiveRebellions"] = numberOfRebellions;
    cm:save_named_value("er_active_rebellions_header", er_active_rebellions_header, context);
end

function ER_SaveActiveRebelForces(er)
    out("EnR: Saving rebel forces");
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
            rebelData.SpawnCoordinates,
            rebelData.CleanUpForce,
        };
        numberOfRebelForces = numberOfRebelForces + 1;

        if numberOfRebelForces % MAX_NUM_SAVE_TABLE_KEYS == 0 then
            out("EnR: Saving table number "..(tableCount + 1));
            cm:save_named_value("er_rebel_forces_"..tableCount, nthTable, context);
            tableCount = tableCount + 1;
            nthTable = {};
        end
    end
    -- Saving the remaining active rebellions
    cm:save_named_value("er_rebel_forces_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfRebelForces.." rebel forces");

    er_rebellion_forces_header["TotalRebelForces"] = numberOfRebelForces;
    cm:save_named_value("er_rebellion_forces_header", er_rebellion_forces_header, context);
end

function ER_SavePastRebellions(er)
    out("EnR: Saving past rebellions");
    local er_past_rebellions_header = {};

    local numberOfPastRebellions = 0;
    local tableCount = 1;
    local nthTable = {};

    for provinceKey, pastProvinceData in pairs(er.PastRebellions) do
        for index, pastRebellionData in pairs(pastProvinceData) do
            nthTable[provinceKey.."/"..pastRebellionData.SpawnTurn.."/"..pastRebellionData.TargetRegion] = {
                pastRebellionData.SpawnTurn,
                pastRebellionData.SubcultureKey,
                pastRebellionData.AgentSubTypeKey,
                pastRebellionData.ArmyArchetypeKey,
                pastRebellionData.TargetRegion,
                pastRebellionData.TargetFaction,
                pastRebellionData.DestroyedTurn,
            };
            numberOfPastRebellions = numberOfPastRebellions + 1;

            if numberOfPastRebellions % MAX_NUM_SAVE_TABLE_KEYS == 0 then
                out("EnR: Saving table number "..(tableCount + 1));
                cm:save_named_value("er_past_rebellions_"..tableCount, nthTable, context);
                tableCount = tableCount + 1;
                nthTable = {};
            end
        end
    end
    -- Saving the remaining past rebellions
    cm:save_named_value("er_past_rebellions_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfPastRebellions.." past rebellions");

    er_past_rebellions_header["TotalPastRebellions"] = numberOfPastRebellions;
    cm:save_named_value("er_past_rebellions_header", er_past_rebellions_header, context);
end

function ER_SaveActivePREs(er)
    out("EnR: Saving active PREs");
    local er_active_pres_header = {};

    local numberOfActivePREsRebellions = 0;
    local tableCount = 1;
    local nthTable = {};

    for provinceKey, pastProvinceData in pairs(er.ActivePREs) do
        for index, activePREData in pairs(pastProvinceData) do
            nthTable[provinceKey.."/"..activePREData.SpawnTurnNumber.."/"..activePREData.TargetRegion] = {
                activePREData.PREKey,
                activePREData.PRESubculture,
                activePREData.PREFaction,
                activePREData.SpawnTurnNumber,
                activePREData.PREDuration,
                activePREData.TargetRegion,
                activePREData.IsRebelSpawnLocked,
            };
            numberOfActivePREsRebellions = numberOfActivePREsRebellions + 1;

            if numberOfActivePREsRebellions % MAX_NUM_SAVE_TABLE_KEYS == 0 then
                out("EnR: Saving table number "..(tableCount + 1));
                cm:save_named_value("er_active_pres_"..tableCount, nthTable, context);
                tableCount = tableCount + 1;
                nthTable = {};
            end
        end
    end
    -- Saving the remaining active PREs
    cm:save_named_value("er_active_pres_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfActivePREsRebellions.." active PREs");

    er_active_pres_header["TotalActivePREs"] = numberOfActivePREsRebellions;
    cm:save_named_value("er_active_pres_header", er_active_pres_header, context);
end

function ER_SavePastPREs(er)
    out("EnR: Saving past PREs");
    local er_past_pres_header = {};

    local numberOfPastPREs = 0;
    local tableCount = 1;
    local nthTable = {};

    for provinceKey, pastProvinceData in pairs(er.PastPREs) do
        for index, pastPREData in pairs(pastProvinceData) do
            nthTable[provinceKey.."/"..pastPREData.SpawnTurnNumber.."/"..pastPREData.TargetRegion] = {
                pastPREData.PREKey,
                pastPREData.SpawnTurnNumber,
                pastPREData.PREFaction,
                pastPREData.PRESubculture,
                pastPREData.TargetRegion,
                pastPREData.TargetFaction,
                pastPREData.CompletedTurn,
            };
            numberOfPastPREs = numberOfPastPREs + 1;

            if numberOfPastPREs % MAX_NUM_SAVE_TABLE_KEYS == 0 then
                out("EnR: Saving table number "..(tableCount + 1));
                cm:save_named_value("er_past_pres_"..tableCount, nthTable, context);
                tableCount = tableCount + 1;
                nthTable = {};
            end
        end
    end
    -- Saving the remaining past PREs
    cm:save_named_value("er_past_pres_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfPastPREs.." past PREs");

    er_past_pres_header["TotalPastPREs"] = numberOfPastPREs;
    cm:save_named_value("er_past_pres_header", er_past_pres_header, context);
end

function ER_SaveReemergedFactions(er)
    out("EnR: Saving re-emerged factions");
    local er_reemerged_factions_header = {};

    local numberOfReemergedFactions = 0;
    local tableCount = 1;
    local nthTable = {};

    for factionKey, isReemerged in pairs(er.ReemergedFactions) do
        nthTable[factionKey] = isReemerged;
        numberOfReemergedFactions = numberOfReemergedFactions + 1;
        if numberOfReemergedFactions % MAX_NUM_SAVE_TABLE_KEYS == 0 then
            out("EnR: Saving table number "..(tableCount + 1));
            cm:save_named_value("er_reemerged_factions_"..tableCount, nthTable, context);
            tableCount = tableCount + 1;
            nthTable = {};
        end
    end
    -- Saving the remaining reemerged factions
    cm:save_named_value("er_reemerged_factions_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfReemergedFactions.." reemerged factions");

    er_reemerged_factions_header["TotalReemergedFactions"] = numberOfReemergedFactions;
    cm:save_named_value("er_reemerged_factions_header", er_reemerged_factions_header, context);
end

function ER_SaveConfederatedFactions(er)
    out("EnR: Saving confederated factions");
    local er_confederated_factions_header = {};

    local numberOfConfederatedFactions = 0;
    local tableCount = 1;
    local nthTable = {};

    for factionKey, isConfederated in pairs(er.ConfederatedFactions) do
        out("EnR: Saving confederated faction: "..factionKey);
        nthTable[factionKey] = isConfederated;
        numberOfConfederatedFactions = numberOfConfederatedFactions + 1;
        if numberOfConfederatedFactions % MAX_NUM_SAVE_TABLE_KEYS == 0 then
            out("EnR: Saving table number "..(tableCount + 1));
            cm:save_named_value("er_confederated_factions_"..tableCount, nthTable, context);
            tableCount = tableCount + 1;
            nthTable = {};
        end
    end
    cm:save_named_value("er_confederated_factions_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfConfederatedFactions.." confederated factions");

    er_confederated_factions_header["TotalConfederatedFactions"] = numberOfConfederatedFactions;
    cm:save_named_value("er_confederated_factions_header", er_confederated_factions_header, context);
end

function ER_SaveMilitaryCrackDowns(er)
    out("EnR: Saving military crackdowns");
    local er_military_crackdowns_header = {};

    local numberOfMilitaryCrackDowns = 0;
    local tableCount = 1;
    local nthTable = {};

    for factionKey, crackDownData in pairs(er.MilitaryCrackDowns) do
        nthTable[factionKey] = {
            crackDownData.ProvinceKey,
            crackDownData.TurnStart,
        };
        numberOfMilitaryCrackDowns = numberOfMilitaryCrackDowns + 1;
        if numberOfMilitaryCrackDowns % MAX_NUM_SAVE_TABLE_KEYS == 0 then
            out("EnR: Saving table number "..(tableCount + 1));
            cm:save_named_value("er_military_crackdowns_"..tableCount, nthTable, context);
            tableCount = tableCount + 1;
            nthTable = {};
        end
    end
    cm:save_named_value("er_military_crackdowns_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfMilitaryCrackDowns.." military crackdowns");

    er_military_crackdowns_header["TotalMilitaryCrackDowns"] = numberOfMilitaryCrackDowns;
    cm:save_named_value("er_military_crackdowns_header", er_military_crackdowns_header, context);
end

function ER_SaveTriggeredAgentDeployDilemmas(er)
    out("EnR: Saving triggered agent deploy dilemmas");
    local er_agent_deploy_dilemmas_header = {};

    local numberOfAgentDeployDilemmas = 0;
    local tableCount = 1;
    local nthTable = {};

    for dilemmaKey, isTriggered in pairs(er.TriggeredAgentDeployDilemmas) do
        nthTable[dilemmaKey] = isTriggered;
        numberOfAgentDeployDilemmas = numberOfAgentDeployDilemmas + 1;
        if numberOfAgentDeployDilemmas % MAX_NUM_SAVE_TABLE_KEYS == 0 then
            out("EnR: Saving table number "..(tableCount + 1));
            cm:save_named_value("er_agent_deploy_dilemmas_"..tableCount, nthTable, context);
            tableCount = tableCount + 1;
            nthTable = {};
        end
    end
    cm:save_named_value("er_agent_deploy_dilemmas_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfAgentDeployDilemmas.." agent deploy dilemmas");

    er_agent_deploy_dilemmas_header["TotalAgentDeployDilemmas"] = numberOfAgentDeployDilemmas;
    cm:save_named_value("er_agent_deploy_dilemmas_header", er_agent_deploy_dilemmas_header, context);
end