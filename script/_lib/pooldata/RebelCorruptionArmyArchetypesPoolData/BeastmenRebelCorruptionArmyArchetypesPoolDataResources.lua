function GetBeastmenRebelCorruptionArmyArchetypesPoolDataResources() 
    return {
        wh_dlc03_sc_bst_beastmen_corruption = {
            BeastLordDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = {"dlc03_bst_beastlord", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 1,
                },
                UnitTags = {"Gors", "WarBeasts", "Monsters", },
                ArmySize = 13,
                Weighting = 3,
            },
            BeastLordLow = {
                CorruptionThreshold = 20,
                AgentSubtypes = {"dlc03_bst_beastlord", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 1,
                },
                UnitTags = {"Gors", "WarBeasts", "Monsters", },
                ArmySize = 13,
                Weighting = 3,
            },
            BeastLordMed = {
                CorruptionThreshold = 40,
                AgentSubtypes = {"dlc03_bst_beastlord", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 1,
                },
                UnitTags = {"Gors", "WarBeasts", "Monsters", },
                ArmySize = 17,
                Weighting = 3,
            },
            BeastLordHigh = {
                CorruptionThreshold = 60,
                AgentSubtypes = {"dlc03_bst_beastlord", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 2,
                },
                UnitTags = {"Gors", "WarBeasts", "Monsters", },
                ArmySize = 20,
                Weighting = 3,
            },
        },
    };
end