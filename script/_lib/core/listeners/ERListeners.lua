function ER_SetupPostUIListeners(er)
    -- Doesn't seem to work...
    core:add_listener(
        "ER_DisableRebellions",
        "FactionTurnStart",
        function(context)
            cm:disable_rebellions_worldwide(true);
            return false;
        end,
        function(context)

        end,
        0,
        true
    );

    core:add_listener(
        "ER_PendingBattle",
        "PendingBattle",
        function(context)
            local pb = cm:model():pending_battle();
            local attacker = pb:attacker();
			local defender = pb:defender();
            return attacker:is_quest_battle_faction() == true or defender:is_quest_battle_faction() == true;
        end,
        function(context)
            --er.Logger:Log("QB Faction pending battle");
            cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
            --er.Logger:Log_Finished();
        end,
        true
    );

    core:add_listener(
        "ER_BattleCompleted",
        "BattleCompleted",
        function(context)
            local pb = cm:model():pending_battle();
            local attacker = pb:attacker();
			local defender = pb:defender();
            return attacker:is_quest_battle_faction() == true or defender:is_quest_battle_faction() == true;
        end,
        function(context)
            --er.Logger:Log("QB Faction completed battle");
            cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
            --er.Logger:Log_Finished();
        end,
        true
    );

    core:add_listener(
        "ER_CheckFactionRebellions",
        "FactionTurnEnd",
        function(context)
            cm:disable_rebellions_worldwide(true);
            local faction = context:faction();
            return er:IsExcludedFaction(faction) == false;
        end,
        function(context)
            cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
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
                        -- If they have stuck around this long, it usually indicates they got stuck or started going
                        -- on a rampage through the region. In both cases we need to clear up the force.
                        elseif rebelForceTarget:is_null_interface() == false
                        and rebelForceData.SpawnTurn < (turnNumber - 7) then
                            er.Logger:Log("Military force has stuck around too long, removing the force.");
                            local character = militaryForce:general_character();
                            cm:kill_character(character:command_queue_index(), true, true);
                            -- Clean up force data
                            rebelData.Forces[index] = nil;
                            er:AddPastRebellion(rebelForceData);
                            er.RebelForces[militaryForceCqi] = nil;
                            er.Logger:Log_Finished();
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
                            er.Logger:Log_Finished();
                        else
                            -- To ensure we are only updating a rebel force once per turn
                            -- we check if the target region owner matches the faction whose turn we are
                            -- checking
                            if region:owning_faction():name() == rebelForceTarget:owning_faction():name() then
                                er.Logger:Log("Checking military force: "..militaryForceCqi);
                                if rebelForceData.SpawnedOnSea == true then
                                    er.Logger:Log("Enabling attack for sea rebellion in: "..rebelForceTargetRegionKey);
                                    local character = militaryForce:general_character();
                                    local characterLookupString = "character_cqi:"..character:command_queue_index();
                                    if character:region():is_null_interface() then
                                        er.Logger:Log("Character is in sea still");
                                        local owningFactionKey = rebelForceTarget:owning_faction():name();
                                        local interimX, interimY = cm:find_valid_spawn_location_for_character_from_settlement(
                                            owningFactionKey,
                                            rebelForceTargetRegionKey,
                                            -- Rebellion spawn
                                            true,
                                            -- Spawn on sea
                                            false,
                                            -- Spawn distance (optional).
                                            -- Note: 9 is the distance which is also used for Skaven
                                            -- under city incursions
                                            9
                                        );
                                        cm:move_to(characterLookupString, interimX, interimY, false);
                                    else
                                        cm:attack_region(characterLookupString, rebelForceTarget:name(), true);
                                    end
                                elseif rebelForceData.SpawnTurn + 2 > turnNumber then
                                --and militaryForce:strength() < rebelForceTarget:garrison_residence():army():strength() then
                                    er.Logger:Log("Granting units to rebellion in region: "..rebelForceTargetRegionKey);
                                    local character = militaryForce:general_character();
                                    local characterLookupString = "character_cqi:"..character:command_queue_index();
                                    if rebelForceData.SpawnedOnSea == false then
                                        cm:force_character_force_into_stance(characterLookupString, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
                                    end
                                    er:GrantUnitsForForce(rebelForceData, militaryForce);
                                else
                                    er.Logger:Log("Enabling attack for rebellion in: "..rebelForceTargetRegionKey);
                                    local character = militaryForce:general_character();
                                    local characterLookupString = "character_cqi:"..character:command_queue_index();
                                    cm:cai_enable_movement_for_character(characterLookupString);
                                    cm:attack_region(characterLookupString, rebelForceTarget:name(), true);
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
            cm:callback(function()
                cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
            end,
            0.25);
        end,
        true
    );

    -- We remove the vanilla listener because we need to tweak the condition
    core:remove_listener("character_completed_battle_norsca_confederation_dilemma");
    core:add_listener(
	"character_completed_battle_norsca_confederation_dilemma",
	"CharacterCompletedBattle",
	true,
	function(context)
		local character = context:character();
		
		if character:won_battle() == true and character:faction():subculture() == NORSCA_SUBCULTURE then
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
	true
);
end