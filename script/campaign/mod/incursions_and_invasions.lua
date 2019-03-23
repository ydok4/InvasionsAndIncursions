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
    });

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

        out("I&I: Saving upcoming events");
        -- Save the upcoming events in the game save
        local serialisedUpcomingEvents = {};
        for index, data in pairs(IandI.UpcomingEventsStack) do
            out("I&I: Saving upcoming event "..data.Key);
            local serialisedEvent = {};
            if data.InvasionLeader ~= nil then
                serialisedEvent = { data.Key, data.Type, data.SubcultureTarget, data.TurnNumber, data.InvasionLeader.cqi, data.InvasionLeader.surname, data.InvasionLeader.forename, data.InvasionLeader.subtype };
            else
                serialisedEvent = { data.Key, data.Type, data.SubcultureTarget, data.TurnNumber, };
            end
            serialisedUpcomingEvents[#serialisedUpcomingEvents + 1] = serialisedEvent;
        end
        cm:save_named_value("iandi_upcomingevents", serialisedUpcomingEvents, context);
        out("I&I: Saving active events");
        -- Save the active events into the game save
        local serialisedActiveEvents = {};
        for index, data in pairs(IandI.ActiveEventsStack) do
            out("I&I: Saving active event "..data.Key);
            local serialisedEvent = {}
            if data.InvasionLeader ~= nil then
                serialisedEvent = { data.Key, data.Type, data.SubcultureTarget, data.TurnNumber, data.InvasionLeader.cqi, data.InvasionLeader.surname, data.InvasionLeader.forename, data.InvasionLeader.subtype };
            else
                serialisedEvent = { data.Key, data.Type, data.SubcultureTarget, data.TurnNumber, };
            end
            serialisedActiveEvents[data.Key] = serialisedEvent;
        end
        cm:save_named_value("iandi_activeevents", serialisedActiveEvents, context);
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
            out("I&I: Loading upcoming event "..data[1]);
            local eventData = {
                Key = data[1],
                Type = data[2],
                SubcultureTarget = data[3],
                TurnNumber = data[4],
            }
            if data[5] ~= nil then
                eventData.InvasionLeader = {
                    cqi = data[5],
                    surname = data[6],
                    forename = data[7],
                    subtype = data[8],
                }
            end
            IandI.UpcomingEventsStack[index] = eventData;
        end

        -- Loading the Active Events
        IandI.ActiveEventsStack = {};
        out("I&I: Loading active events");
        local upcomingEvents = cm:load_named_value("iandi_activeevents", {}, context);
        for index, data in pairs(upcomingEvents) do
            out("I&I: Loading active event "..data[1]);
            local eventData = {
                Key = data[1],
                Type = data[2],
                SubcultureTarget = data[3],
                TurnNumber = data[4],
            }
            if data[5] ~= nil then
                eventData.InvasionLeader = {
                    cqi = data[5],
                    surname = data[6],
                    forename = data[7],
                    subtype = data[8],
                }
            end
            IandI.ActiveEventsStack[eventData.Key] = eventData;
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