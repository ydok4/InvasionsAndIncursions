function GetMixuSavageOrcRebelArmyArchetypesPoolDataResources()
    return {
        OrcWarboss = false,
        SavageOrcWarboss = {
            AgentSubtypes = {"grn_savage_orc_warboss", },
            MandatoryUnits = {
                wh_main_grn_inf_savage_orc_big_uns = 1,
            },
            UnitTags = {"SavageOrcs", "SavageOrcBoarBoyz", "Monsters", },
            Weighting = 3,
        },
        SavageOrcGreatShaman = {
            AgentSubtypes = {"grn_savage_orc_shaman", },
            MandatoryUnits = {
                wh_main_grn_inf_savage_orc_big_uns = 1,
            },
            UnitTags = {"SavageOrcs", "SavageOrcBoarBoyz", "Monsters", },
            Weighting = 2,
        },
    };
end