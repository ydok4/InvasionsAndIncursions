ER = {};
_G.ER = ER;

AG = {};
_G.AG = AG;

CG = {};
_G.CG = CG;

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

    AG = ArmyGenerator:new({});
    AG:Initialise(random_army_manager, enableLogging);
    CG = CharacterGenerator:new({});
    CG:Initialise(enableLogging);

    if core:is_mod_loaded("mct_campaign_init")
    and get_mct then
        local mct = get_mct();
        ER.Logger:Log("Found MCT reborn");
        ER:CheckMCTRebornOptions(core, mct);
    else
        ER.Logger:Log("No MCM");
        ER_SetupPostUIListeners(ER, core);
        --ER_SetupPostUIInterfaceListeners(ER, core, enableLogging);
    end
    ER.Logger:Log_Finished();
    _G.ER = ER;
    _G.CG = CG;
    _G.AG = AG;
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