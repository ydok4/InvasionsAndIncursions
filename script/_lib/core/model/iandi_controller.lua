IandI_Controller = {
    HumanFaction = {},
    CampaignName = "",
    SubculturesToFactions = {},
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
end

function IandI_Controller:NewGame()
    -- Delayed Start Functionality
    self:DelayedStartSetup();
    --
    self:AreaSetup();
    -- Incursion Functionality
    --[[self:IncursionSetup();
    -- Invasion Functionality
    self:InvasionSetup();--]]
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

                local factionLeader = faction:faction_leader();
                local invasionLeader = {
                        cqi = factionLeader:cqi(),
                        forename = factionLeader:get_forename(),
                        surname = factionLeader:get_surname(),
                        subtype = factionLeader:character_subtype_key(),
                };
                if not delayedStartData.OnlyWoundFactionLeader then
                    IandI_Log("Killing all characters for faction "..forceFactionKey);
                    -- Workaround for testing
                    cm:set_character_immortality("character_cqi:"..factionLeader:cqi(), false);

                    -- Kill existing characters
                    cm:kill_all_armies_for_faction(faction);
                else
                    cm:apply_effect_bundle_to_characters_force("wh_main_increase_wound_recovery_"..delayedStartData.WoundTime, factionLeader:cqi(), delayedStartData.WoundTime, true);
                    IandI_Log("Wounding factionleader for  "..delayedStartData.WoundTime);
                    cm:kill_character(factionLeader:command_queue_index(), true, true);
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
        --local incursionTargetRegion = 
        if incursionEventData ~= nil then
            local turnNumber = Random(incursionEventData.EventData.SpawningData.StartingTurnNumbers.Maximum, incursionEventData.EventData.SpawningData.StartingTurnNumbers.Minimum);
            self:SetupEvent("Incursions", areaKey, incursionEventData, turnNumber, nil);
        end
    end
end

function IandI_Controller:GetEventForArea(areaData, type, eventKey)
    if areaData.Events[type] ~= nil then
        if eventKey == nil then 
            eventKey = GetRandomObjectKeyFromList(areaData.Events[type]);
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
    IandI_Log("Event: "..eventData.EventKey.." will start at turnNumber: "..spawnTurn);
    local index = 1;
    while(true) do
        if self.UpcomingEventsStack[index] == nil then
            break;
        elseif self.UpcomingEventsStack[index].TurnNumber > spawnTurn then
            break;
        end
        index = index + 1;
    end

    local eventSaveData = self:MapEventSaveData(type, areaKey, eventData, spawnTurn, invasionLeader);

    -- Add it into the sorted list
    table.insert(self.UpcomingEventsStack, index, eventSaveData);
end

function IandI_Controller:MapEventSaveData(type, areaKey, eventData, spawnTurn, invasionLeader)
    local spawnData = self:GetSpawnAndTargetData(eventData.EventData, eventData.EventAreaData);

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
    local imData = eventData.IMData;

    local spawnLocationData = {};
    local targetRegionData = {};
    if eventAreaData ~= nil and (imData.TargetData.TargetRegionOverride == nil or imData.TargetData.TargetRegionOverride[self.CampaignName] == nil) then
        spawnLocationData = GetRandomObjectFromList(eventAreaData.SpawnLocations);
        targetRegionData = GetRandomObjectFromList(eventAreaData.TargetRegions);
    elseif imData.TargetData.TargetRegionOverride ~= nil and imData.TargetData.TargetRegionOverride[self.CampaignName] ~= nil then
        local campaignSpecificData = imData.TargetData.TargetRegionOverride[self.CampaignName];
        spawnLocationData = GetRandomObjectFromList(campaignSpecificData.SpawnCoordinates);
        targetRegionData = GetRandomObjectFromList(campaignSpecificData.Regions);
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

function IandI_Controller:GetNextEvent()
    return self.UpcomingEventsStack[1];
end

function IandI_Controller:StartEventTypeOnTurn(turnNumber, type)
    local nextEvent = self:GetNextEvent();
    while nextEvent ~= nil and nextEvent.TurnNumber == turnNumber and nextEvent.Type == type do
        IandI_Log("Spawning "..type.." event for "..nextEvent.Type.." Key: "..nextEvent.Key);
        self:StartEvent(nextEvent);
        nextEvent = self.UpcomingEventsStack[1];
    end
end

function IandI_Controller:StartEvent(event, reinforcementData)
    IandI_Log("Attempting to start event: "..event.Key);
    if event.Type == "DelayedStart" or not self:IsActiveEventInArea(event) then
        local eventData = self:GetEventData(event.Key, event.Type);
        -- Get the faction that all armies will be spawned for
        local spawnableFaction = self:GetSpawnableFaction(event, eventData);
        IandI_Log("Invasion will spawn with faction "..spawnableFaction);
        -- This is used to offset the spawn coordinates in the case of multiple armies
        local forceIndex = 0;
        if eventData.RAMData.PrimaryForce ~= nil then
            self:CreateInvasionForce(event, eventData, eventData.RAMData.PrimaryForce, spawnableFaction, forceIndex);
            forceIndex = forceIndex + 1;
        end

        if eventData.RAMData.SecondaryForces ~= nil then
            for forceKey, forceData in pairs(eventData.RAMData.SecondaryForces) do
                self:CreateInvasionForce(event, eventData, forceData, spawnableFaction, forceIndex);
                forceIndex = forceIndex + 1;
            end
        end
        -- Remove the event from the Upcoming Event Stack
        table.remove(self.UpcomingEventsStack, 1);
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
        end
        table.remove(self.UpcomingEventsStack, 1);
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
    --IandI_Log("Generating force string");
    return self.random_army_manager:generate_force(forceKey, ramData.ArmySize - mandatoryUnitCount, false);
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
    local imData = eventData.IMData;
    local spawnCoordinates = self:GetSpawnCoordinatesForTriggeredEvent(event, eventData, forceIndex);
    -- Registers the invasion in the invasion manager
    local eventInvasion = self.invasion_manager:new_invasion(event.ForceKey, factionKey, unitList, spawnCoordinates);

    local invasionLeader = {
        forename = "",
        surname = "",
        subtype = "",
    }

    -- Assign the event general if applicable
    if ramData.IsFactionLeader == true then
        invasionLeader = event.InvasionLeader;
        IandI_Log("Forename is "..invasionLeader.forename);
        IandI_Log("Surname is "..invasionLeader.surname);
        IandI_Log("Subtype is "..invasionLeader.subtype);

        eventInvasion:create_general(true, invasionLeader.subtype, invasionLeader.forename, "", invasionLeader.surname, "");
        IandI_Log("Assigned faction leader as general");
    end

    if imData.TargetData.Type == "REGION" then
        local selectedRegion = self:GetTargetRegion(event, eventData);
        local regionOwnerName = selectedRegion:owning_faction():name();

        IandI_Log("Region owner faction name: "..regionOwnerName);
        IandI_Log("Setting invasion target. Type: "..imData.TargetData.Type.." Region: "..selectedRegion:name());
        eventInvasion:set_target(imData.TargetData.Type, selectedRegion:name(), regionOwnerName);
    end

    -- Add attrition immunity, this is to get rid of regionless attrition mainly
    eventInvasion:apply_effect("wh_main_attrition_immunity", 20);
    -- Set character to specified level
    eventInvasion:add_character_experience(ramData.XPLevel, true);
    IandI_Log("Set characters starting level to "..ramData.XPLevel);
    -- Trigger invasion
    eventInvasion:start_invasion(
        function(context)
            IandI_Log("Invasion character spawned for key: "..event.ForceKey);
            local character = context:get_general();
            if ramData.IsFactionLeader == true then
                IandI_Log("Giving character immortality");
                cm:set_character_immortality("character_cqi:"..character:cqi(), true);
            end
            -- Remove upkeep. This needs to be done here because only one bundle can be with apply_effect.
            -- This lasts for 20 turns
            cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", character:cqi(), 20, true);
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
                SetupEventCompleteListers(self, event, factionKey, eventData);
            end
            IandI_Log_Finished();
		end
    );
end

function IandI_Controller:GetSpawnCoordinatesForTriggeredEvent(event, eventData, forceIndex)
    local spawnCoordinates = self:GetSpawnLocationData(self.CampaignName, event.SpawnLocationKey);
    spawnCoordinates[1] = spawnCoordinates[1] + forceIndex;

    return spawnCoordinates;
end

function IandI_Controller:GetTargetRegion(event, eventData)
    local imData = eventData.IMData;

    if imData.TargetData.CanTargetAdjacentRegions == false then
        if imData.TargetData.TargetRegionOverride ~= nil and imData.TargetData.TargetRegionOverride[self.CampaignName] ~= nil then
            local selectedOverrideRegionKey = GetRandomObjectFromList(imData.TargetData.TargetRegionOverride[self.CampaignName].Regions);
            return cm:get_region(selectedOverrideRegionKey);
        end
        return cm:get_region(event.TargetRegionKey);
    end
    local mainRegion = cm:get_region(event.TargetRegionKey);
    IandI_Log("Main target region is: "..mainRegion:name());
    local adjacentRegions = {};
    adjacentRegions[#adjacentRegions + 1] = mainRegion;
    for i = 0, mainRegion:adjacent_region_list():num_items() - 1 do
        local adjacentRegion = mainRegion:adjacent_region_list():item_at(i);
		if adjacentRegion:is_province_capital() == false or (adjacentRegion:is_province_capital() == true and imData.CanTargetProvinceCapital == true) then
            adjacentRegions[#adjacentRegions + 1] = adjacentRegion;
            IandI_Log("Potential adjacent region target is: "..adjacentRegion:name());
		end
    end

    return GetRandomObjectFromList(adjacentRegions);
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
                    IandI_Log("Attempting to load "..event.ForceKey);
                    if self.invasion_manager:get_invasion(event.ForceKey) then
                        IandI_Log("Registering completion listener for active event: "..event.ForceKey);
                        local eventData = self:GetEventData(event.Key, event.Type);
                        SetupEventCompleteListers(self, event, event.FactionKey, eventData);
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
            if eventData.SpawningData.NumberOfTurnsBeforeOccurrence ~= nil then
                eventTimeout = Random(eventData.SpawningData.NumberOfTurnsBeforeOccurrence.Maximum, eventData.SpawningData.NumberOfTurnsBeforeOccurrence.Minimum) + 50;
            else
                eventTimeout = 50;
            end
        end
    elseif event.Type == "Incursions" then
        local areaData = self:GetAreaData(event.AreaKey);
        if areaData ~= nil then
            nextEventData = self:GetEventForArea(areaData, event.Type);
            if eventData.SpawningData.NumberOfTurnsBeforeOccurrence ~= nil then
                eventTimeout = Random(eventData.SpawningData.NumberOfTurnsBeforeOccurrence.Maximum, eventData.SpawningData.NumberOfTurnsBeforeOccurrence.Minimum) + 10;
            else
                eventTimeout = 10;
            end
        end
    elseif event.Type == "DelayedStart" then
        if eventData.SpawningData.NextEventKey ~= nil then
            nextEventData = self:GetEventData(eventData.SpawningData.NextEventKey, event.Type);
            if eventData.SpawningData.NumberOfTurnsBeforeOccurrence ~= nil then
                eventTimeout = Random(eventData.SpawningData.NumberOfTurnsBeforeOccurrence.Maximum, eventData.SpawningData.NumberOfTurnsBeforeOccurrence.Minimum);
            else
                eventTimeout = 0;
            end
        end
    end
    if nextEventData ~= nil then
        IandI_Log("Event timeout is "..eventTimeout);
        self:SetupEvent(event.Type, event.AreaKey, nextEventData, eventTimeout, nil);
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
                    IandI_Log("Attempting to load "..event.ForceKey);
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