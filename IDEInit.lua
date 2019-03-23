-- Mock Data
testCharacter = {
    cqi = function() return 123 end,
    get_forename = function() return "Direfan"; end,
    get_surname = function() return "Cylostra"; end,
    character_subtype_key = function() return "wh2_dlc11_cst_cylostra"; end,
}

testFaction = {
    name = function()
        return "wh2_dlc11_cst_the_drowned";
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
}

testFaction2 = {
    name = function()
        return "wh2_dlc11_cst_rogue_grey_point_scuttlers";
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
}

effect = {
    get_localised_string = function()
        return "[test]";
    end,
}

-- Mock functions
function get_cm()
    return   {
        is_new_game = function() return true; end,
        create_agent = function()
            return;
        end,
        get_human_factions = function()
            return {testFaction2};
        end,
        disable_event_feed_events = function() end,
        model = function ()
            return {
                world = function()
                    return {
                        faction_by_key = function ()
                            return testFaction2;
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
            }
        end,
        set_character_immortality = function() end,
        get_campaign_name = function() return "main_warhammer"; end,
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
}
out = function(text)
  print(text)
end

require 'script/campaign/mod/incursions_and_invasions'
require "script/campaign/mod/z_iandi_crynsos_patch"





math.randomseed(os.time())

-- This is used in game by Warhammer but we have it hear so it won't throw errors when running
-- in ZeroBrane IDE


incursions_and_invasions();
IandI:RegisterActiveEventListeners();
IandI = _G.IandI;
IandI:StartEvent(IandI.UpcomingEventsStack[1]);
if not IandI.UpcomingEventsStack[1] then
    IandI_Log("There is no upcoming event");
else
    local nextEvent = IandI.UpcomingEventsStack[1];
    if nextEvent ~= nil and nextEvent.TurnNumber ~= 1 then
        IandI_Log("There is no event for this turn. Next event is: "..nextEvent.TurnNumber);
    end
    while nextEvent ~= nil and nextEvent.TurnNumber == 1 do
        IandI_Log("Spawning event for "..nextEvent.Type.." Key: "..nextEvent.Key);
        IandI:StartEvent(nextEvent);
        nextEvent = IandI.UpcomingEventsStack[1];
    end
end