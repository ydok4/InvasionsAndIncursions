local anyLoaded = false;
if core:is_mod_loaded("cataph_kraka") then
    require 'script/_lib/pooldata/ProvinceSubcultureRebellionsPoolData/CataphKrakaDrakProvinceSubcultureRebellionsPoolDataResources'

    _G.ERResources.AddAdditionalProvinceRebellionResources(GetCataphKrakaDrakProvinceSubcultureRebellionsPoolDataResources());

    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/CataphKrakaDrakRebelArmyArchetypesPoolDataResources'

    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_dwf_dwarfs", GetCataphKrakaDrakRebelArmyArchetypesPoolDataResources(), false);
    anyLoaded = true;
end

if core:is_mod_loaded("cataph_aislinn") then
    require 'script/_lib/pooldata/ProvinceSubcultureRebellionsPoolData/CataphHighElfProvinceSubcultureRebellionsPoolDataResources'

    _G.ERResources.AddAdditionalProvinceRebellionResources(GetCataphHighElfProvinceSubcultureRebellionsPoolDataResources());

    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/CataphHighElfRebelArmyArchetypesPoolDataResources'

    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh2_main_sc_hef_high_elves", GetCataphHighElfRebelArmyArchetypesPoolDataResources(), false);
end

if core:is_mod_loaded("cataph_teb") then
    require 'script/_lib/pooldata/ProvinceSubcultureRebellionsPoolData/CataphTEBProvinceSubcultureRebellionsPoolDataResources'

    _G.ERResources.AddAdditionalProvinceRebellionResources(GetCataphTEBProvinceSubcultureRebellionsPoolDataResources());

    require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/CataphTEBRebelArmyArchetypesPoolDataResources'

    _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_teb_teb", GetCataphTEBRebelArmyArchetypesPoolDataResources(), false);
    anyLoaded = true;
end

if anyLoaded == true then
    require 'script/_lib/dbexports/CataphDataResources'

    out("EnR: Loading Cataph Data");
    -- Load the name resources
    -- This is separate so I can use this in other mods
    if _G.CG_NameResources then
        _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.campaign_character_data, GetCataphDataResources());
    end
end