function GetBeastmenRebelCorruptionArmyArchetypesPoolDataResources()
    return {
        BeastLordDefault = {
            CorruptionThreshold = 0,
            AgentSubtypes = {"dlc03_bst_beastlord", },
            UnitTags = {"Gors", "WarBeasts", "Monsters", },
            Weighting = 4,
        },
        BeastLordLow = {
            CorruptionThreshold = 30,
            AgentSubtypes = {"dlc03_bst_beastlord", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_bestigor_herd_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Monsters", },
            Weighting = 4,
        },
        BeastLordMed = {
            CorruptionThreshold = 50,
            AgentSubtypes = {"dlc03_bst_beastlord", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_bestigor_herd_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Monsters", },
            ArmySize = 15,
            Weighting = 4,
        },
        BeastLordHigh = {
            CorruptionThreshold = 75,
            AgentSubtypes = {"dlc03_bst_beastlord", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_bestigor_herd_0 = 2,
            },
            UnitTags = {"Gors", "WarBeasts", "Monsters", },
            ArmySize = 20,
            Weighting = 4,
        },
    };
end