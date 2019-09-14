function GetMixuSavageOrcRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_grn_savage_orcs = {
            SavageOrcWarboss = {
                AgentSubtypes = {"grn_savage_orc_warboss", },
                MandatoryUnits = {
                    wh_main_grn_inf_savage_orc_big_uns = 1,
                },
                UnitTags = {"SavageOrcs", "SavageOrcBoarBoyz", "Monsters", },
                Weighting = 3,
            },
            OrcWarboss = false,
        },
    };
end