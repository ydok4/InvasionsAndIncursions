-- Mock Data
testCharacter = {
    cqi = function() return 123 end,
    get_forename = function() return "Direfan"; end,
    get_surname = function() return "Cylostra"; end,
    character_subtype_key = function() return "wh2_dlc11_cst_cylostra"; end,
    command_queue_index = function() end,
    has_military_force = function() return false end,
    faction = function() return humanFaction; end,
    region = function() return get_cm():get_region(); end,
    logical_position_x = function() return 100; end,
    logical_position_y = function() return 110; end,
    command_queue_index = function() return 10; end,
    is_null_interface = function() return false; end,
}

humanFaction = {
    name = function()
        return "wh2_main_def_naggarond";
    end,
    subculture = function()
        return "wh2_main_sc_def_dark_elves";
    end,
    character_list = function()
        return {
            num_items = function()
                return 0;
            end
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 0;
            end
        };
    end,
    home_region = function ()
        return {
            name = function()
                return "";
            end,
            is_null_interface = function()
                return false;
            end,
        }
    end,
    faction_leader = function() return testCharacter; end,
    is_quest_battle_faction = function() return false; end,
    is_null_interface = function() return false; end,
    command_queue_index = function() return 0; end,
}

testFaction = {
    name = function()
        return "wh2_dlc11_cst_noctilus";
    end,
    subculture = function()
        return "wh2_dlc11_sc_cst_vampire_coast";
    end,
    character_list = function()
        return {
            num_items = function()
                return 0;
            end
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 0;
            end
        };
    end,
    home_region = function ()
        return {
            name = function()
                return "";
            end,
            is_null_interface = function()
                return false;
            end,
        }
    end,
    faction_leader = function() return testCharacter; end,
    is_quest_battle_faction = function() return false; end,
    is_null_interface = function() return false; end,
}

testFaction2 = {
    name = function()
        return "wh2_dlc11_cst_rogue_grey_point_scuttlers";
    end,
    subculture = function()
        return "wh_main_sc_nor_norsca";
    end,
    character_list = function()
        return {
            num_items = function()
                return 0;
            end
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 0;
            end
        };
    end,
    home_region = function ()
        return {
            name = function()
                return "";
            end,
            is_null_interface = function()
                return false;
            end,
        }
    end,
    faction_leader = function() return testCharacter; end,
    is_quest_battle_faction = function() return false; end,
    is_null_interface = function() return false; end,
}

effect = {
    get_localised_string = function()
        return "[test]";
    end,
}

-- This can be modified in the testing driver
-- so we can simulate turns changing easily
local turn_number = 1;
-- Mock functions
function get_cm()
    return   {
        is_new_game = function() return true; end,
        create_agent = function()
            return;
        end,
        get_human_factions = function()
            return {humanFaction};
        end,
        disable_event_feed_events = function() end,
        model = function ()
            return {
                turn_number = function() return turn_number; end,
                world = function()
                    return {
                        faction_by_key = function ()
                            return humanFaction;
                        end,
                        faction_list = function ()
                            return {
                                item_at = function(self, i)
                                    if i == 0 then
                                        return testFaction;
                                    elseif i == 1 then
                                        return humanFaction;
                                    elseif i == 2 then
                                        return testFaction2;
                                    elseif i == 3 then
                                        return testFaction2
                                    else
                                        return nil;
                                    end
                                end,
                                num_items = function()
                                    return 3;
                                end,
                            }
                        end
                    }
                end
            }
        end,
        first_tick_callbacks = {},
        add_listener = function () end,
        add_saving_game_callback = function() end,
        add_loading_game_callback = function() end,
        spawn_character_to_pool = function() end,
        callback = function() end,
        transfer_region_to_faction = function() end,
        get_faction = function() return testFaction2; end,
        lift_all_shroud = function() end,
        kill_all_armies_for_faction = function() end,
        get_region = function()
            return {
                owning_faction = function() return testFaction; end,
                name = function() return "region_name"; end,
                is_province_capital = function() return false; end,
                adjacent_region_list = function()
                    return {
                        item_at = function(self, i)
                            if i == 0 then
                                return get_cm():get_region();
                            elseif i == 1 then
                                return get_cm():get_region();
                            elseif i == 2 then
                                return get_cm():get_region();
                            elseif i == 3 then
                                return get_cm():get_region();
                            else
                                return nil;
                            end
                        end,
                        num_items = function()
                            return 3;
                        end,
                    }
                end,
                is_null_interface = function() return false; end,
            }
        end,
        set_character_immortality = function() end,
        get_campaign_name = function() return "main_warhammer"; end,
        apply_effect_bundle_to_characters_force = function() end,
        kill_character = function() end,
        trigger_incident = function() end,
        trigger_dilemma = function() end,
        trigger_mission = function() end,
        create_force_with_general = function() end,
        force_add_trait = function() end,
        force_remove_trait = function() end,
        get_character_by_cqi = function() end,
        char_is_mobile_general_with_army = function() return false; end,
        force_declare_war = function() end,
        trigger_incident_with_targets = function() end,
    };
end

cm = get_cm();

core = {
    add_listener = function() end,
}

random_army_manager = {
    new_force = function() end,
    add_mandatory_unit = function() end,
    add_unit = function() end,
    generate_force = function() return ""; end,
}

invasion_manager = {
    new_invasion = function()
        return {
            set_target = function() end,
            apply_effect = function() end,
            add_character_experience = function() end,
            start_invasion = function() end,
            assign_general = function() end,
            create_general = function() end,
        }
    end,
    get_invasion = function() return {
        release = function() return end,
    }; end,
}
out = function(text)
  print(text)
end

require 'script/campaign/mod/incursions_and_invasions'
require 'script/campaign/mod/z_iandi_crynsos_patch'
require 'script/campaign/mod/z_iandi_mixu_patch'





math.randomseed(os.time())

-- This is used in game by Warhammer but we have it hear so it won't throw errors when running
-- in ZeroBrane IDE


incursions_and_invasions();
IandI:RegisterActiveEventListeners();
IandI = _G.IandI;
turn_number = 1;
StartEventsForTurn(IandI);
turn_number = 2;
StartEventsForTurn(IandI);

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
IandI.UpcomingEventsStack = {};

out("I&I: Loading upcoming events");
local upcomingEvents = serialisedUpcomingEvents;
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
IandI.ActiveEventsStack = {};

local activeEvents = serialisedActiveEvents;
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

local previousSavedEvents = serialisedPreviousEvents;
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

IandI:RegisterActiveEventListeners();

if IandI.ActiveEventsStack ~= nil then
    for areaKey, eventsInArea in pairs(IandI.ActiveEventsStack) do
        IandI_Log("Checking area "..areaKey);
        for eventKey, events in pairs(eventsInArea) do
            for forceKey, event in pairs(events) do
                local otherEventForces = IandI.ActiveEventsStack[event.AreaKey][event.Key];
                for eventKey, forceEvent in pairs(otherEventForces) do
                    IandI_Log("Getting invasion by forceKey: "..forceEvent.ForceKey);
                    local eventInvasion = IandI.invasion_manager:get_invasion(event.ForceKey);
                    if not eventInvasion then
                        IandI_Log("Missing event invasion, not releasing AI because it can't be found");
                        IandI:CleanUpActiveForce(forceEvent);
                    end
                    if event.TargetRegionKey == forceEvent.TargetRegionKey then
                        IandI_Log("Releasing invasion for force "..forceEvent.ForceKey);
                        eventInvasion:release();
                        IandI_Log("Released faction");
                        IandI:CleanUpActiveForce(forceEvent);
                    end
                end
            end
        end
    end
else
    IandI_Log("No active events to load");
end

turn_number = 3;
StartEventsForTurn(IandI);

