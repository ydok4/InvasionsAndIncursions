function GetBeastmenRebelArmyArchetypesPoolDataResources()
    return {
        BeastLord = {
            AgentSubtypes = {"dlc03_bst_beastlord", },
            UnitTags = {"Gors", "WarBeasts", },
            Weighting = 5,
        },
        BeastLordGorsChaosInvasionStage1 = {
            AgentSubtypes = {"dlc03_bst_beastlord", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_bestigor_herd_0 = 2,
                wh_dlc03_bst_mon_chaos_spawn_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Centigors", },
            Weighting = 0,
        },
        BeastLordMonstersChaosInvasionStage1 = {
            AgentSubtypes = {"dlc03_bst_beastlord", },
            MandatoryUnits = {
                wh_dlc03_bst_mon_giant_0 = 1,
                wh_dlc03_bst_mon_chaos_spawn_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", },
            Weighting = 0,
        },
        BeastLordGorsChaosInvasionStage2 = {
            AgentSubtypes = {"dlc03_bst_beastlord", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_bestigor_herd_0 = 2,
                wh_dlc03_bst_mon_chaos_spawn_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Centigors", },
            Weighting = 0,
        },
        BeastLordMonstersChaosInvasionStage2 = {
            AgentSubtypes = {"dlc03_bst_beastlord", },
            MandatoryUnits = {
                wh_dlc03_bst_mon_giant_0 = 2,
                wh_dlc03_bst_mon_chaos_spawn_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Monsters" },
            Weighting = 0,
        },
    };
end