local MAX_NUM_SAVE_TABLE_KEYS = 400;

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
        out("Enr: Can't access CM");
        return;
    end
    local er_active_rebellions_header = cm:load_named_value("er_active_rebellions_header", {}, context);
    if er_active_rebellions_header == nil or er_active_rebellions_header["TotalActiveRebellions"] == nil then
        out("Enr: No active rebellions to load");
        return;
    else
        out("Enr: Loading "..er_active_rebellions_header["TotalActiveRebellions"].." active rebellions");
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
        out("Enr: Can't access CM");
        return;
    end
    local er_rebellion_forces_header = cm:load_named_value("er_rebellion_forces_header", {}, context);
    if er_rebellion_forces_header == nil or er_rebellion_forces_header["TotalRebelForces"] == nil then
        out("Enr: No rebel forces to load");
        return;
    else
        out("Enr: Loading "..er_rebellion_forces_header["TotalRebelForces"].." rebel forces");
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
        --out("EnR: Checking militaryForceCqi: "..militaryForceCqi);
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
        };
    end

    out("EnR: Finished loading active rebel forces tables");
end

function ER_LoadPastRebellions(er)
    out("EnR: LoadPastRebellions");
    if cm == nil then
        out("Enr: Can't access CM");
        return;
    end
    local er_past_rebellions_header = cm:load_named_value("er_past_rebellions_header", {}, context);
    if er_past_rebellions_header == nil or er_past_rebellions_header["TotalPastRebellions"] == nil then
        out("Enr: No past rebellions to load");
        return;
    else
        out("Enr: Loading "..er_past_rebellions_header["TotalPastRebellions"].." past rebellions");
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
        local regionKey = key:match("(.-)/");
        if er.PastRebellions[regionKey] == nil then
            er.PastRebellions[regionKey] = {};
        end
        local pastRebellions = er.PastRebellions[regionKey];
        pastRebellions[#pastRebellions + 1] = {
            SpawnTurn = pastRebellionData[1],
            SubcultureKey = pastRebellionData[2],
            AgentSubTypeKey = pastRebellionData[3],
            ArmyArchetypeKey = pastRebellionData[4],
            Target = pastRebellionData[5],
            DestroyedTurn = pastRebellionData[6],
        };
    end

    out("EnR: Finished loading past rebellion tables");
end