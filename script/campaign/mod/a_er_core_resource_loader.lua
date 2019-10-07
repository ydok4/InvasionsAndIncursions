require 'script/_lib/pooldata/RebelFactionPoolData/RebelFactionPoolDataResources'
require 'script/_lib/pooldata/ProvinceSubcultureRebellionsPoolData/ProvinceSubcultureRebellionsPoolDataResources'

require 'script/_lib/pooldata/RebelCorruptionArmyArchetypesPoolData/BeastmenRebelCorruptionArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelCorruptionArmyArchetypesPoolData/ChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelCorruptionArmyArchetypesPoolData/SkavenRebelCorruptionArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelCorruptionArmyArchetypesPoolData/VampireCoastRebelCorruptionArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelCorruptionArmyArchetypesPoolData/VampireCountsRebelCorruptionArmyArchetypesPoolDataResources'

require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/BeastmenRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/BretonniaRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/ChaosRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/DarkElfRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/DwarfRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/EmpireRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/GreenskinRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/HighElfRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/KislevRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/LizardmenRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/NorscaRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/SavageOrcRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/SkavenRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/TEBRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/TombKingsRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/VampireCoastRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/VampireCountsRebelArmyArchetypesPoolDataResources'
require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/WoodElfRebelArmyArchetypesPoolDataResources'

require 'script/_lib/pooldata/PassiveRebelEventsPoolData/BretonniaPREPoolDataResources'

_G.ERResources = {
    RebelFactionPoolDataResources = GetRebelFactionPoolDataResources(),
    ProvinceSubcultureRebellionsPoolDataResources = GetProvinceSubcultureRebellionsPoolDataResources(),
    AddAdditionalProvinceRebellionResources = function(resources)
        local existingProvincesResources = _G.ERResources.ProvinceSubcultureRebellionsPoolDataResources;
        for provinceKey, provinceData in pairs(resources) do
            if existingProvincesResources[provinceKey] == nil then
                existingProvincesResources[provinceKey] = provinceData;
            else
                local existingProvinceData = existingProvincesResources[provinceKey];
                if provinceData.IsAdjacentToSea ~= nil then
                    existingProvinceData.IsAdjacentToSea = provinceData.IsAdjacentToSea;
                end

                for subcultureKey, subcultureData in pairs(provinceData.RebelSubcultures) do
                    if existingProvinceData.RebelSubcultures[subcultureKey] == nil then
                        existingProvinceData.RebelSubcultures[subcultureKey] = subcultureData;
                    else
                        local existingSubcultureData = existingProvinceData.RebelSubcultures[subcultureKey];
                        if subcultureData.Weighting ~= nil then
                            existingSubcultureData.Weighting = subcultureData.Weighting;
                        end
                        if subcultureData.ArmyArchetypes ~= nil then
                            for armyArchetypeKey, armyArchetypeData in pairs(subcultureData.ArmyArchetypes) do
                                if existingSubcultureData.ArmyArchetypes == nil then
                                    existingSubcultureData.ArmyArchetypes = {};
                                end
                                local existingArmyArchetype = existingSubcultureData.ArmyArchetypes[armyArchetypeKey];
                                if existingArmyArchetype == nil then
                                    existingArmyArchetype = {};
                                    existingArmyArchetype[armyArchetypeKey] = armyArchetypeData;
                                else
                                    if armyArchetypeData == false then
                                        existingArmyArchetype[armyArchetypeKey] = nil;
                                    else
                                        if armyArchetypeData.Weighting ~= nil then
                                            existingArmyArchetype[armyArchetypeKey] = armyArchetypeData.Weighting;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end,
    RebelCorruptionArmyArchetypesPoolData = {
        wh_dlc03_sc_bst_beastmen_corruption = GetBeastmenRebelCorruptionArmyArchetypesPoolDataResources(),
        wh_main_sc_chs_chaos_corruption = GetChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources(),
        wh2_main_sc_skv_skaven_corruption = GetSkavenRebelCorruptionArmyArchetypesPoolDataResources(),
        wh2_dlc11_sc_cst_vampire_coast_corruption = GetVampireCoastRebelCorruptionArmyArchetypesPoolDataResources(),
        wh_main_sc_vmp_vampire_counts_corruption = GetVampireCountsRebelCorruptionArmyArchetypesPoolDataResources(),
    },
    RebelArmyArchetypesPoolData = {
        wh_dlc03_sc_bst_beastmen = GetBeastmenRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_brt_bretonnia = GetBretonniaRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_chs_chaos = GetChaosRebelArmyArchetypesPoolDataResources(),
        wh2_main_sc_def_dark_elves = GetDarkElfRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_dwf_dwarfs = GetDwarfRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_emp_empire = GetEmpireRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_grn_greenskins = GetGreenskinRebelArmyArchetypesPoolDataResources(),
        wh2_main_sc_hef_high_elves = GetHighElfRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_ksl_kislev = GetKislevRebelArmyArchetypesPoolDataResources(),
        wh2_main_sc_lzd_lizardmen = GetLizardmenRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_nor_norsca = GetNorscaRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_grn_savage_orcs = GetSavageOrcRebelArmyArchetypesPoolDataResources(),
        wh2_main_sc_skv_skaven = GetSkavenRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_teb_teb = GetTEBRebelArmyArchetypesPoolDataResources(),
        wh2_dlc09_sc_tmb_tomb_kings = GetTombKingsRebelArmyArchetypesPoolDataResources(),
        wh2_dlc11_sc_cst_vampire_coast = GetVampireCoastRebelArmyArchetypesPoolDataResources(),
        wh_main_sc_vmp_vampire_counts = GetVampireCountsRebelArmyArchetypesPoolDataResources(),
        wh_dlc05_sc_wef_wood_elves = GetWoodElfRebelArmyArchetypesPoolDataResources(),
    },
    AddAdditionalRebelArmyArchetypesResources = function(subculture, data, isCorruption)
        local existingSubcultureArchetypes = {};
        if isCorruption == true then
            existingSubcultureArchetypes = _G.ERResources.RebelCorruptionArmyArchetypesPoolData[subculture][subculture];
        else
            existingSubcultureArchetypes = _G.ERResources.RebelArmyArchetypesPoolData[subculture][subculture];
        end
        for armyArchetypeKey, armyArchetypeData in pairs(data[subculture]) do
            if existingSubcultureArchetypes[armyArchetypeKey] == nil then
                existingSubcultureArchetypes[armyArchetypeKey] = armyArchetypeData;
            elseif armyArchetypeData == false then
                existingSubcultureArchetypes[armyArchetypeKey] = nil;
            else
                local existingArchetype = existingSubcultureArchetypes[armyArchetypeKey];
                if data.AgentSubtypes ~= nil then
                    existingArchetype.AgentSubtypes = data.AgentSubtypes;
                end
                if data.UnitTags ~= nil then
                    existingArchetype.UnitTags = data.UnitTags;
                end
                if data.Weighting ~= nil then
                    existingArchetype.Weighting = data.Weighting;
                end
            end
        end
    end,
    PassiveRebelEventsPoolData = {
        wh_main_sc_brt_bretonnia = GetBretonniaPREPoolDataResources(),
    },
    AddAdditionPassiveRebelEventResources = function(subculture, data)

    end,
};

require 'script/_lib/dbexports/SubCultureNameGroupResources'
require 'script/_lib/dbexports/AgentDataResources'
require 'script/_lib/dbexports/NameGroupResources'
require 'script/_lib/dbexports/NameResources'

-- Load the name resources
-- This is separate so I can use this in other mods
if not _G.CG_NameResources then
    _G.CG_NameResources = {
        ConcatTableWithKeys = function(self, destinationTable, sourceTable)
            for key, value in pairs(sourceTable) do
                destinationTable[key] = value;
            end
        end,
        subculture_to_name_groups = GetSubCultureNameGroupResources(),
        faction_to_name_groups = GetNameGroupResources(),
        name_groups_to_names = GetNameResources(),
        campaign_character_data = GetAgentDataResources(),
    };
end