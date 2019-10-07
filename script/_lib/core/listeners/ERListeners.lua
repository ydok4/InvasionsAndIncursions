function ER_SetupPostUIListeners(er, core)

    -- The following listeners exist to try and reduce the amount of
    -- event feed spam from rebel factions dying
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

    -- Checks provinces for existing rebels and whether the data needs to be cleaned up
    -- and performs the actions to spawn rebels
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
            -- Keeps track of the provinces we check
            -- we have 1 roll per province per turn
            local checkedProvinces = {};
            for i = 0, regionList:num_items() - 1 do
                local region = regionList:item_at(i);
                local provinceKey = region:province_name();
                local rebellionInFactionProvince = false;
                if checkedProvinces[provinceKey] == nil then
                    rebellionInFactionProvince = er:UpdateExistingRebels(region);
                    if rebellionInFactionProvince == false then
                        local spawnedRebellion = false;
                        spawnedRebellion = er:UpdatePREs(region);
                        er:SpawnPREs(region);
                        if spawnedRebellion == false then
                            spawnedRebellion = er:CheckForRebelSpawn(region);
                        end
                        if spawnedRebellion == true then
                            numberOfRebellions = numberOfRebellions + 1;
                        end
                    end
                end
                checkedProvinces[provinceKey] = true;
            end
        end,
        true
    );
    -- Another event feed cleanup listener which happens after we spawn the rebels
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
    -- Call the attack region command for the rebels when the QB faction begins their turn
    core:add_listener(
        "ER_RebelAttack",
        "FactionBeginTurnPhaseNormal",
        function(context)
            local factionKey = context:faction():name();
            return er.ReemergedFactions[factionKey] == true
            or context:faction():is_quest_battle_faction() == true;
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
                    if rebelForceData ~= nil then
                        local rebelForceTarget = cm:get_region(rebelForceData.Target);
                        -- If the rebel force can attack and they do not occupy the settlement already
                        if turnNumber > rebelForceData.SpawnTurn + 2
                        and rebelForceTarget:owning_faction():name() ~= factionName then
                            er.Logger:Log("Character has matching force data and is ready to attack");
                            cm:cai_enable_movement_for_character(characterLookupString);
                            local rebelForceTargetRegionKey = rebelForceTarget:name();
                            er.Logger:Log("Attacking region: "..rebelForceTargetRegionKey);
                            cm:attack_region(characterLookupString, rebelForceTargetRegionKey, true);
                        -- This only happens if they have occuped the settlement and they are a QB faction
                        elseif rebelForceTarget:owning_faction():name() == factionName
                        and context:faction():is_quest_battle_faction() == true then
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
                        -- Non QB factions should be untracked and added as a past rebellion
                        elseif rebelForceTarget:owning_faction():name() == factionName then
                            er:AddPastRebellion(rebelForceData);
                            er.RebelForces[militaryForceCqi] = nil;
                        end
                    end
                end
            end
            er.Logger:Log_Finished();
        end,
        true
    );

    -- Faction reemergeance listener to add the right PRE
    core:add_listener(
        "ER_IsFactionDestroyed",
        "FactionTurnStart",
        function(context)
            local faction = context:faction();
            return faction:is_dead() == true;
        end,
        function(context)

        end,
        true
    );

    -- PRE listeners

    -- These listeners override the vanilla equivalents. This needs to happen because otherwise
    -- the Norscan factions will keep confederating the Norscan Proxy Rebels
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