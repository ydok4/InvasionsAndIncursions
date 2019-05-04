IandI_Controller = {
    HumanFaction = {},
    CampaignName = "",
    SubculturesToFactions = {},
    -- Character generator objects
    character_generator = {};
    -- 'Active' data
    UpcomingEventsStack = {

    },
    ActiveEventsStack = {

    },
    PreviousEventsStack = {

    },
    -- Contains references to these game objects
    random_army_manager = {

    },
    invasion_manager = {

    },
}

function IandI_Controller:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function IandI_Controller:Initialise()
    self.CampaignName = cm:get_campaign_name();
    -- We are caching these on game load so we can use it later.
    -- This list will contain ALL factions in the current campaign
    -- that aren't quest battle factions.
    self.SubculturesToFactions = {};
    local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i);
        if faction:is_quest_battle_faction() == false and faction:name() ~= self.HumanFaction:name() then
            if self.SubculturesToFactions[faction:subculture()] == nil then
                self.SubculturesToFactions[faction:subculture()] = {};
            end
            self.SubculturesToFactions[faction:subculture()][#self.SubculturesToFactions[faction:subculture()] + 1] = faction:name();
        end
    end
    self.character_generator = CharacterGenerator:new({});
end

function IandI_Controller:NewGame()
    -- Delayed Start Functionality
    self:DelayedStartSetup();
    -- Generate the first event for each area
    self:AreaSetup();
end

function IandI_Controller:DelayedStartSetup()
    IandI_Log("DelayedStartSetup");
    -- Remove all delayed start factions and transfer territory
    for delayedStartKey, delayedStartData in pairs(_G.I_I_Data.DelayedStart) do
        local imData = delayedStartData.IMData
        local forceFactionKey = imData.FactionData.FactionKey;
        local campaignTargetData = imData.TargetData.TargetRegionOverride[self.CampaignName];
        if self.HumanFaction:name() ~= forceFactionKey and campaignTargetData ~= nil then
            IandI_Log("Removing faction "..forceFactionKey);
            -- Remove faction
            local faction = cm:get_faction(forceFactionKey);
            if not faction then
                IandI_Log("Faction is not present. Might not be in this campaign");
            else
                local factionLeader = faction:faction_leader();
                local region_list = faction:region_list();
                -- Give territory to another faction
                if delayedStartData.GrantTerritoryTo ~= nil and delayedStartData.GrantTerritoryTo[self.CampaignName] ~= nil then
                    local grantTerritoryTo = delayedStartData.GrantTerritoryTo[self.CampaignName];
                    IandI_Log("Giving faction regions to "..grantTerritoryTo);
                    for i = 0, region_list:num_items() - 1 do
                        local current_region = region_list:item_at(i);
                        if grantTerritoryTo == "" then
                            cm:set_region_abandoned(current_region:name());
                        else
                            cm:transfer_region_to_faction(current_region:name(), grantTerritoryTo);
                        end
                    end
                end

                local invasionLeader = {
                        cqi = factionLeader:cqi(),
                        forename = factionLeader:get_forename(),
                        surname = factionLeader:get_surname(),
                        subtype = factionLeader:character_subtype_key(),
                };
                if delayedStartData.SpawningData.ReplacementData ~= nil then
                    IandI_Log("Replacing character for faction "..forceFactionKey);
                    local unitList = GetStringifiedUnitList(factionLeader);
                    local generatedName = self.character_generator:GetCharacterNameForSubculture(factionLeader:faction(), delayedStartData.SpawningData.ReplacementData.ReplacementSubType);
                    local regionName = "";
                    if factionLeader:region():is_null_interface() then
                        if self.CampaignName == "main_warhammer" then
                            regionName = "wh_main_athel_loren_crag_halls";
                        else -- Vortex
                            regionName = "wh2_main_albion_albion";
                        end
                    else
                        regionName = factionLeader:region():name();
                    end
                    IandI_Log("Unit list is "..unitList);
                    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
                    cm:create_force_with_general(
                        factionLeader:faction():name(),
                        unitList,
                        regionName,
                        -- X and Y coordinates are used as identifiers in the callback.
                        -- So we offset by a little bit to make it unique. This might
                        -- cause issues if the position is invalid but an offset of 1
                        -- is very small.
                        factionLeader:logical_position_x() + 1,
                        factionLeader:logical_position_y(),
                        "general",
                        delayedStartData.SpawningData.ReplacementData.ReplacementSubType,
                        generatedName.clan_name,
                        "",
                        generatedName.forename,
                        "",
                        false,
                        function(cqi)
                            IandI_Log("Created replacement");
                        end
                    );
                    if delayedStartData.SpawningData.OnlyWoundFactionLeader == true then
                        IandI_Log("Wounding character for faction "..forceFactionKey);
                        cm:force_add_trait("character_cqi:"..factionLeader:command_queue_index(),"wh_main_trait_all_increase_wound_recovery_999", true);
                        cm:kill_character(factionLeader:command_queue_index(), true, true);
                        IandI_Log("Wounded faction leader");
                    else
                        IandI_Log("Killing all characters for faction "..forceFactionKey);
                        cm:set_character_immortality("character_cqi:"..factionLeader:cqi(), false);
                        cm:kill_all_armies_for_faction(faction);
                    end
                else
                    IandI_Log("Killing all characters for faction "..forceFactionKey);
                    if not delayedStartData.SpawningData.OnlyWoundFactionLeader then
                        IandI_Log("Except faction leader");
                        cm:set_character_immortality("character_cqi:"..factionLeader:cqi(), false);
                    end
                    cm:kill_all_armies_for_faction(faction);
                end
                local turnNumber = Random(delayedStartData.SpawningData.StartingTurnNumbers.Maximum, delayedStartData.SpawningData.StartingTurnNumbers.Minimum);
                local mappedDelayedStart = {
                    EventKey =  delayedStartKey,
                    EventData =  delayedStartData,
                };
                self:SetupEvent("DelayedStart", delayedStartData.IMData.AreaOverrideKey, mappedDelayedStart, turnNumber, invasionLeader);
            end
            IandI_Log_Finished();
        end
    end
    IandI_Log("Completed delayed start");
    IandI_Log_Finished();
end

function IandI_Controller:AreaSetup()
    local campaignAreas = _G.I_I_Data.Areas[self.CampaignName];
    for areaKey, areaData in pairs(campaignAreas) do
        -- First generate any applicable invasions for the area.
        -- Any generated invasions respect any thing generated by Delayed Start
        local invasionEventData = self:GetEventForArea(areaData, "Invasions");
        if invasionEventData ~= nil then
            local turnNumber = Random(invasionEventData.EventData.SpawningData.StartingTurnNumbers.Maximum, invasionEventData.EventData.SpawningData.StartingTurnNumbers.Minimum);
            self:SetupEvent("Invasions", areaKey, invasionEventData, turnNumber, nil);
        end

        -- Then generate any incurions, respecting any rules put in place by
        -- Delayed Start events and invasion events
        local incursionEventData = self:GetEventForArea(areaData, "Incursions");
        if incursionEventData ~= nil then
            local turnNumber = Random(incursionEventData.EventData.SpawningData.StartingTurnNumbers.Maximum, incursionEventData.EventData.SpawningData.StartingTurnNumbers.Minimum);
            self:SetupEvent("Incursions", areaKey, incursionEventData, turnNumber, nil);
        end
    end
end

function IandI_Controller:GetEventForArea(areaData, type, eventKey)
    if areaData.Events[type] ~= nil then
        if eventKey == nil then
            eventKey = GetRandomItemFromWeightedList(areaData.Events[type], true);
            if eventKey == nil then
                eventKey = "default";
            end
        end
        local eventAreaData = {};
        if areaData ~= nil then
            eventAreaData = areaData.Events[type][eventKey];
        end
        local eventData = self:GetEventData(eventKey, type);
        return {
            EventKey =  eventKey,
            EventAreaData = eventAreaData,
            EventData =  eventData,
        };
    end
    return nil;
end

function IandI_Controller:SetupEvent(type, areaKey, eventData, spawnTurn, invasionLeader)
    IandI_Log("Event: "..eventData.EventKey.." will start at turnNumber: "..spawnTurn.." in area "..areaKey);
    -- Save event start data
    local spawnIndex = self:GetUpcomingEventsIndexForTurnNumber(spawnTurn);
    local eventSaveData = self:MapEventSaveData(type, areaKey, eventData, spawnTurn, invasionLeader);
    -- Add it into the sorted list
    table.insert(self.UpcomingEventsStack, spawnIndex, eventSaveData);

    -- Save Narrative incidents/dilemmas/missions
    if areaKey ~= nil then
        if eventData.EventData.NarrativeData ~= nil then
            self:AddNarrativeDataToUpcomingEvents("Incidents", eventData.EventData.NarrativeData, eventSaveData);
            self:AddNarrativeDataToUpcomingEvents("Dilemmas", eventData.EventData.NarrativeData, eventSaveData);
            self:AddNarrativeDataToUpcomingEvents("Missions", eventData.EventData.NarrativeData, eventSaveData);
        end
    end
end

function IandI_Controller:GetUpcomingEventsIndexForTurnNumber(turnNumber)
    local index = 1;
    while(true) do
        if self.UpcomingEventsStack[index] == nil then
            break;
        elseif self.UpcomingEventsStack[index].TurnNumber > turnNumber then
            break;
        end
        index = index + 1;
    end

    return index;
end

function IandI_Controller:AddNarrativeDataToUpcomingEvents(type, narrativeData, eventSaveData)
    local eventPoolData = self:GetEventData(eventSaveData.Key, eventSaveData.Type);
    if narrativeData[self.HumanFaction:name()] ~= nil and narrativeData[self.HumanFaction:name()][type] ~= nil then
        local narrativeTypeData = narrativeData[self.HumanFaction:name()][type];
        for index, data in pairs(narrativeTypeData) do
            local eventData = {
                EventKey = data.Key,
            };
            local narrativeTurn = eventSaveData.TurnNumber + (data.Delay);
            local stackIndex = self:GetUpcomingEventsIndexForTurnNumber(narrativeTurn);
            local eventSaveData = self:MapEventSaveData(type, self.HumanFaction:name(), eventData, narrativeTurn, nil);
            -- Add it into the sorted list
            table.insert(self.UpcomingEventsStack, stackIndex, eventSaveData);
        end
    elseif narrativeData[self.HumanFaction:subculture()] ~= nil and narrativeData[self.HumanFaction:subculture()][type] then
        local narrativeTypeData = narrativeData[self.HumanFaction:subculture()][type];
        for index, data in pairs(narrativeTypeData) do
            local eventData = {
                EventKey = data.Key,
            };
            local narrativeTurn = eventSaveData.TurnNumber + (data.Delay);
            local stackIndex = self:GetUpcomingEventsIndexForTurnNumber(narrativeTurn);
            local eventSaveData = self:MapEventSaveData(type, self.HumanFaction:subculture(), eventData, narrativeTurn, nil);
            -- Add it into the sorted list
            table.insert(self.UpcomingEventsStack, stackIndex, eventSaveData);
        end
    elseif narrativeData["default"] ~= nil and narrativeData["default"][type] ~= nil then
        local narrativeTypeData = narrativeData["default"][type];
        for index, data in pairs(narrativeTypeData) do
            local eventData = {
                EventKey = data.Key,
            };
            local narrativeTurn = eventSaveData.TurnNumber + (data.Delay);
            local stackIndex = self:GetUpcomingEventsIndexForTurnNumber(narrativeTurn);
            local narrativeEventSaveData = self:MapEventSaveData(type, "default", eventData, narrativeTurn, nil);
            if narrativeEventSaveData.TargetRegionKey == '' and eventPoolData.SpawningData.GiveRegions ~= nil and eventPoolData.SpawningData.GiveRegions[self.CampaignName] ~= nil then
                narrativeEventSaveData.TargetRegionKey = GetRandomObjectFromList(eventPoolData.SpawningData.GiveRegions[self.CampaignName]);
            else
                narrativeEventSaveData.TargetRegionKey = eventSaveData.TargetRegionKey;
            end
            -- Add it into the sorted list
            table.insert(self.UpcomingEventsStack, stackIndex, narrativeEventSaveData);
        end
    end
end

function IandI_Controller:MapEventSaveData(type, areaKey, eventData, spawnTurn, invasionLeader)
    local spawnData = {
        TargetRegion = "",
        SpawnCoordinates = {0,0},
    };
    if eventData.EventData ~= nil then
        spawnData = self:GetSpawnAndTargetData(eventData.EventData, eventData.EventAreaData);
    end
    local eventSaveData = {
        Key = eventData.EventKey,
        AreaKey = areaKey,
        TargetRegionKey = spawnData.TargetRegion,
        SpawnLocationKey = spawnData.SpawnCoordinates,
        Type = type,
        TurnNumber = spawnTurn,
        InvasionLeader = invasionLeader,
    }
    return eventSaveData;
end

function IandI_Controller:GetSpawnAndTargetData(eventData, eventAreaData)
    local spawnLocationData = "";
    local targetRegionData = "";

    if eventData ~= nil and eventData.IMData ~= nil then
        local imData = eventData.IMData;
        if eventAreaData ~= nil and (imData.TargetData.TargetRegionOverride == nil or imData.TargetData.TargetRegionOverride[self.CampaignName] == nil) then
            spawnLocationData = GetRandomObjectFromList(eventAreaData.SpawnLocations);
            targetRegionData = GetRandomObjectFromList(eventAreaData.TargetRegions);
        elseif imData.TargetData.TargetRegionOverride ~= nil and imData.TargetData.TargetRegionOverride[self.CampaignName] ~= nil then
            local campaignSpecificData = imData.TargetData.TargetRegionOverride[self.CampaignName];
            spawnLocationData = GetRandomObjectFromList(campaignSpecificData.SpawnCoordinates);
            if campaignSpecificData.Regions ~= nil then
                targetRegionData = GetRandomObjectFromList(campaignSpecificData.Regions);
            end
        end
    end
    return {
        SpawnCoordinates = spawnLocationData,
        TargetRegion =  targetRegionData,
    }
end
function IandI_Controller:GetAreaData(areaKey)
    return _G.I_I_Data.Areas[self.CampaignName][areaKey];
end

function IandI_Controller:GetSpawnLocationData(campaignName, key)
    if campaignName == "main_warhammer" then
        return GetRandomObjectFromList(_G.I_I_Data.SpawnLocations["ME_"..key].Coordinates);
    elseif campaignName == "wh2_main_great_vortex" then
        return GetRandomObjectFromList(_G.I_I_Data.SpawnLocations["VC_"..key].Coordinates);
    end
end

function IandI_Controller:GetEventData(eventKey, eventType)
    return _G.I_I_Data[eventType][eventKey];
end

function IandI_Controller:GetSubcultureArmyData(subCulture)
    return _G.I_I_Data.SubCultureArmyPoolData[subCulture];
end

function IandI_Controller:GetGamePeriod(turnNumber)
    if turnNumber < 60 then
        return "Early";
    elseif turnNumber < 150 then
        return "Mid";
    else
        return "Late";
    end
end

function IandI_Controller:GetNextEvent(skippedEventCount)
    return self.UpcomingEventsStack[1 + skippedEventCount];
end

function IandI_Controller:PerformEventActionsForTurnNumber(turnNumber, type)
    local skippedEventCount = 0;
    local nextEvent = self:GetNextEvent(skippedEventCount);

    while nextEvent ~= nil and nextEvent.TurnNumber <= turnNumber do
        if nextEvent.Type == type then
            if nextEvent.Type == "Incidents" then
                self:StartIncident(nextEvent);
            elseif nextEvent.Type == "Dilemmas" then
                self:StartDilemma(nextEvent);
            elseif nextEvent.Type == "Missions" then
                self:StartMission(nextEvent);
            else
                IandI_Log("Spawning "..type.." event for "..nextEvent.Type.." Key: "..nextEvent.Key);
                self:StartEvent(nextEvent);
            end
            table.remove(self.UpcomingEventsStack, skippedEventCount + 1);
        else
            skippedEventCount = skippedEventCount + 1;
        end
        nextEvent = self:GetNextEvent(skippedEventCount);
    end
end

function IandI_Controller:StartIncident(event)
    local triggerIncident = false;
    if event.AreaKey == "default" then
        IandI_Log("This is a default incident, only triggering for localised player faction");
        local mainRegion = cm:get_region(event.TargetRegionKey);
        IandI_Log("Target region is "..mainRegion:name().." owner by faction "..mainRegion:owning_faction():name());
        if mainRegion:owning_faction():name() == self.HumanFaction:name() then
            IandI_Log()
            triggerIncident = true;
        end
        for i = 0, mainRegion:adjacent_region_list():num_items() - 1 do
            local adjacentRegion = mainRegion:adjacent_region_list():item_at(i);
            IandI_Log("Adjacent region is "..adjacentRegion:name().." owner by faction "..adjacentRegion:owning_faction():name());
            if adjacentRegion:owning_faction():name() == self.HumanFaction:name() then
                triggerIncident = true;
            end
        end
    else
        triggerIncident = true;
    end
    if triggerIncident == true then
        IandI_Log("Triggering incident "..event.Key);
        local humanCQI = self.HumanFaction:command_queue_index();
        cm:trigger_incident_with_targets(humanCQI, event.Key, humanCQI, 0, 0, 0, 0, 0);
    end
end

function IandI_Controller:StartDilemma(event)
    IandI_Log("Triggering dilemma "..event.Key);
    cm:trigger_dilemma(self.HumanFaction:name(), event.Key, true);
end

function IandI_Controller:StartMission(event)
    IandI_Log("Triggering mission "..event.Key);
    cm:trigger_mission(self.HumanFaction:name(), event.Key, true);
end

function IandI_Controller:StartEvent(event, reinforcementData)
    IandI_Log("Attempting to start event: "..event.Key);
    if event.Key == "default" then
        local eventData = self:GetEventData(event.Key, event.Type);
        self:SetupNewEventForArea(event, eventData);
    elseif event.Type == "DelayedStart" or not self:IsActiveEventInArea(event) then
        local eventData = self:GetEventData(event.Key, event.Type);
        -- Get the faction that all armies will be spawned for
        local spawnableFaction = self:GetSpawnableFaction(event, eventData);
        IandI_Log("Invasion will spawn with faction "..spawnableFaction);
        -- This is used to offset the spawn coordinates in the case of multiple armies
        local forceIndex = 0;
        local targetedRegions = {};
        if eventData.RAMData.PrimaryForce ~= nil then
            if eventData.IMData.TargetData.Type == "REGION" then
                local selectedRegion = self:GetTargetRegion(event, eventData, targetedRegions);
                targetedRegions[#targetedRegions + 1] = selectedRegion;
                event.TargetRegionKey = selectedRegion:name();
            end
            self:CreateInvasionForce(event, eventData, eventData.RAMData.PrimaryForce, spawnableFaction, forceIndex);
            forceIndex = forceIndex + 1;
        end

        if eventData.RAMData.SecondaryForces ~= nil then
            for forceKey, forceData in pairs(eventData.RAMData.SecondaryForces) do
                if eventData.IMData.TargetData.Type == "REGION" then
                    local selectedRegion = self:GetTargetRegion(event, eventData, targetedRegions);
                    targetedRegions[#targetedRegions + 1] = selectedRegion;
                    event.TargetRegionKey = selectedRegion:name();
                end
                self:CreateInvasionForce(event, eventData, forceData, spawnableFaction, forceIndex);
                forceIndex = forceIndex + 1;
            end
        end

        IandI_Log("Cleared event from the UpcomingEventsStack");
    elseif reinforcementData ~= nil then
        local eventData = self:GetEventData(event.Key, event.Type);
        self:CreateInvasionForce(event, eventData, eventData.RAMData.SecondaryForces[reinforcementData.RAMKey], reinforcementData.FactionKey, reinforcementData.ForceIndex);
        -- NOTE: We don't remove from the upcoming event stack because the reinforcement was technically
        -- not in the stack. The original event trigger will remove itself.
    else
        local activeEvents = self:GetAnyActiveEventsInArea(event.AreaKey);
        local forceIndex = 0;
        local existingEventKey = nil;
        local existingEventFaction = nil;

        for eventKey, existingEvents in pairs(activeEvents) do
            IandI_Log("Event "..eventKey.." is already active in area "..event.AreaKey);
            for forceKey, existingEvent in pairs(existingEvents) do
                if existingEvent.Type == "Invasions" and event.Type == "Incursions" then
                    forceIndex = forceIndex + 1;
                    existingEventKey = existingEvent.Key;
                    existingEventFaction = existingEvent.FactionKey;
                end
            end
        end
        if forceIndex > 0 then
            IandI_Log("Triggering reinforcements");
            -- We need to map the data into the UpcomingEventsStack format
            -- without adding it to the stack
            local existingEventAreaData = self:GetAreaData(event.AreaKey);
            local eventAreaData = self:GetEventForArea(existingEventAreaData, "Invasions", existingEventKey);
            if eventAreaData ~= nil then
                local eventSaveData = self:MapEventSaveData("Invasions", event.AreaKey, eventAreaData, event.TurnNumber, nil);
                -- Then we need to determine a reinforcement to trigger from the SecondaryForces
                local existingEventData = self:GetEventData(existingEventKey, "Invasions");
                -- Add the reinforcement specific fields
                local ramKey = GetRandomObjectKeyFromList(existingEventData.RAMData.SecondaryForces);
                local mappedReinforcementData = {
                    RAMKey = ramKey,
                    FactionKey = existingEventFaction,
                    ForceIndex = forceIndex,
                };
                -- Then we can start the event by the calling the function again with the reinforcement key
                -- and the newly setup event data
                self:StartEvent(eventSaveData, mappedReinforcementData);
            else
                IandI_Log("No reinforcement event data found");
            end
        end

        IandI_Log("Cleared event from the UpcomingEventsStack");
    end
    IandI_Log_Finished();
end

function IandI_Controller:IsActiveEventInArea(event)
    if self.ActiveEventsStack[event.AreaKey] == nil then
        return false;
    end
    local foundActiveEvent = false;
    for eventKey, eventForces in pairs(self.ActiveEventsStack[event.AreaKey]) do
        foundActiveEvent = true;
        break;
    end
    return foundActiveEvent;
end

function IandI_Controller:GetAnyActiveEventsInArea(areaKey)
    return  self.ActiveEventsStack[areaKey];
end

function IandI_Controller:CreateInvasionForce(event, eventData, ramData, factionKey, forceIndex)
    IandI_Log("Generating force: "..forceIndex);
    local forceKey = "";
    if event.AreaKey ~= nil then
        forceKey = ramData.Key.."__"..event.AreaKey.."__"..event.TurnNumber.."__"..forceIndex;
    else
        forceKey = ramData.Key.."__"..event.TurnNumber.."__"..forceIndex;
    end
    IandI_Log("ForceKey: "..forceKey);
    -- Using the eventdata, generate the unit list
    local unitList = self:GenerateForceForEvent(event, eventData, ramData, forceKey);
    IandI_Log("Got unit list for invasion: "..unitList);
        -- Copy the event and Add it to the Active Event Stack for this invasion force
        local activeEventSaveData = {
            -- Existing fields
            Key = event.Key,
            Type = event.Type,
            AreaKey = event.AreaKey,
            TurnNumber = event.TurnNumber,
            TargetRegionKey = event.TargetRegionKey,
            SpawnLocationKey = event.SpawnLocationKey,
            InvasionLeader = event.InvasionLeader,
            -- New Fields
            ForceKey = forceKey,
            FactionKey = factionKey,
        };
        if self.ActiveEventsStack[activeEventSaveData.AreaKey] == nil then
            self.ActiveEventsStack[activeEventSaveData.AreaKey] = {};
        end
        if self.ActiveEventsStack[activeEventSaveData.AreaKey][activeEventSaveData.Key] == nil then
            self.ActiveEventsStack[activeEventSaveData.AreaKey][activeEventSaveData.Key] = {};
        end
        self.ActiveEventsStack[activeEventSaveData.AreaKey][activeEventSaveData.Key][activeEventSaveData.ForceKey] = activeEventSaveData;
    -- Trigger the invasion using the invasion manager. This returns the id of the faction that was spawned.
    self:StartEventThroughInvasionManager(activeEventSaveData, eventData, ramData, factionKey, unitList, forceIndex);
    IandI_Log("Started invasion "..forceKey);
    --IandI_Log("Added event to the ActiveEventsStack");
    IandI_Log_Finished();
end

function IandI_Controller:GenerateForceForEvent(event, eventData, ramData, forceKey)
    local subCultureKey = eventData.IMData.FactionData.SubcultureKey;
    --IandI_Log("GenerateForceForEvent");
    if not self.random_army_manager then
        IandI_Log("Can't find random_army_manager");
    end

    self.random_army_manager:new_force(forceKey);
    --IandI_Log("Getting mandatory units");
    local mandatoryUnits = ramData.MandatoryUnits;
    local mandatoryUnitCount = 0;
    if mandatoryUnits ~= nil then
        for unitKey, amount in pairs(mandatoryUnits) do
            mandatoryUnitCount = mandatoryUnitCount + amount;
        end
    end
    --IandI_Log("Got mandatory unit count: "..mandatoryUnitCount);

    --IandI_Log("Getting subculture units")
    local subCultureUnits = self:GetOtherUnits(event, subCultureKey, ramData);
    if subCultureUnits ~= nil then
        for unitKey, unitData in pairs(subCultureUnits) do
            self.random_army_manager:add_unit(forceKey, unitKey, unitData.Weighting);
        end
    end

    local armySize = 20 - mandatoryUnitCount;
    if ramData.ArmySize == nil then
        local turnNumber = cm:model():turn_number();
        local gamePeriod = self:GetGamePeriod(turnNumber);
        if gamePeriod == "Early" then
            armySize = Random(14, 8) - mandatoryUnitCount;
        elseif gamePeriod == "Mid" then
            armySize = Random(20, 14) - mandatoryUnitCount;
        else
            armySize = 20 - mandatoryUnitCount;
        end
    else
        armySize = ramData.ArmySize - mandatoryUnitCount;
    end
    IandI_Log("Force size is "..armySize);
    --IandI_Log("Generating force string");
    return self.random_army_manager:generate_force(forceKey, armySize, false);
end

function IandI_Controller:GetOtherUnits(event, SubcultureKey, ramData)
    local gamePeriod = self:GetGamePeriod(event.TurnNumber);

    local otherUnits = {};

    local subCultureArmyData = self:GetSubcultureArmyData(SubcultureKey);
    for index, tag in pairs(ramData.UnitTags) do
        local tagKey = "";
        -- If the stored data is a table grab a random tag from it
        if type(tag) == "table" then
            tagKey = GetRandomObjectFromList(tag);
        else
            tagKey = tag;
        end
        local tagData = subCultureArmyData[tagKey][gamePeriod];
        for unitKey, weighting in pairs(tagData) do
            otherUnits[unitKey] = {
                Weighting = weighting,
            }
        end
    end

    return otherUnits;
end

function IandI_Controller:StartEventThroughInvasionManager(event, eventData, ramData, factionKey, unitList, forceIndex)
    IandI_Log("Starting invasion for force "..event.ForceKey);
    local faction = cm:get_faction(factionKey);
    local imData = eventData.IMData;
    local spawnCoordinates = self:GetSpawnCoordinatesForTriggeredEvent(event, eventData, forceIndex);
    -- Registers the invasion in the invasion manager
    local eventInvasion = self.invasion_manager:new_invasion(event.ForceKey, factionKey, unitList, spawnCoordinates);

    -- Assign the event general if applicable
    if event.InvasionLeader ~= nil and ramData.Subtypes == nil then
        IandI_Log("RAM leader is faction leader");
        local invasionLeader = event.InvasionLeader;
        if faction:is_null_interface() then
            IandI_Log("Faction is null interface");
        end
        local factionLeader = faction:faction_leader();
        IandI_Log("Got faction leader");
        if eventData.SpawningData.ReplacementData ~= nil and eventData.SpawningData.OnlyWoundFactionLeader == true then
            IandI_Log("Killing existing faction leader");
            if factionLeader:is_null_interface() then
                IandI_Log("Faction leader is null interface");
            else
                cm:set_character_immortality("character_cqi:"..factionLeader:cqi(), false);
                IandI_Log("Removed Immortality");
                cm:kill_character(factionLeader:command_queue_index(), true, true);
                IandI_Log("Killed character");
            end
        end
        if invasionLeader ~= nil then
            IandI_Log("Forename is "..invasionLeader.forename);
            IandI_Log("Surname is "..invasionLeader.surname);
            IandI_Log("Subtype is "..invasionLeader.subtype);
            if not factionLeader:is_null_interface() and eventData.SpawningData.OnlyWoundFactionLeader == false then
                IandI_Log("Setting existing faction leadear as force general");
                eventInvasion:assign_general(factionLeader);
            else
                IandI_Log("Creating a new faction leader");
                eventInvasion:create_general(ramData.IsFactionLeader, invasionLeader.subtype, invasionLeader.forename, "", invasionLeader.surname, "");
            end
        end

        IandI_Log("Assigned faction leader as general");
    elseif ramData.Subtypes ~= nil then
        local subType = GetRandomObjectFromList(ramData.Subtypes);
        if type(subType) == "table"then
            subType = GetRandomObjectFromList(subType);
        end
        local generatedName = self.character_generator:GetCharacterNameForSubculture(faction, subType);
        eventInvasion:create_general(ramData.IsFactionLeader, subType, generatedName.clan_name, "", generatedName.forename, "");
        IandI_Log("Created general with subtype "..subType);
    else
        IandI_Log("Error missing replacement subtype or invasion leader");
        return;
    end

    local regionOwnerName;
    if imData.TargetData.Type == "REGION" then
        local selectedRegion = cm:get_region(event.TargetRegionKey);
        regionOwnerName = selectedRegion:owning_faction():name();

        IandI_Log("Region owner faction name: "..regionOwnerName);
        IandI_Log("Setting invasion target. Type: "..imData.TargetData.Type.." Region: "..selectedRegion:name());
        eventInvasion:set_target(imData.TargetData.Type, selectedRegion:name(), regionOwnerName);
    end
    -- Add attrition immunity, this is to get rid of regionless attrition mainly
    --eventInvasion:apply_effect("wh_main_attrition_immunity", 20);
    -- Set character to specified level
    local characterExperience = 0;
    if ramData.XPLevel == nil then
        local turnNumber = cm:model():turn_number();
        local gamePeriod = self:GetGamePeriod(turnNumber);
        if gamePeriod == "Early" then
            characterExperience = Random(6, 2);
        elseif gamePeriod == "Mid" then
            characterExperience = Random(12, 6);
        else
            characterExperience = Random(18, 12);
        end
    else
        characterExperience = ramData.XPLevel;
    end
    IandI_Log("Character xp level is "..characterExperience);
    eventInvasion:add_character_experience(characterExperience, true);
    IandI_Log("Set characters starting level to "..characterExperience);
    --cm:callback(function()
        -- Trigger invasion
        eventInvasion:start_invasion(
            function(context)
                IandI_Log("Invasion character spawned for key: "..event.ForceKey);
                local character = context:get_general();
                local factionName = character:faction():name();
                if ramData.IsFactionLeader == true then
                    IandI_Log("Giving character immortality");
                    cm:set_character_immortality("character_cqi:"..character:cqi(), true);
                end

                if ramData.ModelOverride ~= nil then
                    IandI_Log("Setting model override "..ramData.ModelOverride);
                    cm:add_unit_model_overrides("character_cqi:"..character:cqi(), ramData.ModelOverride);
                end

                if eventData.SpawningData.DisableDiplomacy == true then
                    -- Disable all diplomatic options
                    cm:force_diplomacy("faction:"..factionName, "all", "all", false, false, true);
                    -- Then we need to enable the war option, disable payments as well, just cause
                    cm:force_diplomacy("faction:"..factionName, "all", "war", true, true, true, true);
                end

                -- We need to stop the target faction from able to make peace because it screws with the ai
                if regionOwnerName ~= nil then
                    cm:force_diplomacy("faction:"..factionName, "faction:"..regionOwnerName, "peace", false, false, true);
                end
                -- Remove upkeep. This needs to be done here because only one bundle can be with apply_effect.
                -- This lasts for 20 turns
                cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", character:cqi(), 20, true);

                -- Assign any territory
                if eventData.SpawningData.GiveRegions ~= nil and eventData.SpawningData.GiveRegions[self.CampaignName] ~= nil then
                    IandI_Log("Giving the following regions to faction "..factionKey);
                    for index, regionKey in pairs(eventData.SpawningData.GiveRegions[self.CampaignName]) do
                        local region = cm:get_region(regionKey);
                        IandI_Log("Transferring region: "..regionKey);
                        cm:transfer_region_to_faction(regionKey, factionKey);
                        if not region:owning_faction():is_null_interface() and region:owning_faction():name() ~= factionKey then
                            IandI_Log("Declaring war with "..region:owning_faction():name());
                            cm:force_declare_war(factionKey, region:owning_faction():name(), false, false);
                        end
                    end
                end

                -- Grant the new force any mandatory units
                if ramData.MandatoryUnits ~= nil then
                    for unitKey, amount in pairs(ramData.MandatoryUnits) do
                        for i = 1, amount do
                            IandI_Log("Granting mandatory unit to invasion: "..unitKey);
                            cm:grant_unit_to_character("character_cqi:"..character:cqi(), unitKey);
                        end
                    end
                else
                    IandI_Log("No mandatory units to add");
                end

                -- This is to fix cases where LLs spawn with agents and they end up inside them, so they manually need to move.
                -- The chosen spawn coordinates should enough room to accommodate moving them by - 1 X coodinate.
                cm:teleport_to("character_cqi:"..character:cqi(), character:logical_position_x() - 1, character:logical_position_y(), true);
                if imData.TargetData.Type == "RELEASE" then
                    local eventInvasion = self.invasion_manager:get_invasion(event.ForceKey);
                    local general = eventInvasion:get_general();
                    IandI_Log("Invasion subtype is "..general:character_subtype_key());
                    eventInvasion:release();
                    IandI_Log("Released character from invasion manager");
                else
                    SetupEventCompleteListeners(self, event, factionKey, eventData);
                end
                IandI_Log_Finished();
            end
        );
    --end,
    --0);
end

function IandI_Controller:GetSpawnCoordinatesForTriggeredEvent(event, eventData, forceIndex)
    local spawnCoordinates = self:GetSpawnLocationData(self.CampaignName, event.SpawnLocationKey);
    spawnCoordinates[1] = spawnCoordinates[1] + forceIndex;
    IandI_Log("Spawn coordinates are X: "..spawnCoordinates[1].." Y: "..spawnCoordinates[2]);
    return spawnCoordinates;
end

function IandI_Controller:GetTargetRegion(event, eventData, targetedRegions)
    local imData = eventData.IMData;
    local areaData = self:GetAreaData(event.AreaKey);
    local areaEventData = nil;
    if areaData ~= nil then
        areaEventData = areaData.Events[event.Type][event.Key];
    end
    if imData.TargetData.CanTargetAdjacentRegions == false then
        if imData.TargetData.TargetRegionOverride ~= nil and imData.TargetData.TargetRegionOverride[self.CampaignName] ~= nil then
            local targetRegionKeys = imData.TargetData.TargetRegionOverride[self.CampaignName].Regions;
            if areaEventData ~= nil and areaEventData.SubcultureTargets ~= nil then
                local validRegions = nil;
                for index, regionKey in pairs(targetRegionKeys) do
                    local region = cm:get_region(regionKey);
                    if not region:is_null_interface() then
                        for index, cultureKey in pairs(areaEventData.SubcultureTargets) do
                            if not region:owning_faction():is_null_interface() and region:owning_faction():subculture() == cultureKey and targetedRegions[regionKey] == nil then
                                if validRegions == nil then
                                    validRegions = {};
                                end
                                validRegions[regionKey] = regionKey;
                            end
                        end
                    end
                end
                if validRegions ~= nil then
                    targetRegionKeys = validRegions;
                end
            end
            local selectedOverrideRegionKey = GetRandomObjectFromList(targetRegionKeys);
            return cm:get_region(selectedOverrideRegionKey);
        end
        return cm:get_region(event.TargetRegionKey);
    end
    local mainRegion = cm:get_region(event.TargetRegionKey);
    IandI_Log("Main target region is: "..mainRegion:name());
    local validAdjacentRegions = {};
    if mainRegion:is_province_capital() == false or (mainRegion:is_province_capital() == true and imData.CanTargetProvinceCapital == true) and targetedRegions[mainRegion:name()] == nil then
        validAdjacentRegions[#validAdjacentRegions + 1] = mainRegion;
    end
    for i = 0, mainRegion:adjacent_region_list():num_items() - 1 do
        local adjacentRegion = mainRegion:adjacent_region_list():item_at(i);
        if adjacentRegion:is_province_capital() == false or (adjacentRegion:is_province_capital() == true and imData.CanTargetProvinceCapital == true) and targetedRegions[adjacentRegion:name()] == nil then
            if areaEventData ~= nil and areaEventData.SubcultureTargets ~= nil then
                if not adjacentRegion:is_null_interface() then
                    for index, cultureKey in pairs(areaEventData.SubcultureTargets) do
                        if not adjacentRegion:owning_faction():is_null_interface() and adjacentRegion:owning_faction():subculture() == cultureKey then
                            validAdjacentRegions[#validAdjacentRegions + 1] = adjacentRegion;
                        end
                    end
                end
            else
                validAdjacentRegions[#validAdjacentRegions + 1] = adjacentRegion;
            end
            IandI_Log("Potential adjacent region target is: "..adjacentRegion:name());
		end
    end

    return GetRandomObjectFromList(validAdjacentRegions);
end

function IandI_Controller:GetSpawnableFaction(event, eventData)
    local imData = eventData.IMData;
    if imData.FactionData.FactionKey ~= nil then
        return imData.FactionData.FactionKey;
    end

    return GetRandomObjectFromList(self.SubculturesToFactions[imData.FactionData.SubcultureKey]);
end

function IandI_Controller:RegisterActiveEventListeners()
    IandI_Log("RegisterActiveEventListeners START");
    if self.invasion_manager == nil then
        IandI_Log("Invasion manager is nil");
        return;
    end
    if self.ActiveEventsStack ~= nil then
        for areaKey, eventsInArea in pairs(self.ActiveEventsStack) do
            IandI_Log("Checking area "..areaKey);
            for eventKey, events in pairs(eventsInArea) do
                for forceKey, event in pairs(events) do
                    if self.invasion_manager:get_invasion(event.ForceKey) then
                        IandI_Log("Registering completion listener for active event: "..event.ForceKey);
                        local eventData = self:GetEventData(event.Key, event.Type);
                        SetupEventCompleteListeners(self, event, event.FactionKey, eventData);
                    else
                        IandI_Log("Invasion missing from manager. Not loading listener. It is probably destroyed.");
                        self:CleanUpActiveForce(event);
                    end
                end
            end
        end
        IandI_Log("Finished loading active events");
    else
        IandI_Log("No active events to load");
    end
end

function IandI_Controller:RemoveEventFromActiveEventsStack(event)
    if self.ActiveEventsStack[event.AreaKey] ~= nil then
        IandI_Log("Removing force from stack with key "..event.ForceKey);
        self.ActiveEventsStack[event.AreaKey][event.Key][event.ForceKey] = nil;
    end
    IandI_Log("Successfully removed event from Active events stack");
end

function IandI_Controller:AddEventToPreviousEventsStack(event, eventData)
    if self.PreviousEventsStack[event.AreaKey] == nil then
        self.PreviousEventsStack[event.AreaKey] = {};
    end
    IandI_Log("Adding event "..event.Key.." to the previous events stack");
    if self.PreviousEventsStack[event.AreaKey][event.Key] == nil then
        self.PreviousEventsStack[event.AreaKey][event.Key] = {};
    end
    local previousEvents = self.PreviousEventsStack[event.AreaKey][event.Key];
    table.insert(previousEvents, 1, cm:model():turn_number());
end

function IandI_Controller:CleanUpActiveForce(event)
    IandI_Log("Cleaning up active force "..event.ForceKey);
    self:RemoveEventFromActiveEventsStack(event);
    if self:AreAllForcesInactive(event) then
        local eventData = self:GetEventData(event.Key, event.Type);
        self:CompleteEvent(event, eventData);
    end
end

function IandI_Controller:CompleteEvent(event, eventData)
    IandI_Log("Event "..event.Key.." is completed");
    self:AddEventToPreviousEventsStack(event, eventData);
    self:SetupNewEventForArea(event, eventData);
end

function IandI_Controller:SetupNewEventForArea(event, eventData)
    IandI_Log("Getting next event");
    local nextEventData = nil;
    local eventTimeout = 0;
    if event.Type == "Invasions" then
        local areaData = self:GetAreaData(event.AreaKey);
        if areaData ~= nil then
            nextEventData = self:GetEventForArea(areaData, event.Type);
            if eventData.SpawningData.NumberOfTurnsBeforeReoccurrence ~= nil then
                eventTimeout = Random(eventData.SpawningData.NumberOfTurnsBeforeReoccurrence.Maximum, eventData.SpawningData.NumberOfTurnsBeforeReoccurrence.Minimum) + 50;
            else
                eventTimeout = 50;
            end
        end
    elseif event.Type == "Incursions" then
        local areaData = self:GetAreaData(event.AreaKey);
        if areaData ~= nil then
            nextEventData = self:GetEventForArea(areaData, event.Type);
            if eventData.SpawningData.NumberOfTurnsBeforeReoccurrence ~= nil then
                eventTimeout = Random(eventData.SpawningData.NumberOfTurnsBeforeReoccurrence.Maximum, eventData.SpawningData.NumberOfTurnsBeforeReoccurrence.Minimum) + 10;
            else
                eventTimeout = 10;
            end
        end
    elseif event.Type == "DelayedStart" then
        if eventData.SpawningData.NextEventKey ~= nil then
            nextEventData = self:GetEventData(eventData.SpawningData.NextEventKey, event.Type);
            if eventData.SpawningData.NumberOfTurnsBeforeReoccurrence ~= nil then
                eventTimeout = Random(eventData.SpawningData.NumberOfTurnsBeforeReoccurrence.Maximum, eventData.SpawningData.NumberOfTurnsBeforeReoccurrence.Minimum);
            else
                eventTimeout = 0;
            end
        end
    end
    if nextEventData ~= nil then
        IandI_Log("Event timeout is "..eventTimeout);
        self:SetupEvent(event.Type, event.AreaKey, nextEventData, cm:model():turn_number() + eventTimeout, nil);
    else
        IandI_Log("There is no next event after event "..event.ForceKey);
    end
end

function IandI_Controller:AreAllForcesInactive(event)
    if self.ActiveEventsStack[event.AreaKey] then
        if self.ActiveEventsStack[event.AreaKey][event.Key] == nil then
            return true;
        end
        local numberOfActiveForces = 0;
        for forceKey, forceData in pairs(self.ActiveEventsStack[event.AreaKey][event.Key]) do
            numberOfActiveForces = numberOfActiveForces + 1;
        end

        if numberOfActiveForces > 0 then
            IandI_Log("There are still "..numberOfActiveForces.." forces active for event "..event.Key.." in area "..event.AreaKey);
            return false;
        end
    end
    IandI_Log("There are no more forces active for event "..event.Key.." in area "..event.AreaKey);
    self.ActiveEventsStack[event.AreaKey][event.Key] = nil;
    return true;
end

function IandI_Controller:CleanUpActiveEventForces()
    IandI_Log("Cleaning up active event forces.");
    if self.invasion_manager == nil then
        IandI_Log("Invasion manager is nil");
        return;
    end
    if self.ActiveEventsStack ~= nil then
        for areaKey, eventsInArea in pairs(self.ActiveEventsStack) do
            IandI_Log("Checking area "..areaKey);
            for eventKey, events in pairs(eventsInArea) do
                for forceKey, event in pairs(events) do
                    if not self.invasion_manager:get_invasion(event.ForceKey) then
                        IandI_Log("Invasion "..event.ForceKey.." missing from invasion manager. Removing from active events stack.");
                        self:CleanUpActiveForce(event);
                    else
                        IandI_Log("Found "..event.ForceKey.." in invasion manager");
                    end
                end
            end
        end
        IandI_Log("Finished checking active events");
    else
        IandI_Log("No active events to check");
    end
end