require 'script/_lib/pooldata/AreaPoolData'
require 'script/_lib/pooldata/DelayedStartPoolData'
require 'script/_lib/pooldata/IncursionPoolData'
require 'script/_lib/pooldata/InvasionPoolData'
require 'script/_lib/pooldata/SpawnLocationPoolData'
require 'script/_lib/pooldata/SubCultureArmyPoolData'

require 'script/_lib/dbexports/AgentDataResources'
require 'script/_lib/dbexports/NameGroupResources'
require 'script/_lib/dbexports/SubCultureNameGroupResources'
require 'script/_lib/dbexports/NameResources'

IandI_Log("Loading Core Data");
out("I&I: Loading Core Data");

_G.I_I_Data = {
    Areas = AreaPoolData,
    DelayedStart = DelayedStartPoolData,
    Incursions = IncursionPoolData,
    Invasions = InvasionPoolData,
    SpawnLocations = SpawnLocationPoolData,

    SubCultureArmyPoolData = SubCultureArmyPoolData,
    AddAdditionalDBResources = function(dbResourceKey, resourceData)
        if dbResourceKey == "Areas" then
            local areaResources = _G.I_I_Data[dbResourceKey]["main_warhammer"];
            for key, areaData in pairs(resourceData["main_warhammer"]) do
                if areaResources[key] == nil then
                    areaResources[key] = {};
                    ConcatTableWithKeys(areaResources[key], areaData);
                else
                    if areaData.Events.Incursions ~= nil then
                        if areaResources[key].Events.Incursions == nil then
                            areaResources[key].Events.Incursions = {};
                        end
                        for eventKey, eventData in pairs(areaData.Events.Incursions) do
                            areaResources[key].Events.Incursions[eventKey] =  eventData;
                        end
                    end
                    if areaData.Events.Invasions ~= nil then
                        if areaResources[key].Events.Invasions == nil then
                            areaResources[key].Events.Invasions = {};
                        end
                        for eventKey, eventData in pairs(areaData.Events.Invasions) do
                            areaResources[key].Events.Invasions[eventKey] =  eventData;
                        end
                    end
                end
            end
            areaResources = _G.I_I_Data[dbResourceKey]["wh2_main_great_vortex"];
            for key, areaData in pairs(resourceData["wh2_main_great_vortex"]) do
                if areaResources[key] == nil then
                    areaResources[key] = {};
                    ConcatTableWithKeys(areaResources[key], areaData);
                else
                    if areaData.Events.Incursions ~= nil then
                        if areaResources[key].Events.Incursions == nil then
                            areaResources[key].Events.Incursions = {};
                        end
                        for eventKey, eventData in pairs(areaData.Events.Incursions) do
                            areaResources[key].Events.Incursions[eventKey] =  eventData;
                        end
                    end
                    if areaData.Events.Invasions ~= nil then
                        if areaResources[key].Events.Invasions == nil then
                            areaResources[key].Events.Invasions = {};
                        end
                        for eventKey, eventData in pairs(areaData.Events.Invasions) do
                            areaResources[key].Events.Invasions[eventKey] =  eventData;
                        end
                    end
                end
            end
        else
            for key, data in pairs(resourceData) do
                if _G.I_I_Data[dbResourceKey][key] == nil then
                    _G.I_I_Data[dbResourceKey][key] = {};
                    ConcatTableWithKeys(_G.I_I_Data[dbResourceKey][key], data);
                else
                    for propertyKey, propertyValue in pairs(data) do
                        if propertyKey == "RAMData" then
                            if propertyValue.PrimaryForce ~= nil then
                                if propertyValue.PrimaryForce.Subtypes ~= nil then
                                    local subtypes = propertyValue.PrimaryForce.Subtypes;
                                    ConcatTable(_G.I_I_Data[dbResourceKey][key].RAMData.PrimaryForce.Subtypes, subtypes);
                                end
                                if propertyValue.PrimaryForce.RemoveSubtypes ~= nil then
                                    for index, keyToRemove in pairs(propertyValue.PrimaryForce.RemoveSubtypes) do
                                        for index, existingKey in pairs(_G.I_I_Data[dbResourceKey][key].RAMData.PrimaryForce.Subtypes) do
                                            if existingKey == keyToRemove then
                                                table.remove(_G.I_I_Data[dbResourceKey][key].RAMData.PrimaryForce.Subtypes, index);
                                            end
                                        end
                                    end
                                end
                                if propertyValue.PrimaryForce.UnitTags ~= nil then
                                    local unitTags = propertyValue.PrimaryForce.UnitTags;
                                    ConcatTable(_G.I_I_Data[dbResourceKey][key].RAMData.PrimaryForce.UnitTags, unitTags);
                                end
                            end
                            if propertyValue.SecondaryForces ~= nil then
                                for forceKey, secondaryForce in pairs(propertyValue.SecondaryForces) do
                                    if _G.I_I_Data[dbResourceKey][key].RAMData.SecondaryForces[forceKey] == nil then
                                        _G.I_I_Data[dbResourceKey][key].RAMData.SecondaryForces[forceKey] = secondaryForce;
                                    else
                                        if secondaryForce.Subtypes ~= nil then
                                            local subtypes = secondaryForce.Subtypes;
                                            ConcatTable(_G.I_I_Data[dbResourceKey][key].RAMData.SecondaryForces[forceKey].Subtypes, subtypes);
                                        end
                                        if secondaryForce.RemoveSubtypes ~= nil then
                                            for index, keyToRemove in pairs(secondaryForce.RemoveSubtypes) do
                                                for index, existingKey in pairs(_G.I_I_Data[dbResourceKey][key].RAMData.SecondaryForces[forceKey].Subtypes) do
                                                    if existingKey == keyToRemove then
                                                        table.remove(_G.I_I_Data[dbResourceKey][key].RAMData.SecondaryForces[forceKey].Subtypes, index);
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end,
}

-- Load the name resources
-- This is separate so I can use this in other mods
if not _G.CG_NameResources then
    _G.CG_NameResources = {
        subculture_to_name_groups = SubCultureNameGroupResources,
        faction_to_name_groups = NameGroupResources,
        name_groups_to_names = NameResources,
        campaign_character_data = AgentDataResources,
    }
end