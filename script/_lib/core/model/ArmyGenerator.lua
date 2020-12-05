ArmyGenerator = {
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
    self.Logger = Logger:new({});
    self.Logger:Initialise("ArmyGenerator.txt", enableLogging);
    self.Logger:Log_Start();
    -- Set vanilla object references
    self.random_army_manager = random_army_manager;
end

function ArmyGenerator:GenerateForceForTurn(ramData, numberOfUnitsOverride)
    self.Logger:Log("GenerateForceForTurn: "..ramData.ForceKey);
    if not self.random_army_manager then
        self.Logger:Log("Can't find random_army_manager");
        return;
    end
    -- Clear the old force key in case it exists already
    pcall(function(forceKey) self.random_army_manager:remove_force(forceKey); end, ramData.ForceKey);
    self.random_army_manager:new_force(ramData.ForceKey);
    local mandatoryUnits = ramData.ForceData.MandatoryUnits;
    if mandatoryUnits ~= nil then
        self.Logger:Log("Getting mandatory units");
        for unitKey, amount in pairs(mandatoryUnits) do
            if type(amount) == "table" then
                local randomMandatoryUnitKey = GetRandomObjectKeyFromList(amount);
                self.random_army_manager:add_mandatory_unit(ramData.ForceKey, randomMandatoryUnitKey, amount[randomMandatoryUnitKey]);
            else
                self.random_army_manager:add_mandatory_unit(ramData.ForceKey, unitKey, amount);
            end
        end
    end

    local subcultureUnits = self:GetOtherUnits(ramData);
    if subcultureUnits ~= nil then
        for unitKey, unitData in pairs(subcultureUnits) do
            self.Logger:Log("Adding subculture unit: "..unitKey);
            self.random_army_manager:add_unit(ramData.ForceKey, unitKey, unitData.Weighting);
        end
    end
    local armySize = 0;
    if numberOfUnitsOverride == nil then
        armySize = self:GetArmySize(ramData.ArmySize);
    else
        armySize = numberOfUnitsOverride;
    end
    self.Logger:Log("Force size is "..armySize);
    local forceString = self.random_army_manager:generate_force(ramData.ForceKey, armySize, false);
    self.Logger:Log("String is "..forceString);
    self.Logger:Log_Finished();
    return forceString;
end

function ArmyGenerator:GetArmySize(minimumArmySize)
    local turnNumber = cm:model():turn_number();
    local gamePeriod = self:GetGamePeriod(turnNumber);
    self.Logger:Log("Game period is: "..gamePeriod);
    local minSize = 0;
    local maxSize = 0;
    local periodEnd = 0;
    if turnNumber < 15 then
        minSize = 5;
        maxSize = 6;
        periodEnd = 10;
    elseif gamePeriod == "Early" then
        minSize = 6;
        maxSize = 9;
        periodEnd = 50;
    elseif gamePeriod == "Mid" then
        minSize = 8;
        maxSize = 13;
        periodEnd = 120;
    else
        minSize = 13;
        maxSize = 19;
        periodEnd = 200;
    end
    if minimumArmySize ~= nil then
        minSize = minimumArmySize;
        if maxSize < minSize then
            maxSize = minSize;
        end
    end
    local bonusSize = 0;
    if Roll100(33) then
        bonusSize = 1;
    elseif Roll100(33) then
        bonusSize = -1;
    end
    -- The extra 0.5 is the rounding bonus
    local armySize = math.floor(minSize + (maxSize - minSize) * (turnNumber / periodEnd) + bonusSize + 0.5);
    if armySize > 19 then
        armySize = 19;
    end
    return armySize;
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
                if type(weighting) == "table" then
                    local randomUnitKey = GetRandomObjectKeyFromList(weighting);
                    local randomUnitWeighting = weighting[randomUnitKey];
                    otherUnits[randomUnitKey] = {
                        Weighting = randomUnitWeighting,
                    }
                else
                    otherUnits[unitKey] = {
                        Weighting = weighting,
                    };
                end
            end
        end
    end
    return otherUnits;
end

function ArmyGenerator:GetSubcultureArmyData(subcultureKey)
    return _G.ArmyPoolResources.SubCultureArmyPoolResources[subcultureKey];
end

function ArmyGenerator:GetGamePeriod(turnNumber)
    if turnNumber < 50 then
        return "Early";
    elseif turnNumber < 120 then
        return "Mid";
    else
        return "Late";
    end
end