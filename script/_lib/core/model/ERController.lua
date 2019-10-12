ERController = {
    CampaignName = "",
    HumanFaction = {},
    ArmyGenerator = {},
    CharacterGenerator = {},
    Logger = {},
    ActiveRebellions = {},
    RebelForces = {},
    PastRebellions = {},
    ActivePREs = {},
    PastPREs = {},
    -- This stores the key of the region a button
    -- triggered a dilemma from
    ButtonSelectedRegion = {},
    ReemergedFactions = {},
    ConfederatedFactions = {},
    MilitaryCrackDowns = {},
    TriggeredAgentDeployDilemmas = {},
    -- Feature toggles
    EnableCorruptionArmies = true,
}

function ERController:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function ERController:Initialise(random_army_manager, enableLogging)
    self.CampaignName = cm:get_campaign_name();
    self.HumanFaction = self:GetHumanFaction();
    self.ArmyGenerator = ArmyGenerator:new({

    });
    self.ArmyGenerator:Initialise(random_army_manager, enableLogging);
    self.CharacterGenerator = CharacterGenerator:new({
    });
    self.CharacterGenerator:Initialise(enableLogging);
    self.Logger = Logger:new({});
    self.Logger:Initialise("EnhancedRebellions.txt", enableLogging);
    self.Logger:Log_Start();
end

function ERController:CheckMCMOptions(core)
    if not mcm then
        self.Logger:Log("Can't find MCM in class scope");
        return;
    end
    if not ER_SetupPostUIListeners then
        self.Logger:Log("Can't find listener function in class scope");
        return;
    end
    local enableRebellions = cm:get_saved_value("mcm_tweaker_public_order_expanded_toggle_rebellions_value");
    if enableRebellions == nil or enableRebellions == "enable_rebellions" then
        self.Logger:Log("Rebellions are enabled in MCM");
        ER_SetupPostUIListeners(self, core);
        ER_SetupPostUIInterfaceListeners(self, core, true);
    else
        self.Logger:Log("Rebellions are disabled in MCM");
    end
    local enableCorruptionArmies = cm:get_saved_value("mcm_tweaker_public_order_expanded_toggle_corruption_armies_value");
    if enableCorruptionArmies == nil or enableCorruptionArmies == "enable_corruption_armies" then
        self.EnableCorruptionArmies = true;
    else
        self.EnableCorruptionArmies = false;
    end
end

-- This exists to convert the human faction list to just an object.
-- This also means it will only work for one player.
function ERController:GetHumanFaction()
    local allHumanFactions = cm:get_human_factions();
    if allHumanFactions == nil then
        return allHumanFactions;
    end
    for key, humanFaction in pairs(allHumanFactions) do
        local faction = cm:model():world():faction_by_key(humanFaction);
        return faction;
    end
end

function ERController:IsExcludedFaction(faction)
    local factionName = faction:name();
    if factionName == "wh_main_grn_skull-takerz" then
        return false;
    end

    if factionName == "rebels" or
    string.match(factionName, "waaagh") or
    string.match(factionName, "brayherd") or
    string.match(factionName, "intervention") or
    string.match(factionName, "incursion") or
    string.match(factionName, "separatists") or
    string.match(factionName, "qb") or
    factionName == "wh_dlc03_bst_beastmen_chaos" or
    factionName == "wh2_dlc11_cst_vampire_coast_encounters"
    then
        --Custom_Log("Faction is excluded");
        return true;
    end

    return false;
end

function ERController:StartRebellion(region, owningFaction)
    -- Get rebel subculture
    local rebellionProvinceData = self:GetRebellionSubcultureForRegion(region);
    self.Logger:Log("Chosen rebellionSubculture: "..rebellionProvinceData.SubcultureKey);
    -- Get general/army data
    local forceData = self:GetForceDataForRegionAndSubculture(region, rebellionProvinceData);
    -- Spawn army
    self:SpawnArmy(forceData, region, owningFaction);
end

function ERController:GetRebellionSubcultureForRegion(region)
    local validSubculturesForRegion = {};
    local regionKey = region:name();
    local ownerFaction = region:owning_faction();
    local ownerSubculture = ownerFaction:subculture();
    local turnNumber = cm:model():turn_number();
    -- Bretonnia factions when played by the player have an incursion event
    -- in vanilla where Greenskins are roaming their lands, so we force the
    -- rebels to be Greenskins subculture.
    -- We exclude the Bretonnian crusader factions because they don't have the event
    if turnNumber < 21
    and ownerSubculture == "wh_main_sc_brt_bretonnia"
    and ownerFaction:name() == self.HumanFaction:name()
    and ownerFaction:name() ~= "wh2_main_brt_knights_of_origo"
    and ownerFaction:name() ~= "wh2_main_brt_knights_of_the_flame"
    and ownerFaction:name() ~= "wh2_main_brt_thegans_crusaders"
    then
        local provinceKey = region:province_name();
        local provinceResources = self:GetProvinceRebellionResources(provinceKey);
        local rebellionProvinceData = {
            SubcultureKey = "wh_main_sc_grn_greenskins",
            IsAdjacentToSea = provinceResources.IsAdjacentToSea,
        };
        return rebellionProvinceData;
    end
    -- First subculture we add is our current subculture with some exceptions.
    -- In vanilla, Dwarfs and Bretonnia won't rebel against themselves.
    -- Everyone else will though.
    if ownerSubculture ~= "wh_main_sc_dwf_dwarfs"
    and ownerSubculture ~= "wh_main_sc_brt_bretonnia" then
        validSubculturesForRegion[ownerSubculture] = {
            Weighting = 2,
        };
    -- Instead these factions get greenskins
    else
        validSubculturesForRegion["wh_main_sc_grn_greenskins"] = {
            Weighting = 2,
        };
    end
    -- Next is any subcultures which are considered 'native' rebels to the province
    local provinceKey = region:province_name();
    local provinceResources = self:GetProvinceRebellionResources(provinceKey);
    if provinceResources.RebelSubcultures ~= nil then
        for subcultureKey, subcultureData in pairs(provinceResources.RebelSubcultures) do
            if validSubculturesForRegion[subcultureKey] ~= nil then
                validSubculturesForRegion[subcultureKey].Weighting = validSubculturesForRegion[subcultureKey].Weighting + subcultureData.Weighting;
            else
                validSubculturesForRegion[subcultureKey] = {
                    Weighting = subcultureData.Weighting,
                };
            end
        end
    end
    -- Then we consider foreign subcultures from adjacent regions
    local adjacentRegionList = region:adjacent_region_list();
    local checkedRegions = {};
    checkedRegions[regionKey] = true;
    for i = 0, adjacentRegionList:num_items() - 1 do
        local adjacentRegion = adjacentRegionList:item_at(i);
        -- First we see if this is an adjacent region in the same province
        if checkedRegions[adjacentRegion:name()] == nil
        and adjacentRegion:province_name() == provinceKey then
            self.Logger:Log("Checking adjacent region: "..adjacentRegion:name().." in province: "..provinceKey);
            local adjacentRegionAdjacentRegionList = adjacentRegion:adjacent_region_list();
            for j = 0, adjacentRegionAdjacentRegionList:num_items() - 1 do
                local adjacentAdjacentRegion = adjacentRegionAdjacentRegionList:item_at(j);
                if checkedRegions[adjacentAdjacentRegion:name()] == nil
                and adjacentAdjacentRegion:is_abandoned() == false
                and adjacentAdjacentRegion:owning_faction():subculture() ~= ownerSubculture then
                    local adjacentSubculture = adjacentAdjacentRegion:owning_faction():subculture();
                    -- Empire won't rebel against dwarfs and vice versa
                    if not ((adjacentSubculture == "wh_main_sc_dwf_dwarfs" and ownerSubculture == "wh_main_sc_emp_empire")
                    or (adjacentSubculture == "wh_main_sc_emp_empire" and ownerSubculture == "wh_main_sc_dwf_dwarfs")
                    or adjacentSubculture == "rebels") then
                        self.Logger:Log("Found adjacent subculture: "..adjacentSubculture.." in region: "..adjacentAdjacentRegion:name());
                        if validSubculturesForRegion[adjacentSubculture] ~= nil then
                            validSubculturesForRegion[adjacentSubculture].Weighting = validSubculturesForRegion[adjacentSubculture].Weighting + 1;
                        else
                            validSubculturesForRegion[adjacentSubculture] = {
                                Weighting = 1,
                            };
                        end
                    end
                end
                checkedRegions[adjacentAdjacentRegion:name()] = true;
            end
            checkedRegions[adjacentRegion:name()] = true;
        -- Otherwise, it must be a different province
        elseif checkedRegions[adjacentRegion:name()] == nil
        and adjacentRegion:is_abandoned() == false
        and adjacentRegion:owning_faction():subculture() ~= ownerSubculture then
            local adjacentSubculture = adjacentRegion:owning_faction():subculture();
            if not ((adjacentSubculture == "wh_main_sc_dwf_dwarfs" and ownerSubculture == "wh_main_sc_emp_empire")
            or (adjacentSubculture == "wh_main_sc_emp_empire" and ownerSubculture == "wh_main_sc_dwf_dwarfs")
            or adjacentSubculture == "rebels") then
                self.Logger:Log("Found adjacent subculture: "..adjacentSubculture.." in region: "..adjacentRegion:name());
                if validSubculturesForRegion[adjacentSubculture] ~= nil then
                    validSubculturesForRegion[adjacentSubculture].Weighting = validSubculturesForRegion[adjacentSubculture].Weighting + 1;
                else
                    validSubculturesForRegion[adjacentSubculture] = {
                        Weighting = 1,
                    };
                end
            end
        end
    end

    -- Now we remove the subculture of the last-ish rebellion.
    -- This is purely for variety reasons
    -- NOTE: We never exclude corruption rebels
    local lastRebellionData = self:GetLastRebellionData(provinceKey);
    if lastRebellionData ~= nil then
        local lastRebellionSubculture = lastRebellionData.SubcultureKey;
        self.Logger:Log("Excluding subculture: "..lastRebellionSubculture);
        validSubculturesForRegion[lastRebellionSubculture] = nil;
    end

    -- Finally consider rebels added by corruption (If enabled).
    -- This could be Vampire Counts/Vampire Coast, Chaos/Beastmen or Skaven
    if self.EnableCorruptionArmies == true then
        -- Beastmen and Chaos can't rebel against Norsca
        -- Same with the Cult of Pleasure
        if ownerSubculture ~= "wh_main_sc_nor_norsca"
        and ownerFaction:name() ~= "wh2_main_def_cult_of_pleasure" then
            local chaosCorruption = math.floor(region:religion_proportion("wh_main_religion_chaos") * 100);
            local chaosCorruptionWeighting = self:GetCorruptionWeighting(chaosCorruption);
            if chaosCorruptionWeighting > 0 then
                self.Logger:Log("Chaos corruption for "..regionKey.." is: "..chaosCorruption);
                -- Chaos corruption is split between beastmen and chaos warriors
                local chaosWarriorsCorruptionWeighting = math.ceil(0.25 * chaosCorruptionWeighting);
                validSubculturesForRegion["wh_main_sc_chs_chaos_corruption"] = {
                    Weighting = chaosWarriorsCorruptionWeighting,
                };
                local beastmenCorruptionWeighting = math.ceil(0.75 * chaosCorruptionWeighting);
                validSubculturesForRegion["wh_dlc03_sc_bst_beastmen_corruption"] = {
                    Weighting = beastmenCorruptionWeighting,
                };
                self.Logger:Log("Chaos corruption weighting for "..regionKey.." is: "..chaosCorruptionWeighting);
            end
        end

        -- Vampire counts aren't impacting by their own corruption rebellions
        if ownerSubculture ~= "wh_main_sc_vmp_vampire_counts"
        and ownerSubculture ~= "wh2_dlc11_sc_cst_vampire_coast"
        and ownerFaction:name() ~= "wh2_dlc09_tmb_followers_of_nagash"
        then
            local vampireCorruption = math.floor(region:religion_proportion("wh_main_religion_undeath") * 100);
            local vampireCorruptionWeighting = self:GetCorruptionWeighting(vampireCorruption);
            if vampireCorruptionWeighting > 0 then
                self.Logger:Log("Vampire corruption for "..regionKey.." is: "..vampireCorruption);
                if provinceResources.IsAdjacentToSea ~= nil
                and provinceResources.IsAdjacentToSea == true then
                    local vampireCountsCorruptionWeighting = math.ceil(0.25 * vampireCorruptionWeighting);
                    validSubculturesForRegion["wh_main_sc_vmp_vampire_counts_corruption"] = {
                        Weighting = vampireCountsCorruptionWeighting,
                    };
                    local vampireCoastCorruptionWeighting = math.ceil(0.75 * vampireCorruptionWeighting);
                    validSubculturesForRegion["wh2_dlc11_sc_cst_vampire_coast_corruption"] = {
                        Weighting = vampireCoastCorruptionWeighting,
                    };
                else
                    validSubculturesForRegion["wh_main_sc_vmp_vampire_counts_corruption"] = {
                        Weighting = vampireCorruptionWeighting,
                    };
                end
                self.Logger:Log("Vampire corruption weighting for "..regionKey.." is: "..vampireCorruptionWeighting);
            end
        end

        -- Skaven are impacted by their own subculture rebellions
        local skavenCorruption = math.floor(region:religion_proportion("wh2_main_religion_skaven") * 100);
        local skavenCorruptionWeighting = self:GetCorruptionWeighting(skavenCorruption);
        if skavenCorruptionWeighting > 0 then
            self.Logger:Log("Skaven corruption for "..regionKey.." is: "..skavenCorruption);
            validSubculturesForRegion["wh2_main_sc_skv_skaven_corruption"] = {
                Weighting = skavenCorruptionWeighting,
            };
            self.Logger:Log("Skaven corruption weighting for "..regionKey.." is: "..skavenCorruptionWeighting);
        end
    end
    -- With all the data gatherd and weighted grab a subculture from the weighted list
    local rebellionProvinceData = {
        SubcultureKey = GetRandomItemFromWeightedList(validSubculturesForRegion, true),
        IsAdjacentToSea = provinceResources.IsAdjacentToSea,
    };
    return rebellionProvinceData;
end

function ERController:GetCorruptionWeighting(corruptionValue)
    local corruptionWeighting = math.floor(corruptionValue / 10);
    -- We round up from 5
    if corruptionValue % 10 > 5 then
        corruptionWeighting = corruptionWeighting + 1;
    end
    return corruptionWeighting;
end

function ERController:GetRebellionFactionForSubculture(rebellionSubculture, spawnOnSea)
    if spawnOnSea == true then
        return _G.ERResources.RebelFactionPoolDataResources[rebellionSubculture].Sea;
    else
        return _G.ERResources.RebelFactionPoolDataResources[rebellionSubculture].Default;
    end
end

function ERController:GetProvinceRebellionResources(provinceKey)
    return _G.ERResources.ProvinceSubcultureRebellionsPoolDataResources[provinceKey];
end

function ERController:GetArmyArchetypeData(subcultureKey, archetypeKey)
    if _G.ERResources.RebelArmyArchetypesPoolData[subcultureKey] == nil then
        return _G.ERResources.RebelCorruptionArmyArchetypesPoolData[subcultureKey][subcultureKey][archetypeKey];
    elseif _G.ERResources.RebelArmyArchetypesPoolData[subcultureKey][subcultureKey][archetypeKey] == nil then
        local armySubcultureKey = subcultureKey;
        if not string.match(subcultureKey, "_corruption") then
            armySubcultureKey = armySubcultureKey.."_corruption";
        end
        return _G.ERResources.RebelCorruptionArmyArchetypesPoolData[armySubcultureKey][armySubcultureKey][archetypeKey];
    else
        return _G.ERResources.RebelArmyArchetypesPoolData[subcultureKey][subcultureKey][archetypeKey];
    end
end

function ERController:GetForceDataForRegionAndSubculture(region, rebellionProvinceData, armyArchetypeOverrideKey)
    -- First we figure out what archetype we should use for this region and subculture
    local archetypeData = self:GetArmyArchetypeForRegionProvinceAndSubculture(region, rebellionProvinceData.SubcultureKey, armyArchetypeOverrideKey);
    local willSpawnOnSea = rebellionProvinceData.IsAdjacentToSea == true and archetypeData.CanSpawnOnSea == true and region:settlement():is_port() == true;
    -- Next we generate a name and art set for them
    -- NOTE: Art set isn't required but I can potentially use for other things
    local rebellionFaction = "";
    if archetypeData.RebellionFaction == nil then
        rebellionFaction = self:GetRebellionFactionForSubculture(rebellionProvinceData.SubcultureKey, willSpawnOnSea);
    else
        rebellionFaction = archetypeData.RebellionFaction;
    end
    local rebelFaction = cm:get_faction(rebellionFaction);
    local agentSubTypeData = {};
    local generatedName = self.CharacterGenerator:GetCharacterNameForSubculture(rebelFaction, archetypeData.AgentSubTypeKey);
    local artSetId = self.CharacterGenerator:GetArtSetForSubType(archetypeData.AgentSubTypeKey);
    agentSubTypeData = {
        AgentSubTypeKey = archetypeData.AgentSubTypeKey,
        AgentArtSetId = artSetId,
        -- Note: These may seem like they are the wrong way around
        -- but that is what the game needs
        ClanNameKey = generatedName.clan_name,
        ForeNameKey = generatedName.forename,
    };
    -- Now we remap our data into a useable format for the ArmyGenerator
    -- Set rebellion data structure
    local rebellionData = {
        SubcultureKey = rebellionProvinceData.SubcultureKey,
        FactionKey = rebelFaction:name(),
        AgentSubTypeData = agentSubTypeData,
        MandatoryUnits = archetypeData.MandatoryUnits,
        UnitTags = archetypeData.UnitTags,
        ArmyArchetypeKey = archetypeData.ArmyArchetypeKey,
        ForceString = "",
        SpawnOnSea = willSpawnOnSea,
        SpawnWithExistingCharacter = archetypeData.SpawnWithExistingCharacter,
        RebellionFaction = archetypeData.RebellionFaction,
    };
    -- Get rebel army
    local turnNumber = cm:model():turn_number();
    local regionKey = region:name();
    local ramData = {
        ForceKey = regionKey..turnNumber..rebellionData.FactionKey,
        ArmySize = archetypeData.ArmySize,
        ForceData = rebellionData,
    };
    if string.match(ramData.ForceData.SubcultureKey, "_corruption") then
        ramData.ForceData.SubcultureKey = ramData.ForceData.SubcultureKey:match("(.-)_corruption");
    end
    self.Logger:Log("Generated general:"..archetypeData.AgentSubTypeKey.." and archetype: "..archetypeData.ArmyArchetypeKey);
    local forceString = self.ArmyGenerator:GenerateForceForTurn(ramData);
    if forceString == nil then
        self.Logger:Log("ERROR: Force string is nil");
        return;
    end
    self.Logger:Log("Got Force string");
    rebellionData.ForceString = forceString;
    -- Then we're done!
    return rebellionData;
end

function ERController:GetArmyArchetypeForRegionProvinceAndSubculture(region, rebellionSubculture, armyArchetypeOverrideKey)
    local armyArchetypeData = {};
    if string.match(rebellionSubculture, "corruption") then
        armyArchetypeData = self:GetCorruptionArmyArchetype(region, rebellionSubculture);
    elseif armyArchetypeOverrideKey == nil then
        local subcultureArmyArchetypes = self:GetSubcultureArmyArchetypes(region, rebellionSubculture);
        local armyArchetypeKey = GetRandomItemFromWeightedList(subcultureArmyArchetypes, true);
        local armyArchetypeResources = self:GetResourcesForRebelArmyArchetypes(rebellionSubculture, armyArchetypeKey);
        local agentSubTypeKey = "";
        for key, value in pairs(armyArchetypeResources.AgentSubtypes) do
            if key == 1 then
                agentSubTypeKey = GetRandomObjectFromList(armyArchetypeResources.AgentSubtypes);
            else
                agentSubTypeKey = GetRandomObjectKeyFromList(armyArchetypeResources.AgentSubtypes);
            end
            break;
        end
        armyArchetypeData = {
            ArmyArchetypeKey = armyArchetypeKey,
            AgentSubTypeKey = agentSubTypeKey,
            MandatoryUnits = armyArchetypeResources.MandatoryUnits,
            UnitTags = armyArchetypeResources.UnitTags,
            ArmySize = armyArchetypeResources.ArmySize,
            CanSpawnOnSea = armyArchetypeResources.CanSpawnOnSea,
            SpawnWithExistingCharacter = armyArchetypeResources.SpawnWithExistingCharacter,
            RebellionFaction = armyArchetypeResources.RebellionFaction,
        };
    else
        local subcultureArmyArchetypes = self:GetSubcultureArmyArchetypes(region, rebellionSubculture);
        local armyArchetypeResources = self:GetResourcesForRebelArmyArchetypes(rebellionSubculture, armyArchetypeOverrideKey);
        local agentSubTypeKey = "";
        for key, value in pairs(armyArchetypeResources.AgentSubtypes) do
            if key == 1 then
                agentSubTypeKey = GetRandomObjectFromList(armyArchetypeResources.AgentSubtypes);
            else
                agentSubTypeKey = GetRandomObjectKeyFromList(armyArchetypeResources.AgentSubtypes);
            end
            break;
        end
        armyArchetypeData = {
            ArmyArchetypeKey = armyArchetypeOverrideKey,
            AgentSubTypeKey = agentSubTypeKey,
            MandatoryUnits = armyArchetypeResources.MandatoryUnits,
            UnitTags = armyArchetypeResources.UnitTags,
            ArmySize = armyArchetypeResources.ArmySize,
            CanSpawnOnSea = armyArchetypeResources.CanSpawnOnSea,
            SpawnWithExistingCharacter = armyArchetypeResources.SpawnWithExistingCharacter,
            RebellionFaction = armyArchetypeResources.RebellionFaction,
        };
    end

    return armyArchetypeData;
end

-- Corruption armies work a bit differently, where as the normal rebels scale based off
-- of the turn number, corruption armies scale off of corruption level
function ERController:GetCorruptionArmyArchetype(region, corruptionRebellionSubculture)
    local defaultCorruptionSubcultureArchetypes = self:GetCorruptionRebelArmyArchetypesForSubculture(corruptionRebellionSubculture);
    local highestCorruptionArchetypes = {};
    local highestCorruptionArchetypeValue = 0;
    local religionKey = self:GetReligionKeyFromCorruptionKey(corruptionRebellionSubculture);
    local regionCorruptionValue = region:religion_proportion(religionKey);
    for archetypeKey, archetypeData in pairs(defaultCorruptionSubcultureArchetypes) do
        if archetypeData.CorruptionThreshold > highestCorruptionArchetypeValue
        and archetypeData.CorruptionThreshold < regionCorruptionValue then
            highestCorruptionArchetypes = {};
            highestCorruptionArchetypes[archetypeKey] = archetypeData;
        elseif archetypeData.CorruptionThreshold == highestCorruptionArchetypeValue then
            highestCorruptionArchetypes[archetypeKey] = archetypeData;
        end
    end
    local corruptionArchetypeKey = GetRandomItemFromWeightedList(highestCorruptionArchetypes, true);
    local armyArchetypeResources = defaultCorruptionSubcultureArchetypes[corruptionArchetypeKey];
    local corruptionArmyArchetypeData = {
        ArmyArchetypeKey = corruptionArchetypeKey,
        AgentSubTypeKey = GetRandomObjectFromList(armyArchetypeResources.AgentSubtypes),
        MandatoryUnits = armyArchetypeResources.MandatoryUnits,
        UnitTags = armyArchetypeResources.UnitTags,
        ArmySize = armyArchetypeResources.ArmySize,
        CanSpawnOnSea = armyArchetypeResources.CanSpawnOnSea,
    };
    return corruptionArmyArchetypeData;
end

function ERController:GetCorruptionRebelArmyArchetypesForSubculture(corruptionSubculture)
    return _G.ERResources.RebelCorruptionArmyArchetypesPoolData[corruptionSubculture][corruptionSubculture];
end

function ERController:GetReligionKeyFromCorruptionKey(corruptionKey)
    if corruptionKey == "wh_dlc03_sc_bst_beastmen_corruption" then
        return "wh_main_religion_chaos";
    elseif corruptionKey == "wh_main_sc_chs_chaos_corruption" then
        return "wh_main_religion_chaos";
    elseif corruptionKey == "wh2_main_sc_skv_skaven_corruption" then
        return "wh2_main_religion_skaven";
    elseif corruptionKey == "wh2_dlc11_sc_cst_vampire_coast_corruption" then
        return "wh_main_religion_undeath";
    elseif corruptionKey == "wh_main_sc_vmp_vampire_counts_corruption" then
        return "wh_main_religion_undeath";
    end
end

function ERController:GetSubcultureArmyArchetypes(region, rebellionSubculture)
    local provinceKey = region:province_name();
    local provinceRebellionResources = self:GetProvinceRebellionResources(provinceKey);
    if provinceRebellionResources.RebelSubcultures ~= nil then
        local subcultureProvinceRebellionResources = provinceRebellionResources.RebelSubcultures[rebellionSubculture];
        if subcultureProvinceRebellionResources ~= nil
        and subcultureProvinceRebellionResources.ArmyArchetypes ~= nil then
            return subcultureProvinceRebellionResources.ArmyArchetypes;
        end
    end
    -- If the province doesn't specify any archetypes for this subculture
    -- then we grab a random weighted one from the default pool
    local defaultSubcultureArchetypes = self:GetRebelArmyArchetypesForSubculture(rebellionSubculture);
    return defaultSubcultureArchetypes;
end

function ERController:GetRebelArmyArchetypesForSubculture(subculture)
    return _G.ERResources.RebelArmyArchetypesPoolData[subculture][subculture];
end

function ERController:GetResourcesForRebelArmyArchetypes(subculture, archetype)
    return _G.ERResources.RebelArmyArchetypesPoolData[subculture][subculture][archetype];
end

function ERController:GetResourcesForRebelCorruptionArmyArchetypes(subculture, archetype)
    if _G.ERResources.RebelCorruptionArmyArchetypesPoolData[subculture] == nil then
        return;
    end
    return _G.ERResources.RebelCorruptionArmyArchetypesPoolData[subculture][subculture][archetype];
end

function ERController:SpawnArmy(rebellionData, region, owningFaction, preKey)
    local factionKey = owningFaction:name();
    local spawnX, spawnY = -1, -1;
    local regionKey = region:name();
    if rebellionData.SpawnOnSea == true then
        self.Logger:Log("Attempting to spawn army on sea...");
        local spawnDistance = 10;
        repeat
            spawnX, spawnY = cm:find_valid_spawn_location_for_character_from_settlement(
                factionKey,
                regionKey,
                -- Spawn on sea
                true,
                -- Rebellion spawn
                true,
                spawnDistance
            );
            spawnDistance = spawnDistance + 10;
        until((spawnX ~= -1 and spawnY ~= -1) or spawnDistance == 150);
    end
    if spawnX == -1 or spawnY == -1 then
        spawnX, spawnY = cm:find_valid_spawn_location_for_character_from_settlement(
            factionKey,
            regionKey,
            -- Spawn on sea
            false,
            -- Rebellion spawn
            true,
            -- Spawn distance (optional).
            -- Note: 9 is the distance which is also used for Skaven
            -- under city incursions
            9
        );
    end
    if spawnX == -1 or spawnY == -1 then
        self.Logger:Log("ERROR: Not able to find a spawn coordinate.");
        return;
    else
        self.Logger:Log("Spawning at X: "..spawnX.." Y: "..spawnY);
    end
    local provinceKey = region:province_name();
    cm:create_force_with_general(
        rebellionData.FactionKey,
        rebellionData.ForceString,
        regionKey,
        spawnX,
        spawnY,
        "general",
        rebellionData.AgentSubTypeData.AgentSubTypeKey,
        rebellionData.AgentSubTypeData.ClanNameKey,
        "",
        rebellionData.AgentSubTypeData.ForeNameKey,
        "",
        false,
        function(cqi)
            local character = cm:get_character_by_cqi(cqi);
            local characterSubculture = character:faction():subculture();
            local militaryForce = character:military_force();
            local militaryForceCqi = militaryForce:command_queue_index();
            -- Store relevant data for later
            local turnNumber = cm:model():turn_number();
            self.Logger:Log("Rebellion spawned. Military force cqi is: "..militaryForceCqi);
            local characterLookupString = "character_cqi:"..cqi;
            if character:faction():is_quest_battle_faction() then
                -- Perform diplomacy and other setup commands. Note: Even though the QB factions are excluded
                -- from diplomacy by db, it seems like they can still make diplomatic offers to the player (and maybe the AI)
                -- Thats why I still need these commands.
                cm:force_diplomacy("faction:"..rebellionData.FactionKey, "all", "all", false, false, true);
                cm:force_diplomacy("faction:"..rebellionData.FactionKey, "all", "war", true, true, true);
                --local atWarWithFactions = {};
                -- Force war with targeted faction
                cm:force_declare_war(rebellionData.FactionKey, factionKey, false, false);
                --atWarWithFactions[rebellionData.FactionKey] = true;
                -- Then do the same for the player
                cm:force_declare_war(rebellionData.FactionKey, self.HumanFaction:name(), false, false);
                --atWarWithFactionsatWarWithFactionsatWarWithFactions[self.HumanFaction:name()] = true;
                -- Then do the same for any adjacent factions
                --[[local adjacentRegionList = region:adjacent_region_list();
                for i = 0, adjacentRegionList:num_items() - 1 do
                    local adjacentRegion = adjacentRegionList:item_at(i);
                    if adjacentRegion:is_null_interface() == false
                    and adjacentRegion:is_abandoned() == false
                    and atWarWithFactions[adjacentRegion:owning_faction():name()] == nil then
                        atWarWithFactions[adjacentRegion:owning_faction():name()] = true;
                        cm:force_declare_war(rebellionData.FactionKey, adjacentRegion:owning_faction():name(), false, false);
                    end
                end--]]
                -- Apply the specified art set id
                cm:add_unit_model_overrides(cm:char_lookup_str(cqi), rebellionData.AgentSubTypeData.AgentArtSetId);
                -- Disable movement so they won't run away
                cm:cai_disable_movement_for_character(characterLookupString);
                -- Force them into raiding stance so they take some money from the faction but only on land
                if rebellionData.SpawnOnSea == false then
                    cm:force_character_force_into_stance(characterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
                end
                self:ApplyIncursionCustomEffectBundle(regionKey);
                -- We give the army free upkeep and attrition immunity
                cm:apply_effect_bundle_to_force("wh_main_bundle_military_upkeep_free_force", militaryForceCqi, -1);
                cm:apply_effect_bundle_to_force("wh2_dlc11_bundle_immune_all_attrition", militaryForceCqi, -1);
            -- If we don't have a QB faction then we need to use different rules
            else
                -- Force war with targeted faction
                cm:force_declare_war(rebellionData.FactionKey, factionKey, false, false);
                -- We give the army free upkeep and attrition immunity for 20 turns to lets the faction catch up
                cm:apply_effect_bundle_to_force("wh_main_bundle_military_upkeep_free_force", militaryForceCqi, 20);
                cm:apply_effect_bundle_to_force("wh2_dlc11_bundle_immune_all_attrition", militaryForceCqi, 20);
            end
            local showMessage = (factionKey == self.HumanFaction:name());
            if showMessage == true then
                local factionCqi = self.HumanFaction:command_queue_index();
                if preKey ~= nil then
                    local preResources = self:GetPREPoolDataResource(character:faction():subculture(), character:faction():name(), preKey);
                    local selectedIncidentKey = "";
                    if preResources.InitialRebellionIncident[region:owning_faction():subculture()] == nil then
                        selectedIncidentKey = preResources.InitialRebellionIncident["default"];
                    else
                        selectedIncidentKey = preResources.InitialRebellionIncident[region:owning_faction():subculture()];
                    end
                    cm:trigger_incident_with_targets(factionCqi, selectedIncidentKey, factionCqi, 0, 0, 0, region:cqi(), 0);
                else
                    cm:trigger_incident_with_targets(factionCqi, "er_generic_incursion", factionCqi, 0, 0, 0, region:cqi(), 0);
                end
            end
            -- When spawning existing characters we don't add any XP or ancilliaries
            if rebellionData.SpawnWithExistingCharacter == true then
                self.Logger:Log("Trying to find existing character....");
                local existingCharacterFaction = character:faction();
                local factionLeader = existingCharacterFaction:faction_leader();
                local existingCharacterLookupString = "";
                local existingCharacter = {};
                -- First we check the faction leader if they are the rebellion leader (this should be the most common case)
                if factionLeader:character_subtype_key() == rebellionData.AgentSubTypeData.AgentSubTypeKey then
                    self.Logger:Log("Character is faction leader");
                    existingCharacter = factionLeader;
                    existingCharacterLookupString = "character_cqi:"..factionLeader:command_queue_index();
                    cm:appoint_character_to_most_expensive_force(existingCharacterLookupString);
                    self.Logger:Log("Faction leader appointed to most expensive force");
                else
                    -- If the faction leader isn't the archetype we are looking for then it might be another LL within the faction
                    -- like Volkmar or Ghorst
                    local factionCharacterList = existingCharacterFaction:character_list();
                    for i = 1, factionCharacterList:num_items() do
                        local existingFactionCharacter = factionCharacterList:item_at(i);
                        if existingFactionCharacter:character_subtype_key() ==  rebellionData.AgentSubTypeData.AgentSubTypeKey
                        and existingFactionCharacter:has_military_force() == false then
                            self.Logger:Log("Found character!");
                            existingCharacter = existingFactionCharacter;
                            existingCharacterLookupString = "character_cqi:"..existingFactionCharacter:command_queue_index();
                            cm:appoint_character_to_most_expensive_force(existingCharacterLookupString);
                            break;
                        end
                    end
                end
                cm:callback(function()
                    -- Kill the original character
                    cm:kill_character(character:command_queue_index(), true, true);
                    -- Disable movement so they won't run away
                    cm:cai_disable_movement_for_character(existingCharacterLookupString);
                    -- Force them into raiding stance so they take some money from the faction but only on land
                    if rebellionData.SpawnOnSea == false then
                        cm:force_character_force_into_stance(existingCharacterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
                    end
                    local armyArchetypeData = self:GetArmyArchetypeData(rebellionData.SubcultureKey, rebellionData.ArmyArchetypeKey);
                    local agentSubTypeSpawnData = armyArchetypeData.AgentSubtypes[rebellionData.AgentSubTypeData.AgentSubTypeKey];
                    if agentSubTypeSpawnData ~= nil and agentSubTypeSpawnData.AgentSubTypeMount ~= nil then
                        if existingCharacter:has_ancillary(agentSubTypeSpawnData.AgentSubTypeMount) == false then
                            cm:force_add_ancillary(existingCharacter, agentSubTypeSpawnData.AgentSubTypeMount, true, true);
                        end
                    end
                end, 2);
            else
                local bonusXpLevels = 0;
                local armyArchetypeData = self:GetArmyArchetypeData(rebellionData.SubcultureKey, rebellionData.ArmyArchetypeKey);
                local agentSubTypeSpawnData = armyArchetypeData.AgentSubtypes[rebellionData.AgentSubTypeData.AgentSubTypeKey];
                if agentSubTypeSpawnData ~= nil then
                    bonusXpLevels = agentSubTypeSpawnData.MinimumLevel + Random(3);
                else
                    bonusXpLevels = math.ceil(turnNumber / 10) + Random(3);
                end
                if bonusXpLevels > 20 then
                    bonusXpLevels = 20;
                end
                cm:add_agent_experience(characterLookupString, bonusXpLevels, true)
                cm:callback(function()
                    if agentSubTypeSpawnData ~= nil and agentSubTypeSpawnData.AgentSubTypeMount ~= nil then
                        cm:force_add_ancillary(character, agentSubTypeSpawnData.AgentSubTypeMount, true, true);
                    end
                end, 1);
            end
            self.Logger:Log("Adding to active rebellions");
            if self.ActiveRebellions[provinceKey] == nil then
                self.ActiveRebellions[provinceKey] = {
                    Forces = {militaryForceCqi,},
                    TurnNumber = turnNumber,
                };
            else
                self.Logger:Log("Rebels have already appeared in region. Adding new force");
                local existingForces = self.ActiveRebellions[provinceKey].Forces;
                existingForces[#existingForces + 1] = militaryForceCqi;
            end
            if self.RebelForces[tostring(militaryForceCqi)] == nil then
                local cleanUpForce = true;
                if preKey ~= nil then
                    self.Logger:Log("Getting pre resources: "..preKey);
                    local preResources = self:GetPREPoolDataResource(rebellionData.SubcultureKey, rebellionData.FactionKey, preKey);
                    cleanUpForce = preResources.CleanUpRebelForce;
                end
                self.RebelForces[tostring(militaryForceCqi)] = {
                    Target = regionKey,
                    SpawnTurn = turnNumber,
                    SubcultureKey = rebellionData.SubcultureKey,
                    AgentSubTypeKey = rebellionData.AgentSubTypeData.AgentSubTypeKey,
                    ArmyArchetypeKey = rebellionData.ArmyArchetypeKey,
                    SpawnedOnSea = rebellionData.SpawnOnSea,
                    SpawnCoordinates = spawnX.."/"..spawnY,
                    CleanUpForce = cleanUpForce,
                };
            else
                self.Logger:Log("ERROR: Military force cqi already exists");
            end
            cm:callback(function() core:trigger_event("ER_ScriptedEventEnableDiplomacy"); end, 0);
            self.Logger:Log_Finished();
        end
    );
end

function ERController:GrantUnitsForForce(rebelForceData, militaryForce)
    if militaryForce:unit_list():num_items() >= 19 then
        self.Logger:Log("Maximum units already in army");
        return;
    end
    local general = militaryForce:general_character();
    local generalFaction = general:faction():name();
    local generalSubculture = general:faction():subculture();
    local generalLookupString = cm:char_lookup_str(general);
    local armyArchetypeResources = self:GetResourcesForRebelArmyArchetypes(generalSubculture, rebelForceData.ArmyArchetypeKey);
    if armyArchetypeResources == nil then
        self.Logger:Log("Missing archetype resources, trying corruption resources...");
        armyArchetypeResources = self:GetResourcesForRebelCorruptionArmyArchetypes(generalSubculture.."_corruption", rebelForceData.ArmyArchetypeKey);
        if armyArchetypeResources == nil and generalSubculture == "wh_main_sc_grn_greenskins" then
            self.Logger:Log("Still missing archetype resources, trying savage orc resources...");
            armyArchetypeResources = self:GetResourcesForRebelArmyArchetypes("wh_main_sc_grn_savage_orcs", rebelForceData.ArmyArchetypeKey);
        end
        if armyArchetypeResources == nil then
            self.Logger:Log("ERROR: Can't find archetype army resources");
            return;
        end
    end

    local maximumNumberOfExtraUnits = 19 - militaryForce:unit_list():num_items();
    if maximumNumberOfExtraUnits > 2 then
        maximumNumberOfExtraUnits = 2;
    end

    local turnNumber = cm:model():turn_number();
    local ramData = {
        ForceKey = rebelForceData.Target..turnNumber..generalFaction,
        -- Generate between 1 and 2 additional units
        ArmySize = Random(maximumNumberOfExtraUnits, 1),
        -- Force data
        ForceData = {
            SubcultureKey = generalSubculture,
            UnitTags = { armyArchetypeResources.UnitTags[1], },
        },
    };

    local additionalUnits = self.ArmyGenerator:GenerateForceForTurn(ramData);
    for additionalUnit in string.gmatch(additionalUnits, "[^,]+") do
        self.Logger:Log("Adding unit: "..additionalUnit);
        cm:grant_unit_to_character(generalLookupString, additionalUnit);
     end
end

function ERController:AddPastRebellion(rebelForce)
    local turnNumber = cm:model():turn_number();
    local regionObject = cm:get_region(rebelForce.Target);
    local provinceKey = regionObject:province_name();

    if self.PastRebellions[provinceKey] == nil then
        self.PastRebellions[provinceKey] = {};
    end
    local pastRebellionsForProvince = self.PastRebellions[provinceKey];
    pastRebellionsForProvince[#pastRebellionsForProvince + 1] = {
        SpawnTurn = rebelForce.SpawnTurn,
        SubcultureKey = rebelForce.SubcultureKey,
        AgentSubTypeKey = rebelForce.AgentSubTypeKey,
        ArmyArchetypeKey = rebelForce.ArmyArchetypeKey,
        TargetRegion = rebelForce.Target,
        TargetFaction = regionObject:owning_faction():name(),
        DestroyedTurn = turnNumber,
    };
end

function ERController:IsProvinceInTimeout(provinceKey, factionKey)
    local rebellionsForProvinces = self.PastRebellions[provinceKey];
    if rebellionsForProvinces == nil then
        return false;
    end
    local turnNumber = cm:model():turn_number();
    local lastRebellionTurn = 0;
    for index, pastProvinceRebellions in pairs(rebellionsForProvinces) do
        if pastProvinceRebellions.DestroyedTurn ~= nil
        and pastProvinceRebellions.DestroyedTurn > lastRebellionTurn
        and pastProvinceRebellions.TargetFaction == factionKey then
            lastRebellionTurn = pastProvinceRebellions.DestroyedTurn;
        end
    end
    local timeoutThreshold = self:GetTimeoutForDifficulty();
    -- We have a timeout of 2 turns since the last rebellion was destroyed.
    if turnNumber > lastRebellionTurn + timeoutThreshold then
        return false;
    end
    return true;
end

function ERController:GetTimeoutForDifficulty()
    local difficulty = cm:get_difficulty(true);
    local timeout = 0;
    if difficulty == "easy" then
        timeout = 4;
    elseif difficulty == "normal" then
        timeout = 3;
    elseif difficulty == "hard" then
        timeout = 2;
    elseif difficulty == "very hard" then
        timeout = 3;
    elseif difficulty == "legendary" then
        timeout = 4;
    end
    return timeout;
end

function ERController:GetCustomEffectBundleBaseAmountForDifficulty()
    local difficulty = cm:get_difficulty(true);
    local timeout = 0;
    if difficulty == "easy" then
        timeout = 0;
    elseif difficulty == "normal" then
        timeout = 0;
    elseif difficulty == "hard" then
        timeout = 2;
    elseif difficulty == "very hard" then
        timeout = 4;
    elseif difficulty == "legendary" then
        timeout = 8;
    end
    return timeout;
end

function ERController:UpdateDefeatedRebelEffectBundle(regionKey)
    -- Remove the incursion effect bundle (if it is still there)
    cm:remove_effect_bundle_from_region("er_effect_bundle_generic_incursion_region", regionKey);
    local customEffectBundle = cm:create_new_custom_effect_bundle("er_effect_bundle_generic_incursion_defeated");
    customEffectBundle:set_duration(5);
    local publicOrderAmount = self:GetCustomEffectBundleBaseAmountForDifficulty() + 10;
    customEffectBundle:add_effect("wh_main_effect_public_order_events", "region_to_province_own", publicOrderAmount);
    local region = cm:get_region(regionKey);
    -- Then add a larger public order boost to celebrate beating the rebels
    cm:apply_custom_effect_bundle_to_region(customEffectBundle, region);
end

function ERController:ApplyIncursionCustomEffectBundle(regionKey)
    -- Apply an effect bundle which gives a minor public order boost, reduces income and movement for a few turns
    local customEffectBundle = cm:create_new_custom_effect_bundle("er_effect_bundle_generic_incursion_region");
    customEffectBundle:set_duration(5);
    local publicOrderAmount = self:GetCustomEffectBundleBaseAmountForDifficulty() + 5;
    customEffectBundle:add_effect("wh_main_effect_public_order_events", "region_to_province_own", publicOrderAmount);
    local region = cm:get_region(regionKey);
    cm:apply_custom_effect_bundle_to_region(customEffectBundle, region);
end

function ERController:GetLastRebellionData(provinceKey)
    local rebellionsForProvinces = self.PastRebellions[provinceKey];
    if rebellionsForProvinces == nil then
        return nil;
    end
    local turnNumber = cm:model():turn_number();
    local lastRebellionTurn = 0;
    local lastRebellionData = nil;
    for index, pastProvinceRebellion in pairs(rebellionsForProvinces) do
        -- We don't bother counting rebellions which happened more than
        -- X amount of turns ago since it shouldn't be repetitive
        if pastProvinceRebellion.DestroyedTurn ~= nil
        and pastProvinceRebellion.DestroyedTurn + 15 < turnNumber
        and pastProvinceRebellion.DestroyedTurn > lastRebellionTurn then
            lastRebellionTurn = pastProvinceRebellion.DestroyedTurn;
            lastRebellionData = pastProvinceRebellion;
        end
    end
    if lastRebellionData ~= nil then
        return lastRebellionData;
    end
    return nil;
end

function ERController:GetRebellionRegionForNewRebellion(region)
    local provinceKey = region:province_name();
    local owningFactionKey = region:owning_faction():name();
    local adjacentRegionList = region:adjacent_region_list();
    local numValidRegions = 1;
    local validRegionsInProvince = {};
    validRegionsInProvince[region:name()] = true;
    for i = 0, adjacentRegionList:num_items() - 1 do
        local adjacentRegion = adjacentRegionList:item_at(i);
        if adjacentRegion:is_null_interface() == false
        and adjacentRegion:is_abandoned() == false
        and adjacentRegion:province_name() == provinceKey
        and adjacentRegion:owning_faction():name() == owningFactionKey
        and adjacentRegion:owning_faction():is_quest_battle_faction() == false
        and validRegionsInProvince[adjacentRegion:name()] == nil then
            validRegionsInProvince[adjacentRegion:name()] = true;
            numValidRegions = numValidRegions + 1;
        end
    end
    -- This is a testing override to trigger rebellions in specific regions
    -- in provinces
    --[[if region:name() == "wh_main_couronne_et_languille_couronne" then
        self.Logger:Log("Override rebellion in region");
        return "wh_main_couronne_et_languille_languille";
    end--]]
    -- If the province only has 1 region
    -- or the player only has 1 of the regions
    -- we still should spawn a rebellion,
    -- even if they had one recently in that region
    if numValidRegions == 1 then
        if region:owning_faction():is_quest_battle_faction() == true then
            return nil;
        end
        return GetRandomObjectKeyFromList(validRegionsInProvince);
    end

    local pastRebellionData = self:GetLastRebellionData(provinceKey);
    -- Similarly as above, if there isn't any past rebellion regions to
    -- exclude we just grab a random region
    if pastRebellionData == nil then
        return GetRandomObjectKeyFromList(validRegionsInProvince);
    end
    -- If we got a past rebellion in the province we must be able to exclude
    -- it.
    validRegionsInProvince[pastRebellionData.Target] = nil;
    return GetRandomObjectKeyFromList(validRegionsInProvince);
end

function ERController:DoesProvinceHaveRebelForces(provinceKey)
    return self.ActiveRebellions[provinceKey] ~= nil and TableHasAnyValue(self.ActiveRebellions[provinceKey].Forces);
end

function ERController:UpdateExistingRebels(region)
    local provinceKey = region:province_name();
    local rebellionInFactionProvince = false;
    -- If we have (or had) active rebellions check whether we need to clean them
    -- up or perform other actions besides attacking
    local doesProvinceHaveRebelForces = self:DoesProvinceHaveRebelForces(provinceKey);
    if doesProvinceHaveRebelForces == true then
        local factionKey = region:owning_faction():name();
        local turnNumber = cm:model():turn_number();
        local rebelData = self.ActiveRebellions[provinceKey];
        for index, militaryForceCqi in pairs(rebelData.Forces) do
            local militaryForce = cm:model():military_force_for_command_queue_index(tonumber(militaryForceCqi));
            local rebelForceData = self.RebelForces[tostring(militaryForceCqi)];
            local rebelForceTarget = cm:get_region(rebelForceData.Target);
            if rebelForceTarget:is_null_interface() == false
            and rebelForceTarget:is_abandoned() == true then
                local rebelForceTargetRegionKey = rebelForceTarget:name();
                self.Logger:Log("Target region is abandoned: "..rebelForceTargetRegionKey);
                local character = militaryForce:general_character();
                local characterLookupString = "character_cqi:"..character:command_queue_index();
                cm:cai_enable_movement_for_character(characterLookupString);
                self.Logger:Log("Untracking military force "..militaryForceCqi);
                rebelData.Forces[index] = nil;
                self:AddPastRebellion(rebelForceData);
                self.RebelForces[militaryForceCqi] = nil;
                -- Finally, we kill them and their force
                if rebelForceData.CleanUpRebelForce == true then
                    cm:kill_character(character:command_queue_index(), true, true);
                end
                self.Logger:Log_Finished();
            elseif rebelForceTarget:owning_faction():name() == factionKey then
                rebellionInFactionProvince = true;
                local rebelForceTargetRegionKey = rebelForceTarget:name();
                -- We need to first check for cases where we need to remove any rebels in the province
                -- This happens when the rebels have been killed.
                if militaryForce == nil
                or militaryForce:is_null_interface() then
                    if militaryForce == nil then
                        self.Logger:Log("Military force is missing");
                    end
                    self.Logger:Log("Rebellion force: "..militaryForceCqi.." is missing from region: "..rebelForceTargetRegionKey);
                    rebelData.Forces[index] = nil;
                    self:AddPastRebellion(rebelForceData);
                    self.RebelForces[militaryForceCqi] = nil;
                    self.Logger:Log_Finished();
                    self:UpdateDefeatedRebelEffectBundle(rebelForceTargetRegionKey);
                else
                    local character = militaryForce:general_character();
                    -- To ensure we are only updating a rebel force once per turn
                    -- we check if the target region owner matches the faction whose turn we are
                    -- checking
                    if region:owning_faction():name() == rebelForceTarget:owning_faction():name() then
                        self.Logger:Log("Checking military force: "..militaryForceCqi);
                        if rebelForceData.SpawnedOnSea == true
                        and character:region():is_null_interface() then
                            self.Logger:Log("Character is in sea still");
                            local characterLookupString = "character_cqi:"..character:command_queue_index();
                            local owningFactionKey = rebelForceTarget:owning_faction():name();
                            local interimX, interimY = cm:find_valid_spawn_location_for_character_from_settlement(
                                owningFactionKey,
                                rebelForceTargetRegionKey,
                                -- Spawn on sea
                                false,
                                -- Rebellion spawn
                                true,
                                -- Spawn distance (optional).
                                -- Note: 9 is the distance which is also used for Skaven
                                -- under city incursions
                                9
                            );
                            cm:teleport_to(characterLookupString, interimX, interimY, true);
                            cm:cai_disable_movement_for_character(characterLookupString);
                            cm:force_character_force_into_stance(characterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
                        elseif rebelForceData.SpawnTurn + 3 > turnNumber
                        and rebelForceData.SpawnedOnSea == false then
                            self.Logger:Log("Granting units to rebellion in region: "..rebelForceTargetRegionKey);
                            local characterLookupString = "character_cqi:"..character:command_queue_index();
                            if rebelForceData.SpawnedOnSea == false then
                                cm:force_character_force_into_stance(characterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
                            end
                            self:GrantUnitsForForce(rebelForceData, militaryForce);
                        else
                            local positionString = character:logical_position_x().."/"..character:logical_position_y();
                            -- The character should move on the turn after we tell them to attack
                            -- If their position matches their spawn position, then they are stuck
                            -- and should be removed. This is pretty rare but can happen in some settlements
                            if rebelForceData.SpawnTurn + 5 < turnNumber
                            and positionString == rebelForceData.SpawnCoordinates then
                                self.Logger:Log("Military force has stuck around too long, removing the force for faction: "..character:faction():name());
                                -- Clean up force data
                                rebelData.Forces[index] = nil;
                                self:AddPastRebellion(rebelForceData);
                                self.RebelForces[militaryForceCqi] = nil;
                                -- Finally, we kill them and their force
                                cm:kill_character(character:command_queue_index(), true, true);
                                self.Logger:Log_Finished();
                            end
                        end
                        self.Logger:Log_Finished();
                    end
                end
            end
        end
    end
    return rebellionInFactionProvince;
end

function ERController:CheckForRebelSpawn(region)
    local publicOrder = region:public_order();
    -- If public order is negative and we don't already have a rebellion
    -- Perform more actions to check if they can spawn and if it passes, spawn them
    if publicOrder < 0 then
        local rebellionChance = math.abs(publicOrder);
        if rebellionChance > 50 and rebellionChance ~= 100 then
            rebellionChance = 50;
        end
        local spawnRebellion = Roll100(rebellionChance);
        if spawnRebellion then
            local provinceKey = region:province_name();
            local faction = region:owning_faction();
            local factionKey = faction:name();
            local regionKey = region:name();
            -- We have a timeout since the last rebellion was destroyed.
            local regionPreData = self:GetSpawnablePREForProvince(region);
            if regionPreData ~= nil then
                if regionPreData.IsRebelSpawnLocked == true then
                    self.Logger:Log("Spawn is locked");
                else
                    self:StartFactionReemergeance(region, regionPreData);
                    self:AddPastPRE(region, regionPreData);
                    self.Logger:Log("Faction: "..regionPreData.PREFaction.." has reemerged in province: "..provinceKey);
                    self.Logger:Log_Finished();
                end
            elseif self:IsActiveMilitaryCrackDown(factionKey, false, provinceKey) == false then
                local isInTimeout = self:IsProvinceInTimeout(provinceKey, factionKey);
                if isInTimeout == true then
                    self.Logger:Log("Can't spawn rebels for faction: "..factionKey.." because one was destroyed recently for faction.");
                else
                    self.Logger:Log("Spawning rebellion in province: "..provinceKey.." for faction: "..factionKey);
                    local rebellionRegionKey = self:GetRebellionRegionForNewRebellion(region);
                    if rebellionRegionKey == nil then
                        self.Logger:Log("Can't trigger rebellion in region");
                    else
                        cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
                        self.Logger:Log("Rebellion will trigger in region: "..rebellionRegionKey);
                        local rebellionRegion = cm:get_region(rebellionRegionKey);
                        self:StartRebellion(rebellionRegion, faction);
                        self.Logger:Log("Spawned rebellion in province: "..provinceKey);
                        self.Logger:Log_Finished();
                        return true;
                    end
                end
            else
                self.Logger:Log("Region is under military crackdown");
            end
            self.Logger:Log_Finished();
        end
    end
    return false;
end

function ERController:GetSpawnablePREForProvince(region)
    local faction = region:owning_faction();
    local provinceKey = region:province_name();
    local presForProvince = self.ActivePREs[provinceKey];
    if presForProvince ~= nil then
        self.Logger:Log("Found PRE in province: "..provinceKey);
        for index, activePREData in pairs(presForProvince) do
            if region:name() == activePREData.TargetRegion then
                return activePREData;
            end
        end
    end
    return nil;
end

function ERController:UpdatePREs(region)
    local regionKey = region:name();
    local faction = region:owning_faction();
    local provinceKey = region:province_name();
    local turnNumber = cm:model():turn_number();
    local presForProvince = self.ActivePREs[provinceKey];
    local spawnedRebellion = false;
    if presForProvince ~= nil then
        self.Logger:Log("Found PRE in province: "..provinceKey);
        for index, activePREData in pairs(presForProvince) do
            self.Logger:Log("Checking PRE: "..activePREData.PREKey);
            local preResourceData = self:GetPREPoolDataResource(activePREData.PRESubculture, activePREData.PREFaction, activePREData.PREKey);
            local showMessage = (faction:name() == self.HumanFaction:name());
            if showMessage == true then
                -- Check incidents
                local subcultureIncidents = preResourceData.Incidents[faction:subculture()];
                if subcultureIncidents == nil then
                    subcultureIncidents = preResourceData.Incidents["default"];
                end
                for incidentKey, incidentData in pairs(subcultureIncidents) do
                    if turnNumber == incidentData.NumberOfTurns + activePREData.SpawnTurnNumber then
                        self.Logger:Log("Triggering PRE incident: "..incidentKey);
                        cm:trigger_incident_with_targets(faction:command_queue_index(), incidentKey, faction:command_queue_index(), 0, 0, 0, region:cqi(), 0);
                    end
                end
                -- Check auto dilemmas
                local autoDilemmas = preResourceData.AutoDilemmas[faction:subculture()];
                if autoDilemmas == nil then
                    autoDilemmas = preResourceData.AutoDilemmas["default"];
                end
                for dilemmaKey, dilemmaData in pairs(autoDilemmas) do
                    if turnNumber == dilemmaData.NumberOfTurns + activePREData.SpawnTurnNumber then
                        self.Logger:Log("Triggering PRE auto dilemma: "..dilemmaKey);
                        cm:trigger_dilemma_with_targets(faction:command_queue_index(), dilemmaKey, faction:command_queue_index(), 0, 0, 0, region:cqi(), 0);
                    end
                end
            end
            -- Check rebel spawn
            self.Logger:Log("CurrentTurn: "..turnNumber.." PRE emerge turn: "..(preResourceData.PREDuration + activePREData.SpawnTurnNumber));
            if turnNumber >= preResourceData.PREDuration + activePREData.SpawnTurnNumber then
                spawnedRebellion = true;
                self:StartFactionReemergeance(region, activePREData);
                self:AddPastPRE(region, activePREData);
                self.Logger:Log("Faction: "..activePREData.PREFaction.." has reemerged in province: "..provinceKey);
                self.Logger:Log_Finished();
            else
                self.Logger:Log_Finished();
            end
        end
    end
    return spawnedRebellion;
end

function ERController:StartFactionReemergeance(region, activePREData)
    local provinceKey = region:province_name();
    local provinceResources = self:GetProvinceRebellionResources(provinceKey);
    local rebellionProvinceData = {
        SubcultureKey = activePREData.PRESubculture,
        IsAdjacentToSea = provinceResources.IsAdjacentToSea,
    };
    local preResources = self:GetPREPoolDataResource(activePREData.PRESubculture, activePREData.PREFaction, activePREData.PREKey)
    local armyArchetypeKey = GetRandomObjectFromList(preResources.ArmyArchetypes);
    local targetRegion = {};
    if region:is_province_capital() == true then
        targetRegion = region;
    else
        local adjacentRegionList = region:adjacent_region_list();
        for i = 0, adjacentRegionList:num_items() - 1 do
            local adjacentRegion = adjacentRegionList:item_at(i);
            if adjacentRegion:province_name() == provinceKey
            and adjacentRegion:is_province_capital() == true then
                targetRegion = region;
            end
        end
    end
    -- Get general/army data
    local forceData = self:GetForceDataForRegionAndSubculture(targetRegion, rebellionProvinceData, armyArchetypeKey);
    -- Spawn army
    local owningFaction = targetRegion:owning_faction();
    self:SpawnArmy(forceData, targetRegion, owningFaction, activePREData.PREKey);
    self.ReemergedFactions[activePREData.PREFaction] = true;
end

function ERController:SpawnPREs(region)
    local provinceKey = region:province_name();
    if self.ActivePREs[provinceKey] ~= nil
    and TableHasAnyValue(self.ActivePREs[provinceKey]) then
        return;
    end
    -- Generate pool of PREs, this includes generic and region specific
    local presForRegion = self:GeneratePREPoolForRegion(region);
    -- Check criteria for each PRE
    for preKey, preData in pairs(presForRegion) do
        self.Logger:Log("Found potential pre in region: "..preKey);
        if string.match(preKey, "ReemergeanceArchetype") then
            local passedCriteria = self:CheckReemergeanceCriteria(region, preKey, preData);
            if passedCriteria == true then
                self.Logger:Log("PRE "..preKey.." passed ReemergeanceArchetype criteria");
            else
                --self.Logger:Log("PRE "..preKey.." failed ReemergeanceArchetype criteria");
                presForRegion[preKey] = nil;
            end
        else
            -- Check generic criteria
            --self.Logger:Log("Does not match ReemergeanceArchetype criteria");
        end
    end
    if TableHasAnyValue(presForRegion) then
        -- Select a randomly weighted PRE with valid criteria
        local selectedPRE = GetRandomObjectKeyFromList(presForRegion);
        local selectedPREData = presForRegion[selectedPRE];
        self:AddPREToRegion(region, selectedPRE, selectedPREData);
    end
end

function ERController:CheckReemergeanceCriteria(region, preKey, preData)
    local provinceKey = region:province_name();
    local turnNumber = cm:model():turn_number();
    -- If we are more than 50 turns into a campaign and the faction is dead
    local faction = cm:get_faction(preData.PREFactionKey);
    if turnNumber > 0
    and not faction:is_null_interface()
    and faction:is_dead() == true then
        local owningFaction = "";
        if region:is_abandoned() == false then
            owningFaction = region:owning_faction();
        else
            return false;
        end
        local isHumanOwner = owningFaction:name() == self.HumanFaction:name();
        local testChance = 10;
        if isHumanOwner == true then
            testChance = 50;
        end
        -- If it passes the random roll and PRE is not already active and PRE has not triggered previously
        -- and they have not been confederated
        if Roll100(testChance) == true
        and not self.ConfederatedFactions[preData.PREFactionKey]
        and owningFaction:subculture() ~= preData.PRESubculture
        and not self.ReemergedFactions[preData.PREFactionKey]
        and (self.ActivePREs[provinceKey] == nil or (self.ActivePREs[provinceKey] ~= nil and self.ActivePREs[provinceKey][preKey] == nil)) then
            local factionControlsCapitalInProvince = region:is_province_capital() == true;
            -- Then we check adjacent regions
            if factionControlsCapitalInProvince == false then
                local adjacentRegionList = region:adjacent_region_list();
                for i = 0, adjacentRegionList:num_items() - 1 do
                    local adjacentRegion = adjacentRegionList:item_at(i);
                    if adjacentRegion:province_name() == provinceKey
                    and adjacentRegion:owning_faction():name() == region:owning_faction():name()
                    and adjacentRegion:is_province_capital() == true then
                        factionControlsCapitalInProvince = true;
                        break;
                    end
                end
            end
            return factionControlsCapitalInProvince;
        end
    end
    --self.Logger:Log("Faction cannot reemerge");
    return false;
end

function ERController:GeneratePREPoolForRegion(region)
    local prePool = {};
    local regionKey = region:name();
    local provinceKey = region:province_name();
    local faction = region:owning_faction();
    local factionKey = faction:name();
    local subcultureKey = faction:subculture();
    local publicOrder = region:public_order();
    local validPreData = {};
    -- Grab generic PREs for the occupying subculture
    local genericResources = self:GetPRESubculturePoolDataResources(subcultureKey, factionKey);
    for preKey, genericPREData in pairs(genericResources) do
        --self.Logger:Log("Found generic PRE: "..preKey);
        if genericPREData.Weighting > 0 then
            validPreData[preKey] = {
                PRESubcultureKey = subcultureKey,
                PREFactionKey = factionKey,
                PREData = genericPREData,
                Weighting = genericPREData.Weighting,
            };
        end
    end
    -- Grab the region specific PREs
    local provinceResources = self:GetProvinceRebellionResources(provinceKey);
    if provinceResources.PassiveRebelEvents ~= nil then
        for subcultureRegionPREKey, regionSubculturePREData in pairs(provinceResources.PassiveRebelEvents) do
            local subculturePREs = self:GetPRESubculturePoolDataResources(subcultureRegionPREKey, factionKey);
            for preKey, regionPREData in pairs(regionSubculturePREData) do
                local preData = subculturePREs[preKey];
                if preData ~= nil
                and tonumber(publicOrder) > preData.MinimumRequriedPublicOrder then
                    local armyArchetypeKey = GetRandomObjectFromList(preData.ArmyArchetypes);
                    local armyArchetypeResources = self:GetArmyArchetypeData(subcultureRegionPREKey, armyArchetypeKey);
                    validPreData[preKey] = {
                        PRESubcultureKey = subcultureRegionPREKey,
                        PREFactionKey = armyArchetypeResources.RebellionFaction,
                        PREData = preData,
                        Weighting = preData.Weighting,
                    };
                else
                    self.Logger:Log("Public order is less than required threshold");
                end
            end
        end
    end
    return validPreData;
end

function ERController:GetPRESubculturePoolDataResources(subcultureKey, factionKey)
    local preResources = {};
    local subcultureResourceGrouping = _G.ERResources.PassiveRebelEventsPoolData[subcultureKey];
    if subcultureResourceGrouping == nil then
        return preResources;
    end
    -- Grab the subculture resources
    for preKey, preData in pairs(subcultureResourceGrouping[subcultureKey]) do
        preResources[preKey] = preData;
    end
    -- Grab the faction resources if they exist
    if factionKey ~= nil and subcultureResourceGrouping[factionKey] ~= nil then
        for preKey, preData in pairs(subcultureResourceGrouping[factionKey]) do
            -- If a PRE is key is set to false and it exists in the generic PREs
            -- then that means we should remove it from the pool for this faction.
            -- This doesn't have any use case now but would be handy for the hybrid
            -- factions like Arkhan who wouldn't have the same PREs as Tomb Kings
            if preResources[preKey] ~= nil and preData == false then
                preResources[preKey] = nil;
            else
                preResources[preKey] = preData;
            end
        end
    end
    return preResources;
end

function ERController:GetPREPoolDataResource(subcultureKey, factionKey, preKey)
    if _G.ERResources.PassiveRebelEventsPoolData[subcultureKey][factionKey] == nil
    or _G.ERResources.PassiveRebelEventsPoolData[subcultureKey][factionKey][preKey] == nil then
        return _G.ERResources.PassiveRebelEventsPoolData[subcultureKey][subcultureKey][preKey];
    end
    return _G.ERResources.PassiveRebelEventsPoolData[subcultureKey][factionKey][preKey];
end

function ERController:AddPREToRegion(region, preKey, preData)
    local regionKey = region:name();
    local provinceKey = region:province_name();
    local turnNumber = cm:model():turn_number();
    -- Map data into structure we are saving for later
    local activePRE = {
        PREKey = preKey,
        PRESubculture = preData.PRESubcultureKey,
        PREFaction = preData.PREFactionKey,
        SpawnTurnNumber = turnNumber,
        PREDuration = preData.PREData.PREDuration,
        TargetRegion = regionKey,
        IsRebelSpawnLocked = false,
    };
    if self.ActivePREs[provinceKey] == nil then
        self.ActivePREs[provinceKey] = {};
    end
    self.ActivePREs[provinceKey][#self.ActivePREs[provinceKey] + 1] = activePRE;
    self.Logger:Log("PRE: "..preKey.." is active in region: "..regionKey);
    -- Create the effect bundle for the region based off of the data structure
    local customEffectBundle = cm:create_new_custom_effect_bundle(preData.PREData.EffectBundleKey);
    customEffectBundle:set_duration(preData.PREData.PREDuration + 1);
    for effectKey, effectValue in pairs(preData.PREData.EffectBundleEffects) do
        customEffectBundle:add_effect(effectKey, "region_to_province_own", effectValue);
    end
    cm:apply_custom_effect_bundle_to_region(customEffectBundle, region);
    self.Logger:Log_Finished();
end

function ERController:AddPastPRE(region, activePREData)
    local turnNumber = cm:model():turn_number();
    local regionObject = cm:get_region(activePREData.TargetRegion);
    local provinceKey = regionObject:province_name();

    if self.PastPREs[provinceKey] == nil then
        self.PastPREs[provinceKey] = {};
    end
    local pastPREsForProvince = self.PastPREs[provinceKey];
    pastPREsForProvince[#pastPREsForProvince + 1] = {
        PREKey = activePREData.PREKey,
        SpawnTurnNumber = activePREData.SpawnTurnNumber,
        PREFaction = activePREData.PREFaction,
        PRESubculture = activePREData.PRESubculture,
        TargetRegion = activePREData.TargetRegion,
        TargetFaction = regionObject:owning_faction():name(),
        CompletedTurn = turnNumber,
    };
    self:RemoveActivePREInRegion(region, activePREData);
end

function ERController:RemoveActivePREInProvince(provinceKey, activePREData)
    if self.ActivePREs[provinceKey] == nil then
        return;
    end
    for index, pre in pairs(self.ActivePREs[provinceKey]) do
        if pre.PREKey == activePREData.PREKey
        and pre.PREFaction == activePREData.PREFaction then
            self.ActivePREs[provinceKey][index] = nil;
            break;
        end
    end
end

function ERController:TrackConfederation(confedereeFactionKey)
    self.ConfederatedFactions[confedereeFactionKey] = true;
end

function ERController:TriggerCrackDownDilemma(regionKey, faction)
    self.Logger:Log("TriggerCrackDownDilemma");
    if not faction then
        faction = self.HumanFaction;
    end
    local factionKey = faction:name();
    if factionKey == self.HumanFaction:name() then
        self.Logger:Log("Triggering crackdown for human faction, selected region is: "..regionKey);
        local crackdownDilemmaKey = self:GetMilitaryCrackDownDilemmaKey();
        self.Logger:Log("Crackdown dilemma is: "..crackdownDilemmaKey);
        self.ButtonSelectedRegion = regionKey;
        local region = cm:get_region(self.ButtonSelectedRegion);
        cm:trigger_dilemma_with_targets(faction:command_queue_index(), crackdownDilemmaKey, faction:command_queue_index(), 0, 0, 0, region:cqi(), 0);
    else
        -- Create the effect bundle for the region based off of the data structure
        --[[local customEffectBundle = cm:create_new_custom_effect_bundle(preData.PREData.EffectBundleKey);
        customEffectBundle:set_duration(preData.PREData.PREDuration + 1);
        for effectKey, effectValue in pairs(preData.PREData.EffectBundleEffects) do
            customEffectBundle:add_effect(effectKey, "region_to_province_own", effectValue);
        end
        cm:apply_custom_effect_bundle_to_region(customEffectBundle, region);--]]
    end
    self.Logger:Log_Finished();
end

function ERController:GetMilitaryCrackDownDilemmaKey()
    return "wh2_main_dilemma_treasure_hunt_shrine_to_nagash";
end

function ERController:IsActiveMilitaryCrackDown(factionKey, checkIsInCooldown, provinceKey)
    local turnNumber = cm:model():turn_number();
     if self.MilitaryCrackDowns[factionKey] ~= nil then
        if provinceKey == nil then
            return true;
        end
        if checkIsInCooldown == true
        and self.MilitaryCrackDowns[factionKey].TurnStart > (turnNumber - 20) then
            if provinceKey ~= nil
            and provinceKey == self.self.MilitaryCrackDowns[factionKey].ProvinceKey then
                return true;
            end
        elseif checkIsInCooldown == false
        and self.MilitaryCrackDowns[factionKey].TurnStart > (turnNumber - 10) then
            if provinceKey == self.self.MilitaryCrackDowns[factionKey].ProvinceKey then
                return true;
            end
        end
    end
     return false;
end

function ERController:AddMilitaryCrackDown()
    self.Logger:Log("Adding crackdown for region: "..self.ButtonSelectedRegion);
    local region = cm:get_region(self.ButtonSelectedRegion);
    local faction = region:owning_faction();
    local factionKey = faction:name();
    local provinceKey = region:province_name();
    local factionInCrackDown = self.MilitaryCrackDowns[factionKey];
    local turnNumber = cm:model():turn_number();
    factionInCrackDown = {
        ProvinceKey = provinceKey,
        TurnStart = turnNumber,
    };
    self.MilitaryCrackDowns[factionKey] = factionInCrackDown;
    self.ButtonSelectedRegion = "";
end

function ERController:TriggerAgentDeployDilemma(regionKey, faction)
    self.Logger:Log("TriggerAgentDeployDilemma");
    if not faction then
        faction = self.HumanFaction;
    end
    local factionKey = faction:name();
    if factionKey == self.HumanFaction:name() then
        self.Logger:Log("Triggering agent deploy dilemma for human faction, selected region is: "..regionKey);
        local agentDeployDilemmaKey = self:GetAgentDeployDilemmaKey(regionKey);
        if agentDeployDilemmaKey ~= nil then
            self.Logger:Log("Agent deploy dilemma is: "..agentDeployDilemmaKey);
            self.ButtonSelectedRegion = regionKey;
            local region = cm:get_region(self.ButtonSelectedRegion);
            cm:trigger_dilemma_with_targets(faction:command_queue_index(), agentDeployDilemmaKey, faction:command_queue_index(), 0, 0, 0, region:cqi(), 0);
        end
    -- Give the AI an approximate effect
    else
        -- Create the effect bundle for the region based off of the data structure
        --[[local customEffectBundle = cm:create_new_custom_effect_bundle(preData.PREData.EffectBundleKey);
        customEffectBundle:set_duration(preData.PREData.PREDuration + 1);
        for effectKey, effectValue in pairs(preData.PREData.EffectBundleEffects) do
            customEffectBundle:add_effect(effectKey, "region_to_province_own", effectValue);
        end
        cm:apply_custom_effect_bundle_to_region(customEffectBundle, region);--]]
    end
    self.Logger:Log_Finished();
end

function ERController:IsAvailableAgentDeployDilemma(regionKey)
    local region = cm:get_region(regionKey);
    local faction = region:owning_faction();
    local provinceKey = region:province_name();
    local turnNumber = cm:model():turn_number();
    local presForProvince = self.ActivePREs[provinceKey];
    self.Logger:Log("Selected region is: "..regionKey);
    self.Logger:Log("Turn number is: "..turnNumber);
    if presForProvince ~= nil then
        self.Logger:Log("Found PREs in province: "..provinceKey);
        for index, activePREData in pairs(presForProvince) do
            self.Logger:Log("PRE.TargetRegion is in province: "..activePREData.TargetRegion);
            if not self.ReemergedFactions[activePREData.PREFaction] then
                self.Logger:Log("Faction has not reemerged");
            end
            if not self.ReemergedFactions[activePREData.PREFaction]
            and regionKey == activePREData.TargetRegion then
                local preResourceData = self:GetPREPoolDataResource(activePREData.PRESubculture, activePREData.PREFaction, activePREData.PREKey);
                -- Check agent deploy dilemmas
                local agentDeployDilemmas = preResourceData.AgentDeployDilemmas[faction:subculture()];
                if agentDeployDilemmas == nil then
                    agentDeployDilemmas = preResourceData.AutoDilemmas["default"];
                end
                self.Logger:Log("PRE spawn turn is: "..activePREData.SpawnTurnNumber);
                for dilemmaKey, dilemmaData in pairs(agentDeployDilemmas) do
                    self.Logger:Log("Dilemma required turns is : "..dilemmaData.NumberOfTurns);
                    if turnNumber >= dilemmaData.NumberOfTurns + activePREData.SpawnTurnNumber
                    and self.TriggeredAgentDeployDilemmas[dilemmaKey] == nil then
                        return true;
                    end
                end
            end
        end
    end
    self.Logger:Log("No available agent dilemmas");
    return false;
end

function ERController:GetAgentDeployDilemmaKey(regionKey)
    local region = cm:get_region(regionKey);
    local faction = region:owning_faction();
    local provinceKey = region:province_name();
    local turnNumber = cm:model():turn_number();
    local presForProvince = self.ActivePREs[provinceKey];
    if presForProvince ~= nil then
        self.Logger:Log("Found PRE in province: "..provinceKey);
        for index, activePREData in pairs(presForProvince) do
            if self.ReemergedFactions[activePREData.PREFaction] == nil
            and regionKey == activePREData.TargetRegion then
                local preResourceData = self:GetPREPoolDataResource(activePREData.PRESubculture, activePREData.PREFaction, activePREData.PREKey);
                -- Check agent deploy dilemmas
                local agentDeployDilemmas = preResourceData.AgentDeployDilemmas[faction:subculture()];
                if agentDeployDilemmas == nil then
                    agentDeployDilemmas = preResourceData.AutoDilemmas["default"];
                end
                self.Logger:Log("PRE spawn turn is: "..activePREData.SpawnTurnNumber);
                for dilemmaKey, dilemmaData in pairs(agentDeployDilemmas) do
                    self.Logger:Log("Dilemma required turns is : "..dilemmaData.NumberOfTurns);
                    if turnNumber >= dilemmaData.NumberOfTurns + activePREData.SpawnTurnNumber
                    and self.TriggeredAgentDeployDilemmas[dilemmaKey] == nil then
                        return dilemmaKey;
                    end
                end
            end
        end
    end
    return nil;
end

function ERController:AddAgentDeployDilemma(dilemmaKey)
    self.Logger:Log("Adding agent deploy dilemma: "..dilemmaKey);
    self.TriggeredAgentDeployDilemmas[dilemmaKey] = true;
    local region = cm:get_region(self.ButtonSelectedRegion);
    local provinceKey = region:province_name();
    local presForProvince = self.ActivePREs[provinceKey];
    if presForProvince ~= nil then
        for index, activePREData in pairs(presForProvince) do
            if region:name() == activePREData.TargetRegion then
                self.Logger:Log("Locking rebel PRE spawn for province: "..provinceKey);
                activePREData.IsRebelSpawnLocked = true;
            end
        end
    end
    self.ButtonSelectedRegion = "";
end