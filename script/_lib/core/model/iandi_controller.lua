IandI_Controller = {
    DelayedStart = {

    },
    Incursions = {

    },
    Invasions = {

    },
    UpcomingEventsStack = {

    },
    ActiveEventsStack = {

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

function IandI_Controller:NewGame()
    -- Delayed Start Functionality
    self:DelayedStartSetup();
    -- Incursion Functionality

    -- Invasion Functionality
    self:InvasionSetup();
end

function IandI_Controller:DelayedStartSetup()
    IandI_Log("DelayedStartSetup");
    local campaignName = cm:get_campaign_name();
    -- Remove all delayed start factions and transfer territory
    for delayedStartKey, delayedStartData in pairs(_G.I_I_Data.DelayedStart) do
        local targetData = delayedStartData.EmergeData.IMData.Target["default"];
        local forceFactionKey = targetData.FactionKey;
        local campaignTargetData = targetData.TargetData;
        if self.HumanFaction:name() ~= forceFactionKey and campaignTargetData[campaignName] ~= nil then
            IandI_Log("Removing faction "..forceFactionKey);
            -- Remove faction
            local faction = cm:get_faction(forceFactionKey);
            if not faction then
                IandI_Log("Faction is not present. Might not be in this campaign");
            else
                local region_list = faction:region_list();
                -- Give territory to another faction
                if delayedStartData.GrantTerritoryTo ~= nil and delayedStartData.GrantTerritoryTo[campaignName] ~= nil then
                    local grantTerritoryTo = delayedStartData.GrantTerritoryTo[campaignName];
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

                IandI_Log("Killing all characters for faction "..forceFactionKey);
                -- Workaround for testing
                local factionLeader = faction:faction_leader();
                local invasionLeader = {
                    cqi = factionLeader:cqi(),
                    forename = factionLeader:get_forename(),
                    surname = factionLeader:get_surname(),
                    subtype = factionLeader:character_subtype_key(),
                };
                cm:set_character_immortality("character_cqi:"..factionLeader:cqi(), false);

                -- Kill existing characters
                cm:kill_all_armies_for_faction(faction);

                -- Some factions only Re-emerge as a part of incursions and invasions
                -- They should still give up any territory (if applicable) and be removed
                if delayedStartData.EmergeData ~= nil then
                    self:SetupEvent("DelayedStart", delayedStartKey, delayedStartData, "default", invasionLeader);
                end
            end
            IandI_Log_Finished();
        end
    end
    IandI_Log("Completed delayed start");
    IandI_Log_Finished();
end

function IandI_Controller:InvasionSetup()
    IandI_Log("InvasionStartSetup");
    local campaignName = cm:get_campaign_name();
    for invasionKey, invasionData in pairs(_G.I_I_Data.Invasion) do
        for subcultureTargetKey, targetData in pairs(invasionData.EmergeData.IMData.Target) do
            local forceFactionKey = targetData.FactionKey;
            local campaignTargetData = targetData.TargetData;
            if self.HumanFaction:name() ~= forceFactionKey and campaignTargetData[campaignName] ~= nil then
                IandI_Log("Targeting subculture: "..subcultureTargetKey);
                self:SetupEvent("Invasion", invasionKey, invasionData, subcultureTargetKey, nil);
                IandI_Log_Finished();
            end
        end
    end
end

function IandI_Controller:SetupEvent(type, eventKey, eventData, subcultureTargetKey, invasionLeader)
    IandI_Log("Setting up: "..eventKey);
    local campaignName = cm:get_campaign_name();
    -- Randomly generate re-emerge turn number
    local turnNumber = Random(eventData.EmergeData.TurnNumbers.Maximum, eventData.EmergeData.TurnNumbers.Minimum);
    IandI_Log("Event: "..eventKey.." will start at turnNumber: "..turnNumber);
    local index = 1;
    while(true) do
        if self.UpcomingEventsStack[index] == nil then
            break;
        elseif self.UpcomingEventsStack[index].TurnNumber > turnNumber then
            break;
        end
        index = index + 1;
    end

    local validSubculturesForCampaign = {};
    for subcultureKey, subcultureTarget in pairs(eventData.EmergeData.IMData.Target) do
        if subcultureTarget.TargetData[campaignName] ~= nil then
            validSubculturesForCampaign[#validSubculturesForCampaign + 1] = subcultureKey;
        end
    end

    local eventSaveData = {
        Key = eventKey,
        Type = type,
        SubcultureTarget = subcultureTargetKey,
        TurnNumber = turnNumber,
        InvasionLeader = invasionLeader,
    }
    -- Add it into the sorted list
    table.insert(self.UpcomingEventsStack, index, eventSaveData);
end

function IandI_Controller:GetEventData(event)
    return _G.I_I_Data[event.Type][event.Key];
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

function IandI_Controller:StartEvent(event)
    IandI_Log("Starting event "..event.Key);
    local eventData = self:GetEventData(event);
    IandI_Log("Got event data");
    -- This is used to offset the spawn coordinates in the case of multiple armies
    local forceIndex = 0;
    for ramKey, ramData in pairs(eventData.EmergeData.RAMData) do
        IandI_Log("Generting force: "..ramKey);
        local forceKey = ramData.Key.."__"..event.SubcultureTarget;
        IandI_Log("ForceKey: "..forceKey);
        -- Using the eventdata, generate the unit list
        local unitList = self:GenerateForceForEvent(event, eventData.SubcultureKey, ramData, forceKey);
        IandI_Log("Got unit list for invasion: "..unitList);
        -- Trigger the invasion using the invasion manager
        self:StartEventThroughInvasionManager(event, eventData, ramData, forceKey, unitList, forceIndex);
        IandI_Log("Started invasion");
        forceIndex = forceIndex + 1;
        -- Add it to the Active Event Stack
        local forceSaveData = event;
        forceSaveData.Key = forceKey;
        self.ActiveEventsStack[forceKey] = forceSaveData;
        IandI_Log_Finished();
    end

    IandI_Log("Added event to the ActiveEventsStack");
    -- Remove the event from the Upcoming Event Stack
    table.remove(self.UpcomingEventsStack, 1);
    IandI_Log("Cleared event from the UpcomingEventsStack");
    IandI_Log_Finished();
end

function IandI_Controller:GenerateForceForEvent(event, SubcultureKey, ramData, forceKey)
    IandI_Log("GenerateForceForEvent");
    if not self.random_army_manager then
        IandI_Log("Can't find random_army_manager");
    end

    self.random_army_manager:new_force(forceKey);
    IandI_Log("Getting mandatory units");
    local mandatoryUnits = ramData.MandatoryUnits;
    local mandatoryUnitCount = 0;
    if mandatoryUnits ~= nil then
        for unitKey, amount in pairs(mandatoryUnits) do
            mandatoryUnitCount = mandatoryUnitCount + amount;
        end
    end
    IandI_Log("Got mandatory unit count: "..mandatoryUnitCount);

    IandI_Log("Getting subculture units")
    local subCultureUnits = self:GetOtherUnits(event, SubcultureKey, ramData);
    if subCultureUnits ~= nil then
        for unitKey, unitData in pairs(subCultureUnits) do
            self.random_army_manager:add_unit(forceKey, unitKey, unitData.Weighting);
        end
    end
    IandI_Log("Generating force string");
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

function IandI_Controller:StartEventThroughInvasionManager(event, eventData, ramData, forceKey, unitList, forceIndex)
    IandI_Log("Starting invasion");
    local campaignName = cm:get_campaign_name();
    local subcultureTargetData = eventData.EmergeData.IMData.Target[event.SubcultureTarget];
    local campaignIMData = subcultureTargetData.TargetData[campaignName];

    local spawnCoordinates = GetRandomObjectFromList(campaignIMData.SpawnCoordinates);
    -- Offset the X coordinates by the forceindex so armies don't spawn inside each other
    spawnCoordinates[1] = spawnCoordinates[1] + forceIndex;
    IandI_Log("Spawn location X: "..spawnCoordinates[1].." Spawn location y: "..spawnCoordinates[2]);

    -- Registers the invasion in the invasion manager
    local eventInvasion = self.invasion_manager:new_invasion(forceKey, subcultureTargetData.FactionKey, unitList, spawnCoordinates);

    local invasionLeader = {
        forename = "",
        surname = "",
        subtype = "",
    }

    -- Assign the event general if applicable
    if ramData.FactionLeaderIsForceCommander == true then
        invasionLeader = event.InvasionLeader;
        IandI_Log("Forename is "..invasionLeader.forename);
        IandI_Log("Surname is "..invasionLeader.surname);
        IandI_Log("Subtype is "..invasionLeader.subtype);

        eventInvasion:create_general(true, invasionLeader.subtype, invasionLeader.forename, "", invasionLeader.surname, "");
        IandI_Log("Assigned faction leader as general");
    end

    local selectedRegion = GetRandomObjectFromList(campaignIMData.Regions);
    local targetRegion = cm:get_region(selectedRegion);
    if not targetRegion then
        IandI_Log("Missing region data");
    end

    local regionOwnerName = targetRegion:owning_faction():name();
    IandI_Log("Region owner faction name: "..regionOwnerName);
    IandI_Log("Setting invasion target. Type: "..subcultureTargetData.Type.." Region: "..selectedRegion);
    eventInvasion:set_target(subcultureTargetData.Type, selectedRegion, regionOwnerName);

    -- Add attrition immunity, this is to get rid of regionless attrition mainly
    eventInvasion:apply_effect("wh_main_attrition_immunity", 20);
    -- Set character to specified level
    eventInvasion:add_character_experience(ramData.XPLevel, true);
    IandI_Log("Set characters starting level to "..ramData.XPLevel);

    -- Trigger invasion
    eventInvasion:start_invasion(
        function(context)
            IandI_Log("Invasion character spawned for key: "..forceKey);
            local character = context:get_general();
            if ramData.FactionLeaderIsForceCommander == true then
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
            SetupEventCompleteListers(self, forceKey, event, eventData);
            IandI_Log_Finished();
		end
    );

    IandI_Log("Finished starting invasion");
end

function IandI_Controller:RegisterActiveEventListeners()
    IandI_Log("RegisterActiveEventListeners START");
    if self.ActiveEventsStack ~= nil then
        for index, event in pairs(self.ActiveEventsStack) do
            IandI_Log("Checking index "..index);
            local forceKey = event.Key.."_"..event.SubcultureTarget;
            IandI_Log("Attempting to load "..forceKey);
            if self.invasion_manager == nil then
                IandI_Log("Invasion manager is nil");
            end
            if self.invasion_manager:get_invasion(forceKey) then
                IandI_Log("Registering completion listener for active event: "..forceKey);
                local eventData = self:GetEventData(event);
                SetupEventCompleteListers(self, forceKey, event, eventData);
            else
                IandI_Log("Invasion missing from manager. Not loading listener. It is probably destroyed.");
                self.ActiveEventsStack[index] = nil;
            end
        end
        IandI_Log("Finished loading active events");
    else
        IandI_Log("No active events to load");
    end
end