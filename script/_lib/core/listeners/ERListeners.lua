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
            local setPieceBattleKey = cm:model():pending_battle():set_piece_battle_key();
            if setPieceBattleKey ~= ""
            and cm:pending_battle_cache_is_quest_battle() == true then
                er.Logger:Log("setPieceBattleKey is: "..setPieceBattleKey);
                er.Logger:Log("Pending battle is quest battle");
                local involvedQBFactions = GetInvolvedQuestFactionKeysInBattle();
                for index, factionKey in pairs(involvedQBFactions) do
                    cm:change_localised_faction_name(factionKey, "factions_screen_name_"..factionKey);
                end
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
            local setPieceBattleKey = cm:model():pending_battle():set_piece_battle_key();
            if setPieceBattleKey ~= ""
            and cm:pending_battle_cache_is_quest_battle() == true then
                er.Logger:Log("setPieceBattleKey is: "..setPieceBattleKey);
                er.Logger:Log("Pending battle is quest battle");
                local involvedQBFactions = GetInvolvedQuestFactionKeysInBattle();
                for index, factionKey in pairs(involvedQBFactions) do
                    cm:change_localised_faction_name(factionKey, "factions_screen_name_when_rebels_"..factionKey);
                end
                er.Logger:Log_Finished();
            end
        end,
        true
    );

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

    -- These listeners exist to reduce the clutter in the diplomacy UI by hiding the proxy rebels
    -- Note: Flickering may occur when changing factions
    -- Bonus: It also hides other vanilla factions which are excluded from diplomacy
    local UIFlagCache = nil;
    local startedFromButton = false;
    core:add_listener(
        "ER_ClickedFactionInDiplomacy",
        "ComponentLClickUp",
        function(context)
            return string.match(context.string, "faction_row_entry_")
            or context.string == "button_diplomacy"
            or context.string == "flag";
        end,
        function(context)
            if context.string == "button_diplomacy" then
                startedFromButton = true;
            else
                er.Logger:Log("Diplomacy panel opened or faction changed");
                ER_HideRebelsInDiplomacy(er, UIFlagCache);
                er.Logger:Log_Finished();
            end
        end,
        true
    );

    core:add_listener(
        "ER_DiplomacyOpened",
        "PanelOpenedCampaign",
        function(context)
            return context.string == "diplomacy_dropdown";
        end,
        function(context)
            er.Logger:Log("Diplomacy panel opened");
            -- Callback required for hiding because otherwise this will happen before the UI
            -- is finished
            cm:callback(function(context)
                if startedFromButton == true then
                    startedFromButton = false;
                end
                ER_HideRebelsInDiplomacy(er, UIFlagCache);
            end,
            1);
            er.Logger:Log_Finished();
        end,
        true
    );

    -- Checks provinces for existing rebels and whether the data needs to be cleaned up
    -- and performs the actions to spawn rebels
    local numberOfRebellions = 0;
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
                        er:SpawnReemergingFactionPREs(region);
                        if spawnedRebellion == false then
                            spawnedRebellion = er:CheckForRebelSpawn(region);
                        end
                        if spawnedRebellion == true then
                            numberOfRebellions = numberOfRebellions + 1;
                        end
                    else
                        er:UpdatePREs(region);
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
            if er.ReemergedFactions[factionName] == true then
                er.Logger:Log("Checking ReEmerged faction: "..factionName);
            else
                er.Logger:Log("Rebel faction found: "..factionName);
            end
            for i = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(i);
                if cm:char_is_general_with_army(character) == true then
                    local militaryForceCqi = character:military_force():command_queue_index();
                    local rebelForceData = er.RebelForces[tostring(militaryForceCqi)];
                    --[[if er.ReemergedFactions[factionName] == true then
                        er.Logger:Log("Checking character: "..character:character_subtype_key());
                    end--]]
                    if rebelForceData ~= nil then
                        er.Logger:Log("Found character with military force: "..militaryForceCqi);
                        local characterLookupString = "character_cqi:"..character:command_queue_index();
                        local turnNumber = cm:model():turn_number();
                        local rebelForceTarget = cm:get_region(rebelForceData.Target);
                        -- If the rebel force can attack and they do not occupy the settlement already
                        if turnNumber > rebelForceData.SpawnTurn + 2
                        and rebelForceTarget:owning_faction():name() ~= factionName then
                            er.Logger:Log("Character has matching force data and is ready to attack");
                            cm:cai_enable_movement_for_character(characterLookupString);
                            local rebelForceTargetRegionKey = rebelForceTarget:name();
                            er.Logger:Log("Attacking region: "..rebelForceTargetRegionKey);
                            cm:attack_region(characterLookupString, rebelForceTargetRegionKey, false);
                            if er.ReemergedFactions[factionName] == true then
                                er.Logger:Log("Remerged faction will be untracked");
                                er:AddPastRebellion(rebelForceData);
                                er.RebelForces[tostring(militaryForceCqi)] = nil;
                            end
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
                            er:AddPastRebellion(rebelForceData);
                            er.RebelForces[tostring(militaryForceCqi)] = nil;
                            cm:cai_enable_movement_for_character(characterLookupString);
                        -- Non QB factions should be untracked and added as a past rebellion
                        elseif rebelForceTarget:owning_faction():name() == factionName then
                            er.Logger:Log("Non qb faction controls their target, untracking.");
                            er:AddPastRebellion(rebelForceData);
                            er.RebelForces[tostring(militaryForceCqi)] = nil;
                            cm:cai_enable_movement_for_character(characterLookupString);
                        end
                    else
                        er.Logger:Log("Missing RebelForces data. CQI: "..militaryForceCqi);
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
    -- We need to track whether a faction has joined a confederation
    -- so we know if they should reemerge
    core:add_listener(
        "ER_ConfederationListener",
        "FactionJoinsConfederation",
        function(context)
            return true;
        end,
        function(context)
            local confederee = context:faction():name();
            er.Logger:Log("Faction has been confederated: "..confederee);
            er:TrackConfederation(confederee);
            er.Logger:Log_Finished();
        end,
        true
    );

    -- Listens for crackdown dilemmas
    core:add_listener(
        "ER_MilitaryCrackDownDilemmaChoiceMade",
        "DilemmaChoiceMadeEvent",
        function(context)
            local dilemma = context:dilemma();
            if string.match(dilemma, "poe_military_crackdown_")
            -- THIS IS ONLY FOR TESTING
            or dilemma == "wh2_main_dilemma_treasure_hunt_shrine_to_nagash" then
                return true;
            end
            return false;
        end,
        function(context)
            local choice = context:choice();
            er.Logger:Log("Military crackdown choice made: "..choice);
            if choice == 0 then
                return;
            end
            er:AddMilitaryCrackDown();
            er.Logger:Log_Finished();
        end,
        true
    );

    -- Listens for deploy agents dilemmas
    core:add_listener(
        "ER_AgentDeployDilemmaChoiceMade",
        "DilemmaChoiceMadeEvent",
        function(context)
            local dilemma = context:dilemma();
            if string.match(dilemma, "poe_deploy_agents_") then
                return true;
            end
            return false;
        end,
        function(context)
            local choice = context:choice();
            er.Logger:Log("Deploy agents choice made: "..choice);
            if choice == 0 then
                er.Logger:Log_Finished();
                return;
            end
            er:AddAgentDeployDilemma(context:dilemma());
            er.Logger:Log_Finished();
        end,
        true
    );

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
    -- Just like Norsca, these listeners override the vanilla equivalents. This needs to happen because otherwise
    -- the Greenskin factions will keep confederating the Greenskin Proxy Rebels
    er.Logger:Log("Overriding Greenskin listeners");
    local GREENSKIN_CONFEDERATION_DILEMMA = "wh2_main_grn_confederate_";
    local GREENSKIN_CONFEDERATION_PLAYER = er.HumanFaction:name();
    local greenskin = "wh_main_sc_grn_greenskins";
    -- Confederation via Defeat Leader
    core:remove_listener("Greenskin_Confed_DilemmaChoiceMadeEvent");
	core:add_listener(
		"Greenskin_Confed_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma():starts_with(GREENSKIN_CONFEDERATION_DILEMMA);
		end,
		function(context)
            local faction = string.gsub(context:dilemma(), GREENSKIN_CONFEDERATION_DILEMMA, "");
            local choice = context:choice();
            if choice == 0 then
                -- Confederate
                cm:force_confederation(GREENSKIN_CONFEDERATION_PLAYER, faction);
            elseif choice == 1 then
                -- Kill leader
                local enemy = cm:model():world():faction_by_key(faction);
                if enemy:has_faction_leader() == true then
                    local leader = enemy:faction_leader();
                    if leader:character_subtype("dlc06_grn_skarsnik") == false and leader:character_subtype("dlc06_grn_wurrzag_da_great_prophet") == false and leader:character_subtype("grn_grimgor_ironhide") == false and leader:character_subtype("wh2_dlc15_grn_grom_the_paunch") == false and leader:character_subtype("grn_azhag_the_slaughterer") == false then
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
    core:remove_listener("character_completed_battle_greenskin_confederation_dilemma");
	core:add_listener(
		"character_completed_battle_greenskin_confederation_dilemma",
		"CharacterCompletedBattle",
		true,
		function(context)
			local character = context:character();
			if character:won_battle() == true and character:faction():subculture() == greenskin then
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
									GREENSKIN_CONFEDERATION_PLAYER = character:faction():name();
									cm:trigger_dilemma(GREENSKIN_CONFEDERATION_PLAYER, GREENSKIN_CONFEDERATION_DILEMMA..enemy:faction():name());
								elseif character:faction():is_human() == false and enemy:faction():is_human() == false then
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

function GetInvolvedQuestFactionKeysInBattle()
    local qbFactionKeys = {};
	for i = 1, cm:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
        local faction = cm:get_faction(current_faction_name);
        --er.Logger:Log("Battle participant: "..current_faction_name);
        if faction:is_null_interface() or faction:is_quest_battle_faction() == true then
            qbFactionKeys[#qbFactionKeys + 1] = faction:name();
		end;
	end;

	for i = 1, cm:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
        local faction = cm:get_faction(current_faction_name);
        --er.Logger:Log("Battle participant: "..current_faction_name);
        if faction:is_null_interface() or faction:is_quest_battle_faction() == true then
			qbFactionKeys[#qbFactionKeys + 1] = faction:name();
		end;
	end;
    return qbFactionKeys;
end

function ER_HideRebelsInDiplomacy(er, UIFlagCache)
    if UIFlagCache == nil then
        --er.Logger:Log("Cache is nil, setting cached tooltips");
        UIFlagCache = {};
        for subcultureKey, subcultureRebelData in pairs(_G.ERResources.RebelFactionPoolDataResources) do
            local rebelFactionName = effect.get_localised_string("factions_screen_name_when_rebels_"..subcultureRebelData.Default);
            UIFlagCache[rebelFactionName.." - Click to show on map"] = true;
        end
    end
    local rightStatusPanelEnemies = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel", "diplomatic_relations", "list", "icon_at_war", "enemies");
    ER_HideRebelsInStatusPanel(er, UIFlagCache, rightStatusPanelEnemies);
    local leftStatusPanelEnemies = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_left_status_panel", "diplomatic_relations", "list", "icon_at_war", "enemies");
    ER_HideRebelsInStatusPanel(er, UIFlagCache, leftStatusPanelEnemies);
end

function ER_HideRebelsInStatusPanel(er, UIFlagCache, statusPanelEnemies)
    local originalCoordinates = {};
    local numberOfHiddenEnemies = 0;
    for i = 0, statusPanelEnemies:ChildCount() - 1  do
        local enemy = UIComponent(statusPanelEnemies:Find(i));
        local tooltipText = enemy:GetTooltipText();
        if tooltipText == nil then
            er.Logger:Log("Tooltip text is nil");
        else
            local xPos, yPos = enemy:Position()
            originalCoordinates[#originalCoordinates + 1] = {xPos, yPos};
            if UIFlagCache[tooltipText] == true then
                enemy:SetVisible(false);
                numberOfHiddenEnemies = numberOfHiddenEnemies + 1;
            else
                if numberOfHiddenEnemies > 0 then
                    local moveToIndex = (i + 1) - numberOfHiddenEnemies;
                    enemy:MoveTo(originalCoordinates[moveToIndex][1], originalCoordinates[moveToIndex][2]);
                end
            end
        end
    end
end