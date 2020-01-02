function GetMixuBeastmenRebelCorruptionArmyArchetypesPoolDataResources()
    return {
        DoomBullMedium = {
            CorruptionThreshold = 50,
            AgentSubtypes = {"bst_doombull", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_minotaurs_0 = 2,
            },
            UnitTags = {"Gors", "WarBeasts", "Minotaurs", },
            ArmySize = 13,
            Weighting = 1,
        },
        DoomBullHigh = {
            CorruptionThreshold = 85,
            AgentSubtypes = {"bst_doombull", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_minotaurs_2 = 2,
            },
            UnitTags = {"Gors", "WarBeasts", "Minotaurs", },
            ArmySize = 20,
            Weighting = 1,
        },
    };
end