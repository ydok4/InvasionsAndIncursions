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


function zz_enhanced_rebellions()
    out("EnR: Main mod function");
    ER = ERController:new({
        ActiveRebellions = ER.ActiveRebellions,
        RebelForces = ER.RebelForces,
        PastRebellions = ER.PastRebellions,
    });
    ER:Initialise(random_army_manager, false);
    ER.Logger:Log("Initialised");
    ER_SetupPostUIListeners(ER, core);
    ER.Logger:Log_Finished();
    out("EnR: Finished setup");
end

-- Saving/Loading Callbacks
cm:add_saving_game_callback(
    function(context)
        out("EnR: Saving callback");
        ER_InitialiseSaveHelpers(cm, context);
        ER_SaveActiveRebellions(ER);
        ER_SaveActiveRebelForces(ER);
        ER_SavePastRebellions(ER);
        out("Enr: Finished saving");
    end
);

cm:add_loading_game_callback(
    function(context)
        out("EnR: Loading callback");
        ER_InitialiseLoadHelpers(cm, context);
        ER_LoadActiveRebellions(ER);
        ER_LoadRebelForces(ER);
        ER_LoadPastRebellions(ER);
        out("EnR: Finished loading");
	end
);