function ER_SetupPostUIListeners(er)
    local isQBFactionInvolvedInBattle = false;
    core:add_listener(
        "ER_PendingBattle",
        "PendingBattle",
        function(context)
            return true;
        end,
        function(context)
            isQBFactionInvolvedInBattle = IsQuestBattleFactionInvolvedInBattle(er);
            if isQBFactionInvolvedInBattle == true then
                er.Logger:Log("QB Faction pending battle");
                cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
                er.Logger:Log_Finished();
            end
        end,
        true
    );

    core:add_listener(
		"ER_BattleResolvedWithoutFighting",
        "BattleCompletedCameraMove",
        function(context)
            return isQBFactionInvolvedInBattle == true;
        end,
		function(context)
            local battleFought = cm:model():pending_battle():has_been_fought();
            if battleFought == false then
                er.Logger:Log("A faction has withdrawn from the battle");
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed"); end, 0);
                isQBFactionInvolvedInBattle = false;
                er.Logger:Log_Finished();
            end
        end,
    true);

    core:add_listener(
        "ER_BattleCompleted",
        "BattleCompleted",
        function(context)
            return true;
        end,
        function(context)
            if isQBFactionInvolvedInBattle == true then
                er.Logger:Log("QB Faction completed battle");
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed"); end, 0);
                isQBFactionInvolvedInBattle = false;
                er.Logger:Log_Finished();
            end
        end,
        true
    );

    local numberOfRebellions = 0;
    local numberOfCharactersToRemove = 0;
    core:add_listener(
        "ER_CheckFactionRebellions",
        "FactionAboutToEndTurn",
        function(context)
            local faction = context:faction();
            return er:IsExcludedFaction(faction) == false;
        end,
        function(context)
            local faction = context:faction();
            local regionList = faction:region_list();
            -- Keeps track of the provinces we check
            -- we have 1 roll per province per turn
            local checkedProvinces = {};
            for i = 0, regionList:num_items() - 1 do
                local region = regionList:item_at(i);
                local regionKey = region:name();
                local provinceKey = region:province_name();
                --er.Logger:Log("Checking region: "..regionKey.." in province: "..provinceKey);
                local publicOrder = region:public_order();
                -- If we have a negative public order
                -- and
                -- we don't have any active rebel armies
                -- TBD: Won't handle multiple rebellions, at least not initially
                if er.ActiveRebellions[provinceKey] ~= nil
                and TableHasAnyValue(er.ActiveRebellions[provinceKey].Forces)
                and checkedProvinces[provinceKey] == nil then
                    local turnNumber = cm:model():turn_number();
                    local rebelData = er.ActiveRebellions[provinceKey];
                    for index, militaryForceCqi in pairs(rebelData.Forces) do
                        local militaryForce = cm:model():military_force_for_command_queue_index(tonumber(militaryForceCqi));
                        local rebelForceData = er.RebelForces[tostring(militaryForceCqi)];
                        local rebelForceTarget = cm:get_region(rebelForceData.Target);
                        local rebelForceTargetRegionKey = rebelForceTarget:name();
                        -- We need to first check for cases where we need to remove any rebels in the province
                        -- This happens when the rebels have been killed.
                        if militaryForce == nil
                        or militaryForce:is_null_interface() then
                            if militaryForce == nil then
                                er.Logger:Log("Military force is missing");
                            end
                            er.Logger:Log("Rebellion force: "..militaryForceCqi.." is missing from region: "..rebelForceTargetRegionKey);
                            rebelData.Forces[index] = nil;
                            er:AddPastRebellion(rebelForceData);
                            er.RebelForces[militaryForceCqi] = nil;
                            er.Logger:Log_Finished();
                            -- Remove the incursion effect bundle (if it is still there)
                            cm:remove_effect_bundle_from_region("er_effect_bundle_generic_incursion_region", rebelForceTargetRegionKey);
                            -- Then add a larger public order boost to celebrate beating the rebels
                            cm:apply_effect_bundle_to_region("er_effect_bundle_generic_incursion_defeated", regionKey, 5);
                        elseif rebelForceTarget:is_null_interface() == false
                        and rebelForceTarget:is_abandoned() == true then
                            er.Logger:Log("Target region is abandoned: "..rebelForceTargetRegionKey);
                            local character = militaryForce:general_character();
                            local characterLookupString = "character_cqi:"..character:command_queue_index();
                            cm:cai_enable_movement_for_character(characterLookupString);
                            er.Logger:Log("Untracking military force "..militaryForceCqi);
                            rebelData.Forces[index] = nil;
                            er:AddPastRebellion(rebelForceData);
                            er.RebelForces[militaryForceCqi] = nil;
                            -- If this was a sea rebellion and they are still on the sea we should just kill them
                            if rebelForceData.SpawnedOnSea == true and character:region():is_null_interface() then
                                numberOfCharactersToRemove = numberOfCharactersToRemove + 1;
                                -- Finally, we kill them and their force
                                cm:kill_character(character:command_queue_index(), true, true);
                            end
                            er.Logger:Log_Finished();
                        else
                            local character = militaryForce:general_character();
                            -- To ensure we are only updating a rebel force once per turn
                            -- we check if the target region owner matches the faction whose turn we are
                            -- checking
                            if region:owning_faction():name() == rebelForceTarget:owning_faction():name() then
                                er.Logger:Log("Checking military force: "..militaryForceCqi);
                                if rebelForceData.SpawnedOnSea == true
                                and character:region():is_null_interface() then
                                    er.Logger:Log("Character is in sea still");
                                    local characterLookupString = "character_cqi:"..character:command_queue_index();
                                    local owningFactionKey = rebelForceTarget:owning_faction():name();
                                    local interimX, interimY = cm:find_valid_spawn_location_for_character_from_settlement(
                                        owningFactionKey,
                                        rebelForceTargetRegionKey,
                                        -- Spawn on sea
                                        false,
                                        -- Rebellion spawn
                                        true,
                                        -- Spawn distance (optional).
                                        -- Note: 9 is the distance which is also used for Skaven
                                        -- under city incursions
                                        9
                                    );
                                    cm:teleport_to(characterLookupString, interimX, interimY, true);
                                    cm:cai_disable_movement_for_character(characterLookupString);
                                    cm:force_character_force_into_stance(characterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
                                elseif rebelForceData.SpawnTurn + 2 > turnNumber
                                and rebelForceData.SpawnedOnSea == false then
                                    er.Logger:Log("Granting units to rebellion in region: "..rebelForceTargetRegionKey);
                                    local characterLookupString = "character_cqi:"..character:command_queue_index();
                                    if rebelForceData.SpawnedOnSea == false then
                                        cm:force_character_force_into_stance(characterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
                                    end
                                    er:GrantUnitsForForce(rebelForceData, militaryForce);
                                else
                                    local positionString = character:logical_position_x().."/"..character:logical_position_y();
                                    -- The character should move on the turn after we tell them to attack
                                    -- If their position matches their spawn position, then they are stuck
                                    -- and should be removed. This is pretty rare but can happen in some settlements
                                    if rebelForceData.SpawnTurn + 3 < turnNumber
                                    and positionString == rebelForceData.SpawnCoordinates then
                                        er.Logger:Log("Military force has stuck around too long, removing the force for faction: "..character:faction():name());
                                        cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
                                        -- Clean up force data
                                        rebelData.Forces[index] = nil;
                                        er:AddPastRebellion(rebelForceData);
                                        er.RebelForces[militaryForceCqi] = nil;
                                        numberOfCharactersToRemove = numberOfCharactersToRemove + 1;
                                        -- Finally, we kill them and their force
                                        cm:kill_character(character:command_queue_index(), true, true);
                                        er.Logger:Log_Finished();
                                    else
                                        er.Logger:Log("Enabling attack for rebellion in: "..rebelForceTargetRegionKey);
                                        local characterLookupString = "character_cqi:"..character:command_queue_index();
                                        cm:cai_enable_movement_for_character(characterLookupString);
                                        cm:attack_region(characterLookupString, rebelForceTarget:name(), true);
                                    end
                                end
                                er.Logger:Log_Finished();
                            end
                        end
                    end
                elseif publicOrder < 0
                and checkedProvinces[provinceKey] == nil
                and (er.ActiveRebellions[provinceKey] == nil or not TableHasAnyValue(er.ActiveRebellions[provinceKey].Forces)) then
                    local rebellionChance = math.abs(publicOrder);
                    if rebellionChance > 50 and rebellionChance ~= 100 then
                        rebellionChance = 50;
                    end
                    local spawnRebellion = Roll100(rebellionChance);
                    if spawnRebellion then
                        cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
                        numberOfRebellions = numberOfRebellions + 1;
                        -- We have a timeout since the last rebellion was destroyed.
                        local isInTimeout = er:IsProvinceInTimeout(provinceKey);
                        if isInTimeout == true then
                            er.Logger:Log("Can't spawn rebels for faction: "..faction:name().." because one was destroyed recently");
                        else
                            er.Logger:Log("Spawning rebellion in province: "..provinceKey.." for faction: "..faction:name());
                            local rebellionRegionKey = er:GetRebellionRegionForNewRebellion(region);
                            er.Logger:Log("Rebellion will trigger in region: "..rebellionRegionKey);
                            local rebellionRegion = cm:get_region(rebellionRegionKey);
                            er:StartRebellion(rebellionRegion, faction);
                            er.Logger:Log("Spawned rebellion in region: "..provinceKey);
                        end
                        er.Logger:Log_Finished();
                    end
                end
                checkedProvinces[provinceKey] = true;
            end
        end,
        true
    );

	core:add_listener(
		"ER_ScriptedEventEnableDiplomacyListener",
		"ER_ScriptedEventEnableDiplomacy",
		true,
        function(context)
            er.Logger:Log("ER_ScriptedEventEnableDiplomacyListener");
            if numberOfRebellions > 0 then
                numberOfRebellions = numberOfRebellions - 1;
            else
                cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared");
            end
            er.Logger:Log_Finished();
        end,
		true
	);

    core:add_listener(
        "ER_CharacterConvalescedOrKilled",
        "CharacterConvalescedOrKilled",
        function(context)
            return true;
        end,
        function(context)
            if numberOfCharactersToRemove == 1 then
                er.Logger:Log("QB Faction removed manually...re-enabling diplomacy_faction_destroyed");
                cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed");
                er.Logger:Log_Finished();
                numberOfCharactersToRemove = numberOfCharactersToRemove - 1;
            elseif numberOfCharactersToRemove > 1 then
                numberOfCharactersToRemove = numberOfCharactersToRemove - 1;
            end
        end,
        true
    );

    local NORSCA_SUBCULTURE = "wh_main_sc_nor_norsca";
    local NORSCA_CONFEDERATION_DILEMMA = "wh2_dlc08_confederate_";
    local NORSCA_CONFEDERATION_PLAYER = er.HumanFaction:name();
    -- We remove these vanilla listeners because we need to tweak the condition to exclude the quest battle factions
    -- which are used by the rebels we spawn
    core:remove_listener("character_completed_battle_norsca_confederation_dilemma");
    core:add_listener(
	"character_completed_battle_norsca_confederation_dilemma",
	"CharacterCompletedBattle",
	true,
    function(context)
        local character = context:character();
        if character:won_battle() == true and character:faction():subculture() == NORSCA_SUBCULTURE then
            local norsca_info_text_confederation = {"war.camp.prelude.nor.confederation.info_001", "war.camp.prelude.nor.confederation.info_002", "war.camp.prelude.nor.confederation.info_003"};
            local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
			local enemy_count = #enemies;
			if context:pending_battle():night_battle() == true or context:pending_battle():ambush_battle() == true then
				enemy_count = 1;
			end
			for i = 1, enemy_count do
				local enemy = enemies[i];
				if enemy ~= nil and enemy:is_null_interface() == false and enemy:is_faction_leader() == true and enemy:faction():subculture() == NORSCA_SUBCULTURE and enemy:faction():is_quest_battle_faction() == false then
					if enemy:has_military_force() == true and enemy:military_force():is_armed_citizenry() == false then
						if character:faction():is_human() == true and enemy:faction():is_human() == false and enemy:faction():is_dead() == false then
							-- Trigger dilemma to offer confederation
							NORSCA_CONFEDERATION_PLAYER = character:faction():name();
							cm:trigger_dilemma(NORSCA_CONFEDERATION_PLAYER, NORSCA_CONFEDERATION_DILEMMA..enemy:faction():name(), true);
							Play_Norsca_Advice("dlc08.camp.advice.nor.confederation.001", norsca_info_text_confederation);
                        elseif character:faction():is_human() == false
                        and enemy:faction():is_human() == false then
							-- AI confederation
							cm:force_confederation(character:faction():name(), enemy:faction():name());
						end
					end
				end
			end
		end
	end,
    true);
    core:remove_listener("Norsca_Confed_DilemmaChoiceMadeEvent");
    core:add_listener(
		"Norsca_Confed_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma():starts_with(NORSCA_CONFEDERATION_DILEMMA);
		end,
		function(context)
            local faction = string.gsub(context:dilemma(), NORSCA_CONFEDERATION_DILEMMA, "");
            local choice = context:choice();
            if choice == 0 then
                -- Confederate
                cm:force_confederation(NORSCA_CONFEDERATION_PLAYER, faction);
            elseif choice == 1 then
                -- Kill leader
                local enemy = cm:model():world():faction_by_key(faction);
                if enemy:has_faction_leader() == true then
                    local leader = enemy:faction_leader();
                    if leader:character_subtype("wh_dlc08_nor_wulfrik") == false and leader:character_subtype("wh_dlc08_nor_throgg") == false then
                        local cqi = leader:command_queue_index();
                        cm:set_character_immortality("character_cqi:"..cqi, false);
                        cm:kill_character(cqi, false, true);
                    end
                end
            end
            -- autosave on legendary
            if cm:model():difficulty_level() == -3 and not cm:is_multiplayer() then
                cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5);
            end;
		end,
		true
	);
end

function IsQuestBattleFactionInvolvedInBattle(er)
	for i = 1, cm:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
        local faction = cm:get_faction(current_faction_name);
        --er.Logger:Log("Battle participant: "..current_faction_name);
        if faction:is_null_interface() or faction:is_quest_battle_faction() == true then
			return true;
		end;
	end;

	for i = 1, cm:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
        local faction = cm:get_faction(current_faction_name);
        --er.Logger:Log("Battle participant: "..current_faction_name);
        if faction:is_null_interface() or faction:is_quest_battle_faction() == true then
			return true;
		end;
	end;
    return false;
end