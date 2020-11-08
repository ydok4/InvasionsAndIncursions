require 'script/_lib/pooldata/ArmyPoolData/SubCultureArmyPoolDataResources'

_G.ArmyPoolResources = {
    SubCultureArmyPoolResources = GetSubcultureArmyPoolDataResources(),
    AddAdditionalArmyPoolResources = function(resources)
        for subcultureKey, subcultureData in pairs(resources) do
            if _G.ArmyPoolResources.SubCultureArmyPoolResources[subcultureKey] == nil then
                _G.ArmyPoolResources.SubCultureArmyPoolResources[subcultureKey] = {};
            end
            local existingResources = _G.ArmyPoolResources.SubCultureArmyPoolResources[subcultureKey];
            for tagKey, tagData in pairs(subcultureData) do
                if existingResources[tagKey] == nil then
                    existingResources[tagKey] = {};
                end
                local existingTag = existingResources[tagKey];
                for gameStage, gameStageData in pairs(tagData) do
                    if existingTag[gameStage] == nil then
                        existingTag[gameStage] = gameStageData;
                    else
                        local existingGameStageData = existingTag[gameStage];
                        for unitKey, unitValue in pairs(gameStageData) do
                            if type(unitValue) == "table" then
                                table.insert(existingGameStageData, gameStageData);
                            elseif unitValue == false then
                                existingGameStageData[unitKey] = nil;
                            else
                                existingGameStageData[unitKey] = unitValue;
                            end
                        end

                    end
                end
            end
        end
    end
};