

function a_er_aov_patch()
    if effect.get_localised_string("land_units_onscreen_name_wh2_dlc11_cst_cav_knights_of_the_realm_recruited") ~= "" then
        out("EnR: Loading AOV damned knights");
        --require 'script/_lib/pooldata/ArmyPoolData/AOVSubcultureArmyPoolDataResources'
        require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/AOVVampireCoastRebelArmyArchetypesPoolDataResources'
        --_G.ArmyPoolResources.AddAdditionalArmyPoolResources(GetAOVGhostKnightSubcultureArmyPoolDataResources());
        _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh2_dlc11_sc_cst_vampire_coast", GetAOVVampireCoastRebelArmyArchetypesPoolDataResources(), false);
    end
end