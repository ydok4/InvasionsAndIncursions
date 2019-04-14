IandI = {};
_G.IandI = IandI;

require 'script/_lib/core/helpers/iandi_datahelpers';
require 'script/_lib/core/listeners/iandi_listeners';
require 'script/_lib/core/model/iandi_controller';

require 'script/_lib/core/loaders/iandi_core_resource_loader';

IandI_Log_Start();

InitialiseIandIListenerData(core, find_uicomponent, UIComponent);

function incursions_and_invasions()
    out("I&I: Main mod function");
    IandI_Log("Main mod function");

    IandI = IandI_Controller:new({
        HumanFaction = GetHumanFaction();
        random_army_manager = random_army_manager,
        invasion_manager = invasion_manager,
        ActiveEventsStack = IandI.ActiveEventsStack,
        UpcomingEventsStack = IandI.UpcomingEventsStack,
        PreviousEventsStack = IandI.PreviousEventsStack,
    });
    IandI:Initialise();
    IandI_Log("Got human faction "..IandI.HumanFaction:name());
    if cm:is_new_game() then
        IandI_Log("New game");
        IandI_Log_Finished();
        IandI:NewGame();
    else
        IandI:RegisterActiveEventListeners();
    end

    IandI_Log("Initialising listeners");
    SetupIandIPostUIListeners(IandI);

    IandI_Log_Finished();
    out("I&I: Finished setup");
end

-- Saving/Loading Callbacks
-- These need to be outside of the Constructor function
-- because that is called by the game too late
cm:add_saving_game_callback(
    function(context)
        IandI_Log_Finished();
        IandI_Log("Saving callback");
        out("I&I: Saving callback");

        -- Save the upcoming events in the game save
        out("I&I: Saving upcoming events");
        local serialisedUpcomingEvents = {};
        for index, data in pairs(IandI.UpcomingEventsStack) do
            out("I&I: Saving upcoming event "..data.Key);
            local serialisedEvent = {};
            if data.InvasionLeader ~= nil then
                serialisedEvent = { data.Key, data.Type, data.AreaKey, data.TurnNumber, data.TargetRegionKey, data.SpawnLocationKey, data.InvasionLeader.cqi, data.InvasionLeader.surname, data.InvasionLeader.forename, data.InvasionLeader.subtype };
            else
                serialisedEvent = { data.Key, data.Type, data.AreaKey, data.TurnNumber, data.TargetRegionKey, data.SpawnLocationKey, };
            end
            serialisedUpcomingEvents[#serialisedUpcomingEvents + 1] = serialisedEvent;
        end
        cm:save_named_value("iandi_upcomingevents", serialisedUpcomingEvents, context);

        -- Save the active events into the game save
        out("I&I: Saving active events");
        local serialisedActiveEvents = {};
        for areaKey, areaEvents in pairs(IandI.ActiveEventsStack) do
            for eventKey, events in pairs(areaEvents) do
                for index, data in pairs(events) do
                    out("I&I: Saving active event "..data.ForceKey);
                    local serialisedEvent = {};
                    if data.InvasionLeader ~= nil then
                        out("I&I: Force key is "..data.ForceKey);
                        serialisedEvent = { data.Key, data.Type, data.AreaKey, data.TurnNumber, data.TargetRegionKey, data.SpawnLocationKey, data.FactionKey, data.ForceKey, data.InvasionLeader.cqi, data.InvasionLeader.surname, data.InvasionLeader.forename, data.InvasionLeader.subtype };
                    else
                        serialisedEvent = { data.Key, data.Type, data.AreaKey, data.TurnNumber, data.TargetRegionKey, data.SpawnLocationKey, data.FactionKey, data.ForceKey,};
                    end
                    serialisedActiveEvents[data.AreaKey..data.ForceKey] = serialisedEvent;
                end
            end
        end
        cm:save_named_value("iandi_activeevents", serialisedActiveEvents, context);

        -- Save the previous events to the game save
        out("I&I: Saving previous events");
        local serialisedPreviousEvents = {};
        for areaKey, eventsInArea in pairs(IandI.PreviousEventsStack) do
            for eventKey, turnsCompleted in pairs(eventsInArea) do
                for index, turnCompleted in pairs(turnsCompleted) do
                    out("I&I: Saving previous event "..eventKey.." in turn "..turnCompleted);
                    local serialisedEvent = { eventKey, turnCompleted, areaKey, };
                    serialisedPreviousEvents[eventKey..areaKey..turnCompleted] = serialisedEvent;
                end
            end
        end
        cm:save_named_value("iandi_previousevents", serialisedPreviousEvents, context);

        -- Add model to save
        IandI_Log_Finished();
        out("I&I: Finished saving events");
    end
);

cm:add_loading_game_callback(
    function(context)
        out("I&I: Loading callback");
        -- load model data from save
        -- Loading the Upcoming Events
        IandI.UpcomingEventsStack = {};
        out("I&I: Loading upcoming events");
        local upcomingEvents = cm:load_named_value("iandi_upcomingevents", {}, context);
        for index, data in pairs(upcomingEvents) do
            out("I&I: Loading upcoming event "..data[2]);
            local eventData = {
                Key = data[1],
                Type = data[2],
                AreaKey = data[3],
                TurnNumber = data[4],
                TargetRegionKey = data[5],
                SpawnLocationKey = data[6],
            }
            if data[7] ~= nil then
                eventData.InvasionLeader = {
                    cqi = data[7],
                    surname = data[8],
                    forename = data[9],
                    subtype = data[10],
                }
            end
            IandI.UpcomingEventsStack[index] = eventData;
        end

        -- Loading the Active Events
        IandI.ActiveEventsStack = {};
        out("I&I: Loading active events");
        local activeEvents = cm:load_named_value("iandi_activeevents", {}, context);
        for index, data in pairs(activeEvents) do
            out("I&I: Loading active event "..data[1]);
            local eventData = {
                Key = data[1],
                Type = data[2],
                AreaKey = data[3],
                TurnNumber = data[4],
                TargetRegionKey = data[5],
                SpawnLocationKey = data[6],
                FactionKey = data[7],
                ForceKey = data[8],
            };
            if data[9] ~= nil then
                eventData.InvasionLeader = {
                    cqi = data[9],
                    surname = data[10],
                    forename = data[11],
                    subtype = data[12],
                };
            end
            if IandI.ActiveEventsStack[eventData.AreaKey] == nil then
                IandI.ActiveEventsStack[eventData.AreaKey] = {};
            end
            if IandI.ActiveEventsStack[eventData.AreaKey][eventData.Key] == nil then
                IandI.ActiveEventsStack[eventData.AreaKey][eventData.Key] = {};
            end
            IandI.ActiveEventsStack[eventData.AreaKey][eventData.Key][eventData.ForceKey] = eventData;
        end

        -- Loading the Previous Events
        out("I&I: Loading previous events");
        IandI.PreviousEventsStack = {};
        local previousSavedEvents = cm:load_named_value("iandi_previousevents", {}, context);
        for index, data in pairs(previousSavedEvents) do
            out("I&I: Loading previous event "..data[1].." for area "..data[3]);
            local eventData = {
                EventKey = data[1],
                TurnCompleted = data[2],
                AreaKey = data[3],
            };

            if IandI.PreviousEventsStack[eventData.AreaKey] == nil then
                IandI.PreviousEventsStack[eventData.AreaKey] = {};
            end
            if IandI.PreviousEventsStack[eventData.AreaKey][eventData.EventKey] == nil then
                IandI.PreviousEventsStack[eventData.AreaKey][eventData.EventKey] = {};
            end
            local previousEvents = IandI.PreviousEventsStack[eventData.AreaKey][eventData.EventKey];
            previousEvents[#previousEvents + 1] = eventData.TurnCompleted;
        end
        out("I&I: Finished loading");
	end
);

function GetHumanFaction()
    local allHumanFactions = cm:get_human_factions();
    if allHumanFactions == nil then
        return allHumanFactions;
    end
    for key, humanFaction in pairs(allHumanFactions) do
        return cm:model():world():faction_by_key(humanFaction);
    end
end

function GetFactionCapitalRegionKey(faction)
    local fac_capital = faction:home_region();
    IandI_Log("Got home region "..fac_capital:name());
    return fac_capital:name();
end

function GetGarrisonCommanderStringForFaction(faction)
    local fac_capital = faction:home_region();
    IandI_Log("Got home region "..fac_capital:name());
    local garrison = fac_capital:garrison_residence();
    IandI_Log("Got home region garrison");
    local garrison_army = cm:get_armed_citizenry_from_garrison(garrison);
    IandI_Log("Got garrison army");
    local unit_list = garrison_army:unit_list();
    for j = 0, unit_list:num_items() - 1 do
        local unit = unit_list:item_at(j);
        local key = unit:unit_key();
        IandI_Log("Garrison has unit "..key);
    end
    local char_str = cm:char_lookup_str(garrison_army:general_character():cqi());
    IandI_Log("Got garrison general "..char_str);
    return char_str;
end