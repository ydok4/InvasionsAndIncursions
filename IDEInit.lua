-- Mock Data
testCharacter = {
    cqi = function() return 123 end,
    get_forename = function() return "Direfan"; end,
    get_surname = function() return "Cylostra"; end,
    character_subtype_key = function() return "brt_louen_leoncouer"; end,
    has_military_force = function() return true end,
    military_force = function() return testMilitaryForce; end,
    faction = function() return testFaction; end,
    region = function() return get_cm():get_region(); end,
    logical_position_x = function() return 100; end,
    logical_position_y = function() return 110; end,
    command_queue_index = function() return 10; end,
    character_type = function() return false; end,
    is_null_interface = function() return false; end,
    is_wounded = function() return false; end,
}

testMilitaryForce = {
    is_null_interface = function() return false; end,
    command_queue_index = function() return 10; end,
    is_armed_citizenry = function () return false; end,
    general_character = function() return testCharacter; end,
    faction = function() return testFaction; end,
    unit_list = function() return {
        num_items = function() return 2; end,
        item_at = function(self, index)
            return test_unit;
        end,
    }
    end,
}

humanFaction = {
    command_queue_index = function() return 10; end,
    name = function()
        return "wh2_dlc11_def_the_blessed_dread";
    end,
    culture = function()
        return "wh2_main_def_dark_elves";
    end,
    subculture = function()
        return "wh2_main_sc_def_dark_elves";
    end,
    is_dead = function() return true; end,
    character_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function(self, index)
                return testCharacter;
            end,
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function(self, index)
                return cm:get_region(index);
            end,
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
    is_human = function() return true; end,
    has_effect_bundle = function() return true; end,
    is_horde = function() return false; end,
    can_be_horde = function() return false; end,
}

testFaction = {
    command_queue_index = function() return 10; end,
    name = function()
        return "wh2_main_wef_bowmen_of_oreon";
    end,
    culture = function()
        return "wh_main_grn_greenskins";
    end,
    subculture = function()
        return "wh_main_sc_chs_chaos";
    end,
    is_dead = function() return true; end,
    character_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testCharacter;
            end
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function(self, index)
                return cm:get_region(index);
            end,
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
    is_human = function() return false; end,
    has_effect_bundle = function() return true; end,
    command_queue_index = function() return 10; end,
    at_war_with = function() return true; end,
}

testFaction2 = {
    name = function()
        return "wh2_dlc11_cst_rogue_grey_point_scuttlers";
    end,
    subculture = function()
        return "wh_main_sc_nor_norsca";
    end,
    is_dead = function() return true; end,
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
    is_human = function() return false; end,
    has_effect_bundle = function() return true; end,
    command_queue_index = function() return 10; end,
    at_war_with = function() return true; end,
}

test_unit = {
    unit_key = function() return "wh2_main_hef_inf_archers_1"; end,
    force_commander = function() return testCharacter; end,
    faction = function() return testFaction; end,
    percentage_proportion_of_full_strength = function() return 80; end,
}

effect = {
    get_localised_string = function()
        return "Murdredesa";
    end,
}

-- This can be modified in the testing driver
-- so we can simulate turns changing easily
local turn_number = 1;

-- Mock functions
mock_listeners = {
    listeners = {},
    trigger_listener = function(self, mockListenerObject)
        local listener = self.listeners[mockListenerObject.Key];
        if listener and listener.Condition(mockListenerObject.Context) then
            listener.Callback(mockListenerObject.Context);
        end
    end,
}

-- Mock save structures
mockSaveData = {

}

-- slot (building) data
slot_1 = {
    has_building = function() return true; end,
    building = function() return {
        name = function() return "wh_msl_barracks_1"; end,
    }
    end,
}

slot_2 = {
    has_building = function() return true; end,
    building = function() return {
        name = function() return "wh_main_vmp_cemetary_2"; end,
    }
    end,
}

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
        turn_number = function() return turn_number; end,
        model = function ()
            return {
                military_force_for_command_queue_index = function() return testMilitaryForce; end,
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
        add_saving_game_callback = function() end,
        add_loading_game_callback = function() end,
        spawn_character_to_pool = function() end,
        callback = function(self, callbackFunction, delay) callbackFunction() end,
        transfer_region_to_faction = function() end,
        get_faction = function() return testFaction; end,
        lift_all_shroud = function() end,
        kill_all_armies_for_faction = function() end,
        get_region = function()
            return {
                cqi = function() return 123; end,
                province_name = function() return "wh_main_reikland"; end,
                faction_province_growth = function() return 3; end,
                religion_proportion = function() return 0; end,
                public_order = function() return 99; end,
                owning_faction = function() return testFaction; end,
                name = function() return "wh_main_couronne_et_languille_couronne"; end,
                is_province_capital = function() return true; end,
                is_abandoned = function() return false; end,
                command_queue_index = function() return 10; end,
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
                garrison_residence = function() return {
                    army = function() return {
                        strength = function() return 50; end,
                    } end ,
                } end,
                settlement = function() return {
                    is_port = function()
                        return true;
                    end,
                    slot_list = function() return {
                        num_items = function () return 2; end,
                        item_at = function(index)
                            if index == 1 then
                                return slot_1;
                            else
                                return slot_2;
                            end
                        end
                    }
                    end,
                }
                end
            }
        end,
        set_character_immortality = function() end,
        get_campaign_name = function() return "main_warhammer"; end,
        apply_effect_bundle_to_characters_force = function() end,
        kill_character = function() end,
        trigger_incident = function() end,
        trigger_dilemma = function() end,
        trigger_mission = function() end,
        create_force_with_general = function(self, factionKey, forceString, regionKey, spawnX, spawnY, generalType, agentSubTypeKey, clanNameKey, dummyName1, foreNameKey, dummyName2, umm, callbackFunction)
            callbackFunction(123);
        end,
        create_force_with_existing_general = function(self, cqi, factionKey, forceString, regionKey, spawnX, spawnY, callbackFunction)
            callbackFunction(123);
        end,
        force_add_trait = function() end,
        force_remove_trait = function() end,
        get_character_by_cqi = function() return testCharacter; end,
        char_is_mobile_general_with_army = function() return true; end,
        restrict_units_for_faction = function() end,
        save_named_value = function(self, saveKey, data, context)
            mockSaveData[saveKey] = data;
        end,
        load_named_value = function(self, saveKey, datastructure, context)
            if mockSaveData[saveKey] == nil then
                return nil;
            end
            return mockSaveData[saveKey];
        end,
        remove_effect_bundle = function() end,
        apply_effect_bundle = function() end,
        char_is_agent = function() return false end,
        steal_user_input = function() end,
        disable_rebellions_worldwide = function() end,
        find_valid_spawn_location_for_character_from_settlement = function() return 1, 1; end,
        force_diplomacy = function() end,
        apply_effect_bundle_to_force = function() end,
        force_declare_war = function() end,
        enable_movement_for_character = function() end,
        disable_movement_for_character = function() end,
        cai_enable_movement_for_character = function() end,
        cai_disable_movement_for_character = function() end,
        add_unit_model_overrides = function() end,
        force_character_force_into_stance = function() end,
        attack_region = function() end,
        char_lookup_str = function() end,
        suppress_all_event_feed_messages = function() end,
        grant_unit_to_character = function() end,
        show_message_event = function() end,
        show_message_event_located = function() end,
        trigger_incident_with_targets = function() end,
        force_add_and_equip_ancillary = function() end,
        force_add_ancillary = function() end,
        add_agent_experience = function() end,
        apply_effect_bundle_to_region = function() end,
        remove_effect_bundle_from_region = function() end,
        get_saved_value = function() return nil; end,
        create_new_custom_effect_bundle = function()
            return {
                set_duration = function() end,
                add_effect = function() end,
            };
        end,
        apply_custom_effect_bundle_to_region = function() end,
        get_difficulty = function() return "hard"; end,
        add_first_tick_callback = function() end,
        appoint_character_to_most_expensive_force = function() end,
        change_localised_faction_name = function() end,
        random_number = function(self, limit, start)
            return math.random(start, limit);
        end,
        get_military_force_by_cqi = function()
            return nil;
        end,
    };
end

cm = get_cm();
mock_max_unit_ui_component = {
    Id = function() return "wh2_dlc10_hef_inf_shadow_walkers_0_recruitable" end,
    ChildCount = function() return 1; end,
    Find = function() return mock_unit_ui_component; end,
    SetVisible = function() end,
    MoveTo = function() end,
    SetStateText = function() end,
    SetInteractive = function() end,
    Visible = function() return true; end,
    Position = function() return 0, 1 end,
    Bounds = function() return 0, 1 end,
    Width = function() return 1; end,
    Resize = function() return; end,
    SetCanResizeWidth = function() return; end,
    SimulateMouseOn = function() return; end,
    GetStateText = function() return "/unit/wh_main_vmp_inf_zombie]]"; end,
    --GetStateText = function() return "Unlocks recruitment of:"; end,
    SetCanResizeHeight = function() end;
    SetCanResizeWidth = function() end;
}

mock_unit_ui_component = {
    Id = function() return "wh_main_vmp_inf_zombie_mercenary" end,
    --Id = function() return "building_info_recruitment_effects" end,
    ChildCount = function() return 1; end,
    Find = function() return mock_max_unit_ui_component; end,
    SetVisible = function() end,
    MoveTo = function() end,
    SetStateText = function() end,
    SetInteractive = function() end,
    Visible = function() return true; end,
    Position = function() return 0, 1 end,
    Bounds = function() return 0, 1 end,
    Width = function() return 1; end,
    Resize = function() return; end,
    SetCanResizeWidth = function() return; end,
    SimulateMouseOn = function() return; end,
    GetStateText = function() return "/unit/wh_main_vmp_inf_zombie]]"; end,
    SetCanResizeHeight = function() end;
    SetCanResizeWidth = function() end;
}

mock_unit_ui_list_component = {
    Id = function() return "mock_list" end,
    ChildCount = function() return 1; end,
    Find = function() return mock_unit_ui_component; end,
    SetVisible = function() end,
    MoveTo = function() end,
    SetStateText = function() end,
    SetInteractive = function() end,
    Visible = function() return true; end,
    Position = function() return 0, 1 end,
    Bounds = function() return 0, 1 end,
    Width = function() return 1; end,
    Resize = function() return; end,
    SetCanResizeWidth = function() return; end,
    SimulateMouseOn = function() return; end,
    GetStateText = function() return "/unit/wh_main_vmp_inf_zombie]]"; end,
    --GetStateText = function() return "Unlocks recruitment of:"; end,
    SetCanResizeHeight = function() end;
    SetCanResizeWidth = function() end;
}

find_uicomponent = function()
    return mock_unit_ui_list_component;
end

UIComponent = function(mock_ui_find) return mock_ui_find; end

core = {
    trigger_event = function() end,
    remove_listener = function() end,
    add_listener = function (self, key, eventKey, condition, callback)
        mock_listeners.listeners[key] = {
            Condition = condition,
            Callback = callback,
        }
    end,
    get_ui_root = function() end,
    get_screen_resolution = function() return 0, 1 end;
    is_mod_loaded = function(self, string)
        if string == "mct_campaign_init" then
            return false;
        end
        return true;
    end,
}

random_army_manager = {
    new_force = function() end,
    remove_force = function() end,
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
        create_general = function() end,
    };
    end,
}
out = function(text)
  print(text);
end

require 'script/campaign/mod/a_er_core_resource_loader'
require 'script/campaign/mod/a_er_aov_patch'
require 'script/campaign/mod/a_er_cr_patch'
require 'script/campaign/mod/a_er_deco_patch'
require 'script/campaign/mod/a_subculture_army_resource_loader'
require 'script/campaign/mod/z_er_cataph_patch'
require 'script/campaign/mod/z_er_mixu_patch'
require 'script/campaign/mod/zz_enhanced_rebellions'

math.randomseed(os.time())

-- This is used in game by Warhammer but we have it hear so it won't throw errors when running
a_er_aov_patch();
a_er_cr_patch();
--a_er_deco_patch();
zz_enhanced_rebellions();

local ER = _G.ER;
turn_number = 200;
local MockContext_ER_CheckFactionRebellions = {
    Key = "ER_CheckFactionRebellions",
    Context = {
        faction = function() return humanFaction end,
    },
}
mock_listeners:trigger_listener(MockContext_ER_CheckFactionRebellions);

a_er_cr_patch();
--a_er_deco_patch();
zz_enhanced_rebellions();

turn_number = 200;
mock_listeners:trigger_listener(MockContext_ER_CheckFactionRebellions);

local ER_SettlementSelected = {
    Key = "ER_SettlementSelected",
    Context = {
        garrison_residence = function() return {
                region = function() return get_cm():get_region(); end,
                faction = function() return humanFaction; end,
            };
        end
    },
}
mock_listeners:trigger_listener(ER_SettlementSelected);


local ER_HordeDeclareWar = {
    Key = "ER_HordeDeclareWar",
    Context = {
        faction = function() return testFaction; end,
    },
};
mock_listeners:trigger_listener(ER_HordeDeclareWar);

turn_number = 3;
mock_listeners:trigger_listener(MockContext_ER_CheckFactionRebellions);

turn_number = 4;
local ER_AgentDeployDilemmaChoiceMade = {
    Key = "ER_AgentDeployDilemmaChoiceMade",
    Context = {
        dilemma = function() return "poe_deploy_agents_"; end,
        choice = function() return 1; end,
    },
}
mock_listeners:trigger_listener(ER_AgentDeployDilemmaChoiceMade);
mock_listeners:trigger_listener(MockContext_ER_CheckFactionRebellions);

turn_number = 15;
mock_listeners:trigger_listener(MockContext_ER_CheckFactionRebellions);

local ER_SettlementPanelOpened = {
    Key = "ER_SettlementPanelOpened",
    Context = {
        string = "settlement_panel",
    },
}
mock_listeners:trigger_listener(ER_SettlementPanelOpened);

turn_number = 5;
local ER_MilitaryCrackDownDilemmaChoiceMade = {
    Key = "ER_MilitaryCrackDownDilemmaChoiceMade",
    Context = {
        dilemma = function() return "poe_military_crackdown_"; end,
        choice = function() return 1; end,
    },
}
mock_listeners:trigger_listener(ER_MilitaryCrackDownDilemmaChoiceMade);
mock_listeners:trigger_listener(MockContext_ER_CheckFactionRebellions);

turn_number = 100;
mock_listeners:trigger_listener(MockContext_ER_CheckFactionRebellions);

ER_InitialiseSaveHelpers(cm, context);
ER_SaveActiveRebellions(ER);
ER_SaveActiveRebelForces(ER);
ER_SavePastRebellions(ER);
ER_SaveActivePREs(ER);
ER_SavePastPREs(ER);
ER_SaveReemergedFactions(ER);
ER_SaveConfederatedFactions(ER);
ER_SaveMilitaryCrackDowns(ER);
ER_SaveTriggeredAgentDeployDilemmas(ER);

ER_InitialiseLoadHelpers(cm, context);
ER_LoadActiveRebellions(ER);
ER_LoadRebelForces(ER);
ER_LoadPastRebellions(ER);
ER_LoadActivePREs(ER);
ER_LoadPastPREs(ER);
ER_LoadReemergedFactions(ER);
ER_LoadConfederatedFactions(ER);
ER_LoadMilitaryCrackDowns(ER);
ER_LoadAgentDeployDilemmas(ER);