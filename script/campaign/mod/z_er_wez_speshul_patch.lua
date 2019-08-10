require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/WezSpeshulSavageOrcRebelArmyArchetypesPoolDataResources'

_G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_main_sc_grn_savage_orcs", GetWezSpeshulSavageOrcRebelArmyArchetypesPoolDataResources(), false);

require 'script/_lib/pooldata/ProvinceSubcultureRebellionsPoolData/WezSpeshulProvinceSubcultureRebellionsPoolDataResources'

_G.ERResources.AddAdditionalProvinceRebellionResources(GetWezSpeshulProvinceSubcultureRebellionsPoolDataResources());


require 'script/_lib/dbexports/WezSpeshulDataResources'

out("EnR: Loading Wez Speshul Data");
-- Load the name resources
-- This is separate so I can use this in other mods
if _G.CG_NameResources then
    _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.campaign_character_data, GetWezSpeshulDataResources());
end
