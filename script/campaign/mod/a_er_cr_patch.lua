require 'script/_lib/pooldata/ArmyPoolData/CRSubcultureArmyPoolDataResources'

function a_er_cr_patch()
    -- If this loc is present, then Chaos Robie's Ghorgon must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_bst_mon_ghorgon_0") ~= "" then
        out("EnR: Loading CR ghorgon resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRGhorgonSubcultureArmyPoolDataResources());
    end

    -- If this loc is present, then Chaos Robie's Preyton must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_bst_mon_preyton_0") ~= "" then
        out("EnR: Loading CR Preyton resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRPreytonSubcultureArmyPoolDataResources());
    end

    if effect.get_localised_string("land_units_onscreen_name_cr_bst_mon_preyton_0") ~= ""
    and effect.get_localised_string("land_units_onscreen_name_cr_bst_mon_ghorgon_0") ~= "" then
        require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/CRBeastmenRebelArmyArchetypesPoolDataResources'
        _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_dlc03_sc_bst_beastmen", GetCRBeastmentRebelArmyArchetypesPoolDataResources(), false);
        if core:is_mod_loaded("mixu_ttl") then
            require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/CRMixuBeastmenRebelArmyArchetypesPoolDataResources'
            _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_dlc03_sc_bst_beastmen", GetCRMixuBeastmenRebelArmyArchetypesPoolDataResources(), false);
        end
    end

    -- If this loc is present, then Chaos Robie's Spear Chukka must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_grn_art_spear_chukka") ~= "" then
        out("EnR: Loading CR spear chukka resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRSpearChukkaSubcultureArmyPoolDataResources());
    end

    -- If this loc is present, then Chaos Robie's Sky Cutter must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_hef_veh_lothern_skycutter") ~= "" then
        out("EnR: Loading CR sky cutter resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRSkyCutterSubcultureArmyPoolDataResources());
    end

    -- If this loc is present, then Chaos Robie's Daemonettes must be enabled
    --[[if effect.get_localised_string("land_units_onscreen_name_bacr_chs_inf_daemonette") ~= "" then
        out("EnR: Loading CR Daemonette resources");
       -- _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRDaemonettesSubcultureArmyPoolDataResources());
    end

    -- If this loc is present, then Chaos Robie's Bloodletter must be enabled
    if effect.get_localised_string("land_units_onscreen_name_kho_bloodletter") ~= "" then
        out("EnR: Loading CR bloodletter resources");
       --_G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRBloodletterSubcultureArmyPoolDataResources());
    end

    -- If this loc is present, then Chaos Robie's Plague bearer must be enabled
    if effect.get_localised_string("land_units_onscreen_name_rbt_nurgle_daemon") ~= "" then
        out("EnR: Loading CR plaguebearer resources");
        --_G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRPlaguebearerSubcultureArmyPoolDataResources());
    end--]]

    if effect.get_localised_string("land_units_onscreen_name_cr_skv_mon_chimaerat_0") ~= nil then
        out("EnR: Loading CR Chimaerat resources");
        _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh2_main_sc_skv_skaven", GetCRChimaeratSubcultureArmyPoolDataResources(), false);
    end

    if effect.get_localised_string("land_units_onscreen_name_rbt_nurgle_daemon") ~= ""
    and effect.get_localised_string("land_units_onscreen_name_kho_bloodletter") ~= ""
    and effect.get_localised_string("land_units_onscreen_name_bacr_chs_inf_daemonette") ~= "" then
        out("EnR: Loading Balint Daemon resources");
        require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/CRChaosRebelArmyArchetypesPoolDataResources'
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRDaemonSubcultureArmyPoolDataResources());
        _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_chs_chaos", GetCRChaosRebelArmyArchetypesPoolDataResources(), false);
    end
end