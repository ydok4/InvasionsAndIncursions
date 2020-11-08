if core:is_mod_loaded("dindis_special_pr") then
    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/DecoKislevRebelArmyArchetypesPoolDataResources'

    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_ksl_kislev", GetDecoKislevRebelArmyArchetypesPoolDataResources(), false);
    require 'script/_lib/dbexports/DecoDataResources'

    out("EnR: Loading Deco Data");
    -- Load the name resources
    -- This is separate so I can use this in other mods
    if _G.CG_NameResources then
        _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.campaign_character_data, GetDecoDataResources());
    end
end