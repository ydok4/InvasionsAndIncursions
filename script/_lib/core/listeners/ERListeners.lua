function ER_SetupPostUIListeners(er, core)

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
    core:add_listener(
        "ER_ResetWarDeclared",
        "FactionTurnStart",
        function(context)
            local faction = context:faction();
            return er.HumanFaction:name() == faction:name();
        end,
        function(context)
            cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared");
        end,
    true);

    core:add_listener(
        "ER_CheckFactionRebellions",
        "FactionAboutToEndTurn",
        function(context)
            local faction = context:faction();
            return er:IsExcludedFaction(faction) == false;
        end,
        function(context)
            local faction = context:faction();
            local factionKey = faction:name();
            local regionList = faction:region_list();
            local outputRegionChance = false;
            if factionKey == er.HumanFaction:name() then
                outputRegionChance = true;
            end
            -- Keeps track of the provinces we check
            -- we have 1 roll per province per turn
            local checkedProvinces = {};
            for i = 0, regionList:num_items() - 1 do
                local region = regionList:item_at(i);
                local regionKey = region:name();
                local provinceKey = region:province_name();
                if outputRegionChance == true and checkedProvinces[provinceKey] == nil then
                    er.Logger:Log("Checking player province: "..provinceKey);
                    --er.Logger:Log("Checking player region: "..regionKey);
                end
                local rebellionInFactionProvince = false;
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
                        if rebelForceTarget:is_null_interface() == false
                        and rebelForceTarget:is_abandoned() == true then
                            local rebelForceTargetRegionKey = rebelForceTarget:name();
                            er.Logger:Log("Target region is abandoned: "..rebelForceTargetRegionKey);
                            local character = militaryForce:general_character();
                            local characterLookupString = "character_cqi:"..character:command_queue_index();
                            cm:cai_enable_movement_for_character(characterLookupString);
                            er.Logger:Log("Untracking military force "..militaryForceCqi);
                            rebelData.Forces[index] = nil;
                            er:AddPastRebellion(rebelForceData);
                            er.RebelForces[militaryForceCqi] = nil;
                            -- Finally, we kill them and their force
                            cm:kill_character(character:command_queue_index(), true, true);
                            er.Logger:Log_Finished();
                        elseif rebelForceTarget:owning_faction():name() == factionKey then
                            local rebelForceTargetRegionKey = rebelForceTarget:name();
                            rebellionInFactionProvince = true;
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
                                er:UpdateDefeatedRebelEffectBundle(rebelForceTargetRegionKey);
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
                                    elseif rebelForceData.SpawnTurn + 3 > turnNumber
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
                                        if rebelForceData.SpawnTurn + 5 < turnNumber
                                        and positionString == rebelForceData.SpawnCoordinates then
                                            er.Logger:Log("Military force has stuck around too long, removing the force for faction: "..character:faction():name());
                                            -- Clean up force data
                                            rebelData.Forces[index] = nil;
                                            er:AddPastRebellion(rebelForceData);
                                            er.RebelForces[militaryForceCqi] = nil;
                                            -- Finally, we kill them and their force
                                            cm:kill_character(character:command_queue_index(), true, true);
                                            er.Logger:Log_Finished();
                                        end
                                    end
                                    er.Logger:Log_Finished();
                                end
                            end
                        end
                    end
                end
                if publicOrder < 0
                and rebellionInFactionProvince == false
                and checkedProvinces[provinceKey] == nil then
                    local rebellionChance = math.abs(publicOrder);
                    if outputRegionChance == true then
                        er.Logger:Log("Rebellion chance: "..rebellionChance);
                        er.Logger:Log_Finished();
                    end
                    if rebellionChance > 50 and rebellionChance ~= 100 then
                        rebellionChance = 50;
                    end
                    local spawnRebellion = Roll100(rebellionChance);
                    if spawnRebellion then
                        if outputRegionChance == true then
                            er.Logger:Log("Spawning rebellion for player.");
                        end
                        -- We have a timeout since the last rebellion was destroyed.
                        local isInTimeout = er:IsProvinceInTimeout(provinceKey, factionKey);
                        if isInTimeout == true then
                            er.Logger:Log("Can't spawn rebels for faction: "..faction:name().." because one was destroyed recently for faction.");
                        else
                            numberOfRebellions = numberOfRebellions + 1;
                            er.Logger:Log("Spawning rebellion in province: "..provinceKey.." for faction: "..faction:name());
                            local rebellionRegionKey = er:GetRebellionRegionForNewRebellion(region);
                            if rebellionRegionKey == nil then
                                er.Logger:Log("Can't trigger rebellion in region");
                            else
                                cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
                                er.Logger:Log("Rebellion will trigger in region: "..rebellionRegionKey);
                                local rebellionRegion = cm:get_region(rebellionRegionKey);
                                er:StartRebellion(rebellionRegion, faction);
                                er.Logger:Log("Spawned rebellion in province: "..provinceKey);
                            end
                        end
                        er.Logger:Log_Finished();
                    else
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
        "ER_RebelAttack",
        "FactionBeginTurnPhaseNormal",
        function(context)
            return context:faction():is_quest_battle_faction() == true;
        end,
        function(context)
            local faction = context:faction();
            local factionName = faction:name();
            local character_list = faction:character_list();
            er.Logger:Log("Rebel faction found: "..factionName);
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if character:has_military_force() then
                    local militaryForceCqi = character:military_force():command_queue_index();
                    er.Logger:Log("Found character with military force: "..militaryForceCqi);
                    local characterLookupString = "character_cqi:"..character:command_queue_index();
                    local turnNumber = cm:model():turn_number();
                    local rebelForceData = er.RebelForces[tostring(militaryForceCqi)];
                    local rebelForceTarget = cm:get_region(rebelForceData.Target);
                    if rebelForceData ~= nil
                    and turnNumber > rebelForceData.SpawnTurn + 2
                    and rebelForceTarget:owning_faction():name() ~= factionName then
                        er.Logger:Log("Character has matching force data and is ready to attack");
                        cm:cai_enable_movement_for_character(characterLookupString);
                        local rebelForceTargetRegionKey = rebelForceTarget:name();
                        er.Logger:Log("Attacking region: "..rebelForceTargetRegionKey);
                        cm:attack_region(characterLookupString, rebelForceTargetRegionKey, true);
                    else
                        -- If the region does belong to the QB/Proxy Rebel faction declare war on the
                        -- surrounding factions
                        local adjacentRegionList = rebelForceTarget:adjacent_region_list();
                        local atWarWithFactions = {};
                        cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
                        for i = 0, adjacentRegionList:num_items() - 1 do
                            local adjacentRegion = adjacentRegionList:item_at(i);
                            if adjacentRegion:is_null_interface() == false
                            and adjacentRegion:is_abandoned() == false
                            and atWarWithFactions[adjacentRegion:owning_faction():name()] == nil then
                                atWarWithFactions[adjacentRegion:owning_faction():name()] = true;
                                cm:force_declare_war(rebelForceData.FactionKey, adjacentRegion:owning_faction():name(), false, false);
                            end
                        end
                    end
                end
            end
            er.Logger:Log_Finished();
        end,
        true
    );
    er.Logger:Log("Overriding Norscan listeners");
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
							cm:trigger_dilemma(NORSCA_CONFEDERATION_PLAYER, NORSCA_CONFEDERATION_DILEMMA..enemy:faction():name());
							--Play_Norsca_Advice("dlc08.camp.advice.nor.confederation.001", norsca_info_text_confederation);
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
    er.Logger:Log_Finished();
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