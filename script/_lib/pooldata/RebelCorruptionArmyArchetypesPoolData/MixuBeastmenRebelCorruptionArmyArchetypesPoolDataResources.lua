function GetMixuBeastmenRebelCorruptionArmyArchetypesPoolDataResources()
    return {
        wh_dlc03_sc_bst_beastmen_corruption = {
            DoomBullLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"bst_doombull", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_minotaurs_0 = 2,
                },
                UnitTags = {"Gors", "WarBeasts", "Minotaurs", },
                ArmySize = 13,
                Weighting = 1,
            },
            DoomBullMedium = {
                CorruptionThreshold = 60,
                AgentSubtypes = {"bst_doombull", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_minotaurs_1 = 2,
                },
                UnitTags = {"Gors", "WarBeasts", "Minotaurs", },
                ArmySize = 17,
                Weighting = 1,
            },
            DoomBullHigh = {
                CorruptionThreshold = 60,
                AgentSubtypes = {"bst_doombull", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_minotaurs_2 = 2,
                },
                UnitTags = {"Gors", "WarBeasts", "Minotaurs", },
                ArmySize = 20,
                Weighting = 1,
            },
        },
    };
end