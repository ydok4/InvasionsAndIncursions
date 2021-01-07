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
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/DarkElvesPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/DwarfPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/EmpirePREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/GreenskinPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/HighElvesPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/LizardmenPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/SkavenPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/TombKingsPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/VampireCoastPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/VampireCountsPREPoolDataResources'
require 'script/_lib/pooldata/PassiveRebelEventsPoolData/WoodElvesPREPoolDataResources'

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
                if provinceData.RebelSubcultures ~= nil then
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
                if provinceData.PassiveRebelEvents ~= nil then
                    for subcultureKey, subcultureData in pairs(provinceData.PassiveRebelEvents) do
                        if existingProvinceData.PassiveRebelEvents == nil then
                            existingProvinceData.PassiveRebelEvents = {};
                        end
                        if existingProvinceData.PassiveRebelEvents[subcultureKey] == nil then
                            existingProvinceData.PassiveRebelEvents[subcultureKey] = subcultureData;
                        else
                            local existingSubcultureData = existingProvinceData.PassiveRebelEvents[subcultureKey];
                            if subcultureData.Weighting ~= nil then
                                existingSubcultureData.Weighting = subcultureData.Weighting;
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
            existingSubcultureArchetypes = _G.ERResources.RebelCorruptionArmyArchetypesPoolData[subculture];
        else
            existingSubcultureArchetypes = _G.ERResources.RebelArmyArchetypesPoolData[subculture];
        end
        for armyArchetypeKey, armyArchetypeData in pairs(data) do
            if existingSubcultureArchetypes[armyArchetypeKey] == nil then
                existingSubcultureArchetypes[armyArchetypeKey] = armyArchetypeData;
            elseif armyArchetypeData == false then
                existingSubcultureArchetypes[armyArchetypeKey] = nil;
            else
                local existingArchetype = existingSubcultureArchetypes[armyArchetypeKey];
                if armyArchetypeData.AgentSubtypes ~= nil then
                    existingArchetype.AgentSubtypes = armyArchetypeData.AgentSubtypes;
                end
                if armyArchetypeData.UnitTags ~= nil then
                    existingArchetype.UnitTags = armyArchetypeData.UnitTags;
                end
                if armyArchetypeData.Weighting ~= nil then
                    existingArchetype.Weighting = armyArchetypeData.Weighting;
                end
                if armyArchetypeData.MandatoryUnits ~= nil then
                    for unitKey, mandatoryUnit in pairs(armyArchetypeData.MandatoryUnits) do
                        -- Note: Groups of mandatory units are a flat replace
                        if mandatoryUnit == false then
                            existingArchetype.MandatoryUnits[unitKey] = nil;
                        elseif type(mandatoryUnit) == "table" then
                            table.insert(existingArchetype.MandatoryUnits, mandatoryUnit);
                        else
                            -- Set the amount of the mandatory unit
                            existingArchetype.MandatoryUnits[unitKey] = mandatoryUnit;
                        end
                    end
                end
            end
        end
    end,
    PassiveRebelEventsPoolData = {
        default = {},
        wh_dlc03_sc_bst_beastmen = {},
        wh_main_sc_brt_bretonnia = GetBretonniaPREPoolDataResources(),
        wh2_main_sc_def_dark_elves = GetDarkElvesPREPoolDataResources(),
        wh_main_sc_dwf_dwarfs = GetDwarfPREPoolDataResources(),
        wh_main_sc_emp_empire = GetEmpirePREPoolDataResources(),
        wh_main_sc_grn_greenskins = GetGreenskinPREPoolDataResources(),
        wh2_main_sc_hef_high_elves = GetHighElvesPREPoolDataResources(),
        wh2_main_sc_lzd_lizardmen = GetLizardmenPREPoolDataResources(),
        wh_main_sc_nor_norsca = {},
        wh_main_sc_grn_savage_orcs = {},
        wh2_main_sc_skv_skaven = GetSkavenPREPoolDataResources(),
        wh_main_sc_teb_teb = {},
        wh2_dlc09_sc_tmb_tomb_kings = GetTombKingsPREPoolDataResources(),
        wh2_dlc11_sc_cst_vampire_coast = GetVampireCoastPREPoolDataResources(),
        wh_main_sc_vmp_vampire_counts = GetVampireCountsPREPoolDataResources(),
        wh_dlc05_sc_wef_wood_elves = GetWoodElvesPREPoolDataResources(),
    },
    AddAdditionalPassiveRebelEventResources = function(data)
        local existingPREPoolData = _G.ERResources.PassiveRebelEventsPoolData;
        for subcultureKey, subculturePREData in pairs(data) do
            if existingPREPoolData[subcultureKey] == nil then
                existingPREPoolData[subcultureKey] = {};
            end
            for preKey, preData in pairs(subculturePREData) do
                if existingPREPoolData[subcultureKey][preKey] == nil then
                    existingPREPoolData[subcultureKey][preKey] = preData;
                end
            end
        end
    end,
};

require 'script/_lib/dbexports/AgentDataResources'
require 'script/_lib/dbexports/NameGenerator/SubCultureNameGroupResources'
require 'script/_lib/dbexports/NameGenerator/NameGroupResources'
require 'script/_lib/dbexports/NameGenerator/NameResources'
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