function z_overwrite_confederation_listeners()
    out("EnR: Overwrite confederation listeners");
    -- These listeners override the vanilla equivalents. This needs to happen because otherwise
    -- the Norscan factions will keep confederating the Norscan Proxy Rebels
    out("EnR: Overriding Norscan listeners");
    local NORSCA_SUBCULTURE = "wh_main_sc_nor_norsca";
    local NORSCA_CONFEDERATION_DILEMMA = "wh2_dlc08_confederate_";
    -- We remove these vanilla listeners because we need to tweak the condition to exclude the quest battle factions
    -- which are used by the rebels we spawn
    core:remove_listener("character_completed_battle_norsca_confederation_dilemma");
    core:add_listener(
        "character_completed_battle_norsca_confederation_dilemma",
        "CharacterCompletedBattle",
        true,
        function(context)
            local character = context:character();
            if character:won_battle() == true and character:faction():subculture() == NORSCA_SUBCULTURE and not character:faction():name():find("rebel") 
            and not character:faction():name():find("invasion") and not character:faction():name():find("separatists") and not character:faction():name():find("incursion") and character:faction():is_quest_battle_faction() == false then
                local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
                local enemy_count = #enemies;

                if context:pending_battle():night_battle() == true or context:pending_battle():ambush_battle() == true then
                    enemy_count = 1;
                end

                local character_cqi = character:command_queue_index();
                local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(1);
                local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
                out("ER: Custom norscan battle completed");
                if character_cqi == attacker_cqi or character_cqi == defender_cqi then
                    for i = 1, enemy_count do
                        local enemy = enemies[i];

                        if enemy ~= nil
                        and enemy:is_null_interface() == false
                        and enemy:is_faction_leader() == true
                        and enemy:faction():subculture() == NORSCA_SUBCULTURE
                        and not enemy:faction():name():find("rebel")
                        and not enemy:faction():name():find("invasion")
                        and not enemy:faction():name():find("separatists")
                        and not enemy:faction():name():find("incursion")
                        and enemy:faction():is_quest_battle_faction() == false then
                            if enemy:has_military_force() == true and enemy:military_force():is_armed_citizenry() == false then
                                out("ER: Confederating faction: "..enemy:faction():name());
                                if character:faction():is_human() == true and enemy:faction():is_human() == false and enemy:faction():is_dead() == false then
                                    -- Trigger dilemma to offer confederation
                                    -- NORSCA_CONFEDERATION_PLAYER is defined in the original script
                                    NORSCA_CONFEDERATION_PLAYER = character:faction():name();
                                    cm:trigger_dilemma(NORSCA_CONFEDERATION_PLAYER, NORSCA_CONFEDERATION_DILEMMA..enemy:faction():name());
                                elseif not character:faction():name():find("rebel") and character:faction():is_human() == false and enemy:faction():is_human() == false then
                                    -- AI confederation
                                    cm:force_confederation(character:faction():name(), enemy:faction():name());
                                end
                            end
                        end
                    end
                end
            end
        end,
        true
    );

        -- Just like Norsca, these listeners override the vanilla equivalents. This needs to happen because otherwise
    -- the Greenskin factions will keep confederating the Greenskin Proxy Rebels
    out("EnR: Overriding Greenskin listeners");
    local GREENSKIN_CONFEDERATION_DILEMMA = "wh2_main_grn_confederate_";
    local greenskin = "wh_main_sc_grn_greenskins";
    -- Confederation via Defeat Leader
    core:remove_listener("character_completed_battle_greenskin_confederation_dilemma");
	core:add_listener(
		"character_completed_battle_greenskin_confederation_dilemma",
		"CharacterCompletedBattle",
		true,
        function(context)
            local character = context:character();
            if character:won_battle() == true and character:faction():subculture() == greenskin and not character:faction():name():find("rebel") 
            and not character:faction():name():find("invasion") and not character:faction():name():find("waaagh") and character:faction():is_quest_battle_faction() == false then
                local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
                local enemy_count = #enemies;
                if context:pending_battle():night_battle() == true or context:pending_battle():ambush_battle() == true then
                    enemy_count = 1;
                end

                local character_cqi = character:command_queue_index();
                local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(1);
                local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
                if character_cqi == attacker_cqi or character_cqi == defender_cqi then
                    for i = 1, enemy_count do
                        local enemy = enemies[i];
                        if enemy ~= nil and enemy:is_null_interface() == false and enemy:is_faction_leader() == true and enemy:faction():subculture() == greenskin and enemy:faction():is_quest_battle_faction() == false then
                            if enemy:has_military_force() == true and enemy:military_force():is_armed_citizenry() == false then
                                if character:faction():is_human() == true and enemy:faction():is_human() == false and enemy:faction():is_dead() == false then
                                    -- Trigger dilemma to offer confederation
                                    -- GREENSKIN_CONFEDERATION_PLAYER is defined in the original script
                                    GREENSKIN_CONFEDERATION_PLAYER = character:faction():name();
                                    cm:trigger_dilemma(GREENSKIN_CONFEDERATION_PLAYER, GREENSKIN_CONFEDERATION_DILEMMA..enemy:faction():name());
                                elseif not character:faction():name():find("rebel") and character:faction():is_human() == false and enemy:faction():is_human() == false then
                                    out.design("###### Modified greenskin CONFEDERATION");
                                    -- AI confederation
                                    cm:force_confederation(character:faction():name(), enemy:faction():name());
                                    out.design("###### AI GREENSKIN CONFEDERATION");
                                    out.design("Faction: "..character:faction():name().." is confederating "..enemy:faction():name());
                                end
                            end
                        end
                    end
                end
            end
		end,
		true
	);
end