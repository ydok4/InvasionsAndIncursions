function ER_SetupPostUIListeners(er)
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
                                    cm:cai_enable_movement_for_character(characterLookupString);
                                    cm:attack_region(characterLookupString, rebelForceTarget:name(), true);
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
                    local spawnRebellion = Roll100(math.abs(publicOrder));
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
end