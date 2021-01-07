if core:is_mod_loaded("mixu_ttl") then
    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/MixuBeastmenRebelArmyArchetypesPoolDataResources'
    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/MixuChaosRebelArmyArchetypesPoolDataResources'
    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/MixuEmpireRebelArmyArchetypesPoolDataResources'
    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/MixuGreenskinRebelArmyArchetypesPoolDataResources'
    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/MixuNorscaRebelArmyArchetypesPoolDataResources'
    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/MixuSavageOrcRebelArmyArchetypesPoolDataResources'
    --require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/MixuWoodElfRebelArmyArchetypesPoolDataResources'

    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_dlc03_sc_bst_beastmen", GetMixuBeastmenRebelArmyArchetypesPoolDataResources(), false);
    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_chs_chaos", GetMixuChaosRebelArmyArchetypesPoolDataResources(), false);
    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_emp_empire", GetMixuEmpireRebelArmyArchetypesPoolDataResources(), false);
    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_grn_greenskins", GetMixuGreenskinRebelArmyArchetypesPoolDataResources(), false);
    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_nor_norsca", GetMixuNorscaRebelArmyArchetypesPoolDataResources(), false);
    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_grn_savage_orcs", GetMixuSavageOrcRebelArmyArchetypesPoolDataResources(), false);
    --_G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_dlc05_sc_wef_wood_elves", GetMixuWoodElfRebelArmyArchetypesPoolDataResources(), false);

    require 'script/_lib/pooldata/RebelCorruptionArmyArchetypesPoolData/MixuBeastmenRebelCorruptionArmyArchetypesPoolDataResources'
    require 'script/_lib/pooldata/RebelCorruptionArmyArchetypesPoolData/MixuChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources'

    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_dlc03_sc_bst_beastmen_corruption", GetMixuBeastmenRebelCorruptionArmyArchetypesPoolDataResources(), true);
    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_chs_chaos_corruption", GetMixuChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources(), true);

    require 'script/_lib/pooldata/ProvinceSubcultureRebellionsPoolData/MixuProvinceSubcultureRebellionsPoolDataResources'

    _G.ERResources.AddAdditionalProvinceRebellionResources(GetMixuProvinceSubcultureRebellionsPoolDataResources());


    require 'script/_lib/dbexports/MixuDataResources'

    out("EnR: Loading Mixu Data");
    -- Load the name resources
    -- This is separate so I can use this in other mods
    if _G.CG_NameResources then
        _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.campaign_character_data, GetMixuDataResources());
    end
end