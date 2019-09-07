ArmyGenerator = {
    SubCultureArmyPoolData = {},
    Logger = {},
    -- vanilla object references
    random_army_manager = {},
}

function ArmyGenerator:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function ArmyGenerator:Initialise(random_army_manager, enableLogging)
    require 'script/_lib/pooldata/ArmyPoolData/SubCultureArmyPoolDataResources'
    self.SubCultureArmyPoolData = GetSubcultureArmyPoolDataResources();
    self.Logger = Logger:new({});
    self.Logger:Initialise("ArmyGenerator.txt", enableLogging);
    self.Logger:Log_Start();
    -- Set vanilla object references
    self.random_army_manager = random_army_manager;
end

function ArmyGenerator:GenerateForceForTurn(ramData)
    self.Logger:Log("GenerateForceForTurn");
    if not self.random_army_manager then
        self.Logger:Log("Can't find random_army_manager");
        return;
    end

    self.random_army_manager:new_force(ramData.ForceKey);
    local mandatoryUnits = ramData.ForceData.MandatoryUnits;
    local mandatoryUnitCount = 0;
    if mandatoryUnits ~= nil then
        self.Logger:Log("Getting mandatory units");
        for unitKey, amount in pairs(mandatoryUnits) do
            mandatoryUnitCount = mandatoryUnitCount + amount;
        end
        self.Logger:Log("Got mandatory unit count: "..mandatoryUnitCount);
    end

    local subcultureUnits = self:GetOtherUnits(ramData);
    if subcultureUnits ~= nil then
        for unitKey, unitData in pairs(subcultureUnits) do
            self.Logger:Log("Adding subculture unit: "..unitKey);
            self.random_army_manager:add_unit(ramData.ForceKey, unitKey, unitData.Weighting);
        end
    end

    local armySize = 0;
    if ramData.ArmySize == nil then
        local turnNumber = cm:model():turn_number();
        local gamePeriod = self:GetGamePeriod(turnNumber);
        self.Logger:Log("Game period is: "..gamePeriod);
        if gamePeriod == "Early" then
            armySize = Random(8, 5) - mandatoryUnitCount;
        elseif gamePeriod == "Mid" then
            armySize = Random(13, 8) - mandatoryUnitCount;
        else
            armySize = Random(20, 13) - mandatoryUnitCount;
        end
    else
        armySize = ramData.ArmySize - mandatoryUnitCount;
    end
    self.Logger:Log("Force size is "..armySize);
    return self.random_army_manager:generate_force(ramData.ForceKey, armySize, false);
end

function ArmyGenerator:GetOtherUnits(ramData)
    local turnNumber = cm:model():turn_number();
    local gamePeriod = self:GetGamePeriod(turnNumber);

    local otherUnits = {};
    local subCultureArmyData = self:GetSubcultureArmyData(ramData.ForceData.SubcultureKey);
    if subCultureArmyData == nil then
        self.Logger:Log("Subculture army data is nil");
        return otherUnits;
    end
    for index, tag in pairs(ramData.ForceData.UnitTags) do
        local tagKey = "";
        -- If the stored data is a table grab a random tag from it
        if type(tag) == "table" then
            tagKey = GetRandomObjectFromList(tag);
        else
            tagKey = tag;
        end
        local tagData = subCultureArmyData[tagKey];
        if tagData ~= nil then
            local periodTagData = tagData[gamePeriod];
            for unitKey, weighting in pairs(periodTagData) do
                otherUnits[unitKey] = {
                    Weighting = weighting,
                };
            end
        end
    end
    return otherUnits;
end

function ArmyGenerator:GetSubcultureArmyData(subcultureKey)
    return self.SubCultureArmyPoolData[subcultureKey];
end

function ArmyGenerator:GetGamePeriod(turnNumber)
    if turnNumber < 60 then
        return "Early";
    elseif turnNumber < 150 then
        return "Mid";
    else
        return "Late";
    end
end