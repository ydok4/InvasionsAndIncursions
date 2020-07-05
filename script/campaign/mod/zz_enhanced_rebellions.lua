ER = {};
_G.ER = ER;

-- Helpers
require 'script/_lib/core/helpers/ER_DataHelpers';
require 'script/_lib/core/helpers/ER_LoadHelpers';
require 'script/_lib/core/helpers/ER_SaveHelpers';
-- Models
require 'script/_lib/core/model/ERController';
require 'script/_lib/core/model/ArmyGenerator';
require 'script/_lib/core/model/CharacterGenerator';
require 'script/_lib/core/model/Logger';
-- Listeners
require 'script/_lib/core/listeners/ERListeners';
require 'script/_lib/core/listeners/ERUIListeners';

function zz_enhanced_rebellions()
    local enableLogging = false;
    out("EnR: Main mod function");
    ER = ERController:new({
        ActiveRebellions = ER.ActiveRebellions,
        RebelForces = ER.RebelForces,
        PastRebellions = ER.PastRebellions,
        EnableCorruptionArmies = true,
        ActivePREs = ER.ActivePREs,
        PastPREs = ER.PastPREs,
        ReemergedFactions = ER.ReemergedFactions,
        ConfederatedFactions = ER.ConfederatedFactions,
        MilitaryCrackDowns = ER.MilitaryCrackDowns,
        TriggeredAgentDeployDilemmas = ER.TriggeredAgentDeployDilemmas,
    });
    ER:Initialise(random_army_manager, enableLogging);
    ER.Logger:Log("Initialised");
    if mcm then
        ER.Logger:Log("Found MCM");
        if cm:is_new_game() then
            ER.Logger:Log("Found MCM for new game!");
            -- Setup default values for options
            cm:set_saved_value("mcm_tweaker_public_order_expanded_toggle_rebellions_value", "enable_rebellions");
            cm:set_saved_value("mcm_tweaker_public_order_expanded_toggle_corruption_armies_value", "enable_corruption_armies");
            local poe = mcm:register_mod("public_order_expanded", "Public Order: Expanded", "Rebellion spawning settings");
            -- Setup toggle rebellion fields
            local toggleRebellions = poe:add_tweaker("toggle_rebellions", "Incursions", "Enable or disable the new rebellions");
            toggleRebellions:add_option("enable_rebellions", "Enable", "Enable extra incursions based on negative public order");
            toggleRebellions:add_option("disable_rebellions", "Disable", "Disable extra incursions based on negative public order");
            -- Setup toggle corruption army fields
            local toggleCorruptionArmies = poe:add_tweaker("toggle_corruption_armies", "Corruption incursion armies", "Enable or disable corruption army archetypes which can spawn in regions with corruption. Corruption armies may make the AI struggle a bit more and may make it easy for races which spread corruption. Requires the rebellions to be enabled.");
            toggleCorruptionArmies:add_option("enable_corruption_armies", "Enable", "Enable corruption army archetypes which can spawn in regions with corruption.");
            toggleCorruptionArmies:add_option("disable_corruption_armies", "Disable", "Disable corruption army archetypes which can spawn in regions with corruption. Requires the rebellions to be enabled.");
            -- Setup listeners for new game. Every load afterwards this is handled below.
            mcm:add_new_game_only_callback(function()
                ER:CheckMCTOptions(core);
            end);
        else
            ER:CheckMCTOptions(core);
        end
    elseif mct then
        ER.Logger:Log("Found MCT reborn");
        ER:CheckMCTRebornOptions(core, mct);
    else
        ER.Logger:Log("No MCM");
        ER_SetupPostUIListeners(ER, core);
        --ER_SetupPostUIInterfaceListeners(ER, core, enableLogging);
    end
    ER.Logger:Log_Finished();
    _G.ER = ER;
    out("EnR: Finished setup");
end

-- Saving/Loading Callbacks
cm:add_saving_game_callback(
    function(context)
        out("EnR: Saving callback");
        local enabledRebellions = cm:get_saved_value("mcm_tweaker_public_order_expanded_toggle_rebellions_value");
        if not mcm or (enabledRebellions == nil or enabledRebellions == "enable_rebellions") then
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
        end
        out("EnR: Finished saving");
    end
);

cm:add_loading_game_callback(
    function(context)
        out("EnR: Loading callback");
        local enabledRebellions = cm:get_saved_value("mcm_tweaker_public_order_expanded_toggle_rebellions_value");
        if not mcm or (enabledRebellions == nil or enabledRebellions == "enable_rebellions") then
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
        end
        out("EnR: Finished loading");
	end
);