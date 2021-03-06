local MAX_NUM_SAVE_TABLE_KEYS = 200;

local cm = nil;
local context = nil;

function ER_InitialiseLoadHelpers(cmObject, contextObject)
    out("EnR: Initialising load helpers");
    cm = cmObject;
    context = contextObject;
end

function ER_LoadActiveRebellions(er)
    out("EnR: LoadActiveRebellions");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_active_rebellions_header = cm:load_named_value("er_active_rebellions_header", {}, context);
    if er_active_rebellions_header == nil or er_active_rebellions_header["TotalActiveRebellions"] == nil then
        out("EnR: No active rebellions to load");
        return;
    else
        out("EnR: Loading "..er_active_rebellions_header["TotalActiveRebellions"].." active rebellions");
    end

    local serialised_save_table_units = {};
    er.ActiveRebellions = {};
    local tableCount = math.ceil(er_active_rebellions_header["TotalActiveRebellions"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_active_rebellions_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_units, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for key, activeRebellionData in pairs(serialised_save_table_units) do
        local provinceKey = key:match("(.-)/");
        out("EnR: Loading active rebellion in province: "..provinceKey);
        if er.ActiveRebellions[provinceKey] == nil then
            er.ActiveRebellions[provinceKey] = {};
        end
        local militaryForceCqi = key:match(provinceKey.."/(.-)/");
        if er.ActiveRebellions[provinceKey].Forces == nil then
            er.ActiveRebellions[provinceKey].Forces = {};
        end
        local forces = er.ActiveRebellions[provinceKey].Forces;
        forces[#forces + 1] = militaryForceCqi;

        local turnNumber = key:match(provinceKey.."/"..militaryForceCqi.."/(.+)");
        er.ActiveRebellions[provinceKey].TurnNumber = turnNumber;
    end

    out("EnR: Finished loading active rebellion tables");
end

function ER_LoadRebelForces(er)
    out("EnR: LoadRebelForces");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_rebellion_forces_header = cm:load_named_value("er_rebellion_forces_header", {}, context);
    if er_rebellion_forces_header == nil or er_rebellion_forces_header["TotalRebelForces"] == nil then
        out("EnR: No rebel forces to load");
        return;
    else
        out("EnR: Loading "..er_rebellion_forces_header["TotalRebelForces"].." rebel forces");
    end

    local serialised_save_table_units = {};
    er.RebelForces = {};
    local tableCount = math.ceil(er_rebellion_forces_header["TotalRebelForces"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_rebel_forces_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_units, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for militaryForceCqi, rebelForceData in pairs(serialised_save_table_units) do
        out("EnR: Checking militaryForceCqi: "..militaryForceCqi);
        if er.RebelForces[tostring(militaryForceCqi)] == nil then
            er.RebelForces[tostring(militaryForceCqi)] = {};
        end
        er.RebelForces[tostring(militaryForceCqi)] = {
            Target = rebelForceData[1],
            SpawnTurn = rebelForceData[2],
            SubcultureKey = rebelForceData[3],
            AgentSubTypeKey = rebelForceData[4],
            ArmyArchetypeKey = rebelForceData[5],
            SpawnedOnSea = rebelForceData[6],
            SpawnCoordinates = rebelForceData[7],
            CleanUpForce = rebelForceData[8],
            AssociatedPRE = rebelForceData[9],
        };
    end

    out("EnR: Finished loading active rebel forces tables");
end

function ER_LoadPastRebellions(er)
    out("EnR: LoadPastRebellions");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_past_rebellions_header = cm:load_named_value("er_past_rebellions_header", {}, context);
    if er_past_rebellions_header == nil or er_past_rebellions_header["TotalPastRebellions"] == nil then
        out("EnR: No past rebellions to load");
        return;
    else
        out("EnR: Loading "..er_past_rebellions_header["TotalPastRebellions"].." past rebellions");
    end

    local serialised_save_table_units = {};
    er.PastRebellions = {};
    local tableCount = math.ceil(er_past_rebellions_header["TotalPastRebellions"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_past_rebellions_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_units, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for key, pastRebellionData in pairs(serialised_save_table_units) do
        --out("EnR: Checking key: "..key);
        local provinceKey = key:match("(.-)/");
        if er.PastRebellions[provinceKey] == nil then
            er.PastRebellions[provinceKey] = {};
        end
        local pastRebellions = er.PastRebellions[provinceKey];
        pastRebellions[#pastRebellions + 1] = {
            SpawnTurn = pastRebellionData[1],
            SubcultureKey = pastRebellionData[2],
            AgentSubTypeKey = pastRebellionData[3],
            ArmyArchetypeKey = pastRebellionData[4],
            TargetRegion = pastRebellionData[5],
            TargetFaction = pastRebellionData[6],
            DestroyedTurn = pastRebellionData[7],
        };
    end

    out("EnR: Finished loading past rebellion tables");
end

function ER_LoadActivePREs(er)
    out("EnR: ER_LoadActivePREs");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_active_pres_header = cm:load_named_value("er_active_pres_header", {}, context);
    if er_active_pres_header == nil or er_active_pres_header["TotalActivePREs"] == nil then
        out("EnR: No active PREs to load");
        return;
    else
        out("EnR: Loading "..er_active_pres_header["TotalActivePREs"].." active PREs");
    end

    local serialised_save_table_pres = {};
    er.ActivePREs = {};
    local tableCount = math.ceil(er_active_pres_header["TotalActivePREs"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_active_pres_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_pres, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for key, activePREData in pairs(serialised_save_table_pres) do
        --out("EnR: Checking key: "..key);
        local provinceKey = key:match("(.-)/");
        if er.ActivePREs[provinceKey] == nil then
            er.ActivePREs[provinceKey] = {};
        end
        local activeProvincePREs = er.ActivePREs[provinceKey];
        activeProvincePREs[#activeProvincePREs + 1] = {
            PREKey = activePREData[1],
            PRESubcultureKey = activePREData[2],
            PREFaction = activePREData[3],
            SpawnTurnNumber = activePREData[4],
            PREDuration = activePREData[5],
            TargetRegion = activePREData[6],
            IsRebelSpawnLocked = activePREData[7],
            RemainingNumberOfRandomSpawns = activePREData[8],
        };
    end

    out("EnR: Finished loading active pres tables");
end

function ER_LoadPastPREs(er)
    out("EnR: ER_LoadPastPREs");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_past_pres_header = cm:load_named_value("er_past_pres_header", {}, context);
    if er_past_pres_header == nil or er_past_pres_header["TotalPastPREs"] == nil then
        out("EnR: No past PREs to load");
        return;
    else
        out("EnR: Loading "..er_past_pres_header["TotalPastPREs"].." past PREs");
    end

    local serialised_save_table_pres = {};
    er.PastPREs = {};
    local tableCount = math.ceil(er_past_pres_header["TotalPastPREs"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_past_pres_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_pres, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for key, pastPREData in pairs(serialised_save_table_pres) do
        --out("EnR: Checking key: "..key);
        local provinceKey = key:match("(.-)/");
        if er.PastPREs[provinceKey] == nil then
            er.PastPREs[provinceKey] = {};
        end
        local activeProvincePREs = er.PastPREs[provinceKey];
        activeProvincePREs[#activeProvincePREs + 1] = {
            PREKey = pastPREData[1],
            SpawnTurnNumber = pastPREData[2],
            PREFaction = pastPREData[3],
            PRESubcultureKey = pastPREData[4],
            TargetRegion = pastPREData[5],
            TargetFaction = pastPREData[6],
            CompletedTurn = pastPREData[7],
        };
    end

    out("EnR: Finished loading past pres tables");
end

function ER_LoadReemergedFactions(er)
    out("EnR: ER_LoadReemergedFactions");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_reemerged_factions_header = cm:load_named_value("er_reemerged_factions_header", {}, context);
    if er_reemerged_factions_header == nil or er_reemerged_factions_header["TotalReemergedFactions"] == nil then
        out("EnR: No reemerged factions to load");
        return;
    else
        out("EnR: Loading "..er_reemerged_factions_header["TotalReemergedFactions"].." reemerged factions");
    end

    local serialised_save_table_pres = {};
    er.ReemergedFactions = {};
    local tableCount = math.ceil(er_reemerged_factions_header["TotalReemergedFactions"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_reemerged_factions_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_pres, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for reemergedFactionKey, isReemerged in pairs(serialised_save_table_pres) do
        out("EnR: Reemerged faction:  "..reemergedFactionKey);
        er.ReemergedFactions[reemergedFactionKey] = isReemerged;
    end

    out("EnR: Finished loading reemerged faction tables");
end

function ER_LoadConfederatedFactions(er)
    out("EnR: ER_LoadConfederatedFactions");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_confederated_factions_header = cm:load_named_value("er_confederated_factions_header", {}, context);
    if er_confederated_factions_header == nil or er_confederated_factions_header["TotalConfederatedFactions"] == nil then
        out("EnR: No confederated factions to load");
        return;
    else
        out("EnR: Loading "..er_confederated_factions_header["TotalConfederatedFactions"].." confederated factions");
    end

    local serialised_save_table_confederated_factions = {};
    er.ConfederatedFactions = {};
    local tableCount = math.ceil(er_confederated_factions_header["TotalConfederatedFactions"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_confederated_factions_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_confederated_factions, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for confederatedFactionKey, isConfederated in pairs(serialised_save_table_confederated_factions) do
        out("EnR: Confederated faction:  "..confederatedFactionKey);
        er.ReemergedFactions[confederatedFactionKey] = isConfederated;
    end

    out("EnR: Finished loading confederated faction tables");
end

function ER_LoadMilitaryCrackDowns(er)
    out("EnR: ER_LoadMilitaryCrackDowns");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_military_crackdowns_header = cm:load_named_value("er_military_crackdowns_header", {}, context);
    if er_military_crackdowns_header == nil or er_military_crackdowns_header["TotalMilitaryCrackDowns"] == nil then
        out("EnR: No military crackdowns to load");
        return;
    else
        out("EnR: Loading "..er_military_crackdowns_header["TotalMilitaryCrackDowns"].." military crack downs");
    end

    local serialised_save_table_military_crackdowns = {};
    er.MilitaryCrackDowns = {};
    local tableCount = math.ceil(er_military_crackdowns_header["TotalMilitaryCrackDowns"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_military_crackdowns_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_military_crackdowns, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for factionKey, crackDownData in pairs(serialised_save_table_military_crackdowns) do
        er.MilitaryCrackDowns[factionKey] = {
            ProvinceKey = crackDownData[1],
            TurnStart = crackDownData[2],
        };
    end

    out("EnR: Finished loading past military crackdown tables");
end

function ER_LoadAgentDeployDilemmas(er)
    out("EnR: ER_LoadAgentDeployDilemmas");
    if cm == nil then
        out("EnR: Can't access CM");
        return;
    end
    local er_agent_deploy_dilemmas_header = cm:load_named_value("er_agent_deploy_dilemmas_header", {}, context);
    if er_agent_deploy_dilemmas_header == nil or er_agent_deploy_dilemmas_header["TotalAgentDeployDilemmas"] == nil then
        out("EnR: No agent deploy dilemmas to load");
        return;
    else
        out("EnR: Loading "..er_agent_deploy_dilemmas_header["TotalAgentDeployDilemmas"].." agent deploy dilemmas");
    end

    local serialised_save_table_agent_deploy_dilemmas = {};
    er.TriggeredAgentDeployDilemmas = {};
    local tableCount = math.ceil(er_agent_deploy_dilemmas_header["TotalAgentDeployDilemmas"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("EnR: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("er_agent_deploy_dilemmas_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_agent_deploy_dilemmas, nthTable);
    end
    out("EnR: Concatted serialised save data");

    for dilemmaKey, isTriggered in pairs(serialised_save_table_agent_deploy_dilemmas) do
        er.TriggeredAgentDeployDilemmas[dilemmaKey] = isTriggered;
    end

    out("EnR: Finished loading past agent deploy dilemma tables");
end