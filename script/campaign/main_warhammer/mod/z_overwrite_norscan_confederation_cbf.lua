function z_overwrite_norscan_confederation_cbf()
    out("EnR: Overwrite cbf listener");
    core:remove_listener("cbf_character_completed_battle_norsca_confederation_dilemma");
end