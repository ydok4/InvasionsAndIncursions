ERController = {
    CampaignName = "",
    HumanFaction = {},
    ArmyGenerator = {},
    CharacterGenerator = {},
    Logger = {},
    ActiveRebellions = {},
    RebelForces = {},
    PastRebellions = {},
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
    and ownerFaction == self.HumanFaction:name()
    and ownerFaction ~= "wh2_main_brt_knights_of_origo"
    and ownerFaction ~= "wh2_main_brt_knights_of_the_flame"
    and ownerFaction ~= "wh2_main_brt_thegans_crusaders"
    then
        local provinceKey = region:province_name();
        local provinceResources = self:GetProvinceRebellionResources(provinceKey);
        local rebellionProvinceData = {
            SubcultureKey = "wh_main_sc_grn_greenskins",
            IsAdjacentToSea = provinceResources.IsAdjacentToSea,
        };
        return rebellionProvinceData;
    end
    -- First subculture we add is out current subculture with some exceptions.
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

    -- Finally consider rebels added by corruption.
    -- This could be Vampire Counts/Vampire Coast, Chaos/Beastmen or Skaven
    local chaosCorruption = region:religion_proportion("wh_main_religion_chaos");
    local chaosCorruptionWeighting = self:GetCorruptionWeighting(chaosCorruption);
    if chaosCorruptionWeighting > 0 then
        -- Chaos corruption is split between beastmen and chaos warriors
        local chaosWarriorsCorruptionWeighting = math.ceil(0.25 * chaosCorruptionWeighting);
        validSubculturesForRegion["wh_main_sc_chs_chaos_corruption"] = {
            Weighting = chaosWarriorsCorruptionWeighting,
        };
        local beastmenCorruptionWeighting = math.ceil(0.75 * chaosCorruptionWeighting);
        validSubculturesForRegion["wh_dlc03_sc_bst_beastmen_corruption"] = {
            Weighting = beastmenCorruptionWeighting,
        };
        self.Logger:Log("Chaos corruption for "..regionKey.." is: "..chaosCorruption);
    end

    local vampireCorruption = region:religion_proportion("wh_main_religion_undeath");
    local vampireCorruptionWeighting = self:GetCorruptionWeighting(vampireCorruption);
    if vampireCorruptionWeighting > 0 then
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
        self.Logger:Log("Vampire corruption for "..regionKey.." is: "..vampireCorruption);
    end

    local skavenCorruption = region:religion_proportion("wh2_main_religion_skaven");
    local skavenCorruptionWeighting = self:GetCorruptionWeighting(skavenCorruption);
    if skavenCorruptionWeighting > 0 then
        validSubculturesForRegion["wh2_main_sc_skv_skaven_corruption"] = {
            Weighting = skavenCorruptionWeighting,
        };
        self.Logger:Log("Skaven corruption for "..regionKey.." is: "..skavenCorruption);
    end
    local rebellionProvinceData = {
        SubcultureKey = GetRandomItemFromWeightedList(validSubculturesForRegion, true),
        IsAdjacentToSea = provinceResources.IsAdjacentToSea,
    };
    return rebellionProvinceData;
end

function ERController:GetCorruptionWeighting(corruptionValue)
    local corruptionWeighting = math.floor(corruptionValue / 10);
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
    return _G.ERResources.RebelArmyArchetypesPoolData[subcultureKey][subcultureKey][archetypeKey];
end

function ERController:GetForceDataForRegionAndSubculture(region, rebellionProvinceData)
    -- First we figure out what archetype we should use for this region and subculture
    local archetypeData = self:GetArmyArchetypeForRegionProvinceAndSubculture(region, rebellionProvinceData.SubcultureKey);
    local willSpawnOnSea = rebellionProvinceData.IsAdjacentToSea == true and archetypeData.CanSpawnOnSea == true and region:settlement():is_port() == true;
    -- Next we generate a name and art set for them
    -- NOTE: Art set isn't required but I can potentially use for other things
    local rebellionFaction = self:GetRebellionFactionForSubculture(rebellionProvinceData.SubcultureKey, willSpawnOnSea);
    local rebelFaction = cm:get_faction(rebellionFaction);
    local generatedName = self.CharacterGenerator:GetCharacterNameForSubculture(rebelFaction, archetypeData.AgentSubTypeKey);
    local artSetId = self.CharacterGenerator:GetArtSetForSubType(archetypeData.AgentSubTypeKey);
    local agentSubTypeData = {
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
    };
    -- Get rebel army
    local turnNumber = cm:model():turn_number();
    local regionKey = region:name();
    local ramData = {
        ForceKey = regionKey..turnNumber..rebellionData.FactionKey,
        ArmySize = archetypeData.ArmySize,
        ForceData = rebellionData,
    };
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

function ERController:GetArmyArchetypeForRegionProvinceAndSubculture(region, rebellionSubculture)
    local armyArchetypeData = {};
    if string.match(rebellionSubculture, "corruption") then
        armyArchetypeData = self:GetCorruptionArmyArchetype(region, rebellionSubculture);
    else
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

function ERController:SpawnArmy(rebellionData, region, owningFaction)
    local factionKey = owningFaction:name();
    local spawnX, spawnY = -1, -1;
    if rebellionData.SpawnOnSea == true then
        self.Logger:Log("Attempting to spawn army on sea...");
        local spawnDistance = 10;
        repeat
            spawnX, spawnY = cm:find_valid_spawn_location_for_character_from_settlement(
                factionKey,
                region:name(),
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
            region:name(),
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
    local regionKey = region:name();
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
            local militaryForce = character:military_force();
            local militaryForceCqi = militaryForce:command_queue_index();
            self.Logger:Log("Rebellion spawned. Military force cqi is: "..militaryForceCqi);
            local characterLookupString = "character_cqi:"..cqi;
            -- Perform diplomacy and other setup commands
            -- Force war without peace with targeted faction
            cm:force_diplomacy("faction:" .. factionKey, "faction:" .. rebellionData.FactionKey, "peace", false, false, true);
            cm:force_declare_war(rebellionData.FactionKey, factionKey, false, false);
            -- Then do the same for the player
            cm:force_diplomacy("faction:" .. self.HumanFaction:name(), "faction:" .. rebellionData.FactionKey, "peace", false, false, true);
            cm:force_declare_war(rebellionData.FactionKey, self.HumanFaction:name(), false, false);
            -- We gave the army free upkeep so it won't take attrition
            cm:apply_effect_bundle_to_force("wh_main_bundle_military_upkeep_free_force", militaryForceCqi, -1);
            -- Disable movement so they won't run away but only for non-sea spawns
            if rebellionData.SpawnOnSea == false then
                cm:cai_disable_movement_for_character(characterLookupString);
            end
            -- Force them into raiding stance so they take some money from the faction but only on land
            if rebellionData.SpawnOnSea == false then
                cm:force_character_force_into_stance(characterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
            end
            -- Apply the specified art set id
            cm:add_unit_model_overrides(cm:char_lookup_str(cqi), rebellionData.AgentSubTypeData.AgentArtSetId);
            -- Store relevant data for later
            local turnNumber = cm:model():turn_number();
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
                self.RebelForces[tostring(militaryForceCqi)] = {
                    Target = regionKey,
                    SpawnTurn = turnNumber,
                    SubcultureKey = rebellionData.SubcultureKey,
                    AgentSubTypeKey = rebellionData.AgentSubTypeData.AgentSubTypeKey,
                    ArmyArchetypeKey = rebellionData.ArmyArchetypeKey,
                    SpawnedOnSea = rebellionData.SpawnOnSea,
                    SpawnCoordinates = spawnX.."/"..spawnY,
                };
            else
                self.Logger:Log("ERROR: Military force cqi already exists");
            end
            -- Add mandatory units
            -- Grant the new force any mandatory units
            if rebellionData.MandatoryUnits ~= nil then
                for unitKey, amount in pairs(rebellionData.MandatoryUnits) do
                    for i = 1, amount do
                        self.Logger:Log("Granting mandatory unit to invasion: "..unitKey);
                        cm:grant_unit_to_character(characterLookupString, unitKey);
                    end
                end
            else
                self.Logger:Log("No mandatory units to add");
            end
            local showMessage = (factionKey == self.HumanFaction:name());
            if showMessage == true then
                local factionCqi = self.HumanFaction:command_queue_index();
                cm:trigger_incident_with_targets(factionCqi, "er_generic_incursion", factionCqi, 0, 0, 0, region:cqi(), 0);
            end
            -- Apply an effect bundle which gives a minor public order boost, reduces income and movement for a few turns
            cm:apply_effect_bundle_to_region("er_effect_bundle_generic_incursion_region", regionKey, 5);
            local bonusXpLevels = 0;
            local armyArchetypeData = self:GetArmyArchetypeData(rebellionData.SubcultureKey, rebellionData.ArmyArchetypeKey)
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
            cm:callback(function() core:trigger_event("ER_ScriptedEventEnableDiplomacy"); end, 0);
            self.Logger:Log_Finished();
        end
    );
end

function ERController:GrantUnitsForForce(rebelForceData, militaryForce)
    if militaryForce:unit_list():num_items() == 19 then
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
            UnitTags = armyArchetypeResources.UnitTags,
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
    local pastRebellionsForRegion = self.PastRebellions[provinceKey];
    pastRebellionsForRegion[#pastRebellionsForRegion + 1] = {
        SpawnTurn = rebelForce.SpawnTurn,
        SubcultureKey = rebelForce.SubcultureKey,
        AgentSubTypeKey = rebelForce.AgentSubTypeKey,
        Target = rebelForce.Target,
        DestroyedTurn = turnNumber,
    };
end

function ERController:IsProvinceInTimeout(provinceKey)
    local rebellionsForProvinces = self.PastRebellions[provinceKey];
    if rebellionsForProvinces == nil then
        return false;
    end
    local turnNumber = cm:model():turn_number();
    local lastRebellionTurn = 0;
    for index, pastProvinceRebellions in pairs(rebellionsForProvinces) do
        if pastProvinceRebellions.DestroyedTurn > lastRebellionTurn then
            lastRebellionTurn = pastProvinceRebellions.DestroyedTurn;
        end
    end
    -- We have a timeout of 3 turns since the last rebellion was destroyed.
    if turnNumber > lastRebellionTurn + 3 then
        return false;
    end
    return true;
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
        if pastProvinceRebellion.DestroyedTurn + 15 < turnNumber
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