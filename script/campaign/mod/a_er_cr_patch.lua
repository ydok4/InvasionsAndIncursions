require 'script/_lib/pooldata/ArmyPoolData/CRSubcultureArmyPoolDataResources'

function a_er_cr_patch()
    -- If this loc is present, then Chaos Robie's Ghorgon must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_bst_mon_ghorgon_0") ~= "" then
        out("MC: Loading CR ghorgon resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRGhorgonSubcultureArmyPoolDataResources())
    end

    -- If this loc is present, then Chaos Robie's Preyton must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_bst_mon_preyton_0") ~= "" then
        out("MC: Loading CR Preyton resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRPreytonSubcultureArmyPoolDataResources())
    end

    -- If this loc is present, then Chaos Robie's Spear Chukka must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_grn_art_spear_chukka") ~= "" then
        out("MC: Loading CR spear chukka resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRSpearChukkaSubcultureArmyPoolDataResources())
    end

    -- If this loc is present, then Chaos Robie's Sky Cutter must be enabled
    if effect.get_localised_string("land_units_onscreen_name_cr_hef_veh_lothern_skycutter") ~= "" then
        out("MC: Loading CR sky cutter resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRSkyCutterSubcultureArmyPoolDataResources())
    end

    -- If this loc is present, then Chaos Robie's Daemonettes must be enabled
    if effect.get_localised_string("land_units_onscreen_name_bacr_chs_inf_daemonette") ~= "" then
        out("MC: Loading CR Daemonette resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRDaemonettesSubcultureArmyPoolDataResources())
    end

    -- If this loc is present, then Chaos Robie's Bloodletter must be enabled
    if effect.get_localised_string("land_units_onscreen_name_kho_bloodletter") ~= "" then
        out("MC: Loading CR bloodletter resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRBloodletterSubcultureArmyPoolDataResources())
    end

    -- If this loc is present, then Chaos Robie's Plague bearer must be enabled
    if effect.get_localised_string("land_units_onscreen_name_rbt_nurgle_daemon") ~= "" then
        out("MC: Loading CR plaguebearer resources");
        _G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetCRPlaguebearerSubcultureArmyPoolDataResources())
    end
end