function GetMixuBeastmenRebelArmyArchetypesPoolDataResources()
    return {
        DoomBull = {
            AgentSubtypes = {"bst_doombull", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_minotaurs_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Minotaurs" },
            Weighting = 1,
        },
        DoomBullChaosInvasionStage2 = {
            AgentSubtypes = {"bst_doombull", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_minotaurs_0 = 2,
            },
            UnitTags = {"Gors", "WarBeasts", "Minotaurs"},
            Weighting = 0,
        },
    };
end