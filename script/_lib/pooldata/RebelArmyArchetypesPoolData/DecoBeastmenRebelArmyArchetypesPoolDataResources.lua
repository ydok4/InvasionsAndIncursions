function GetDecoBeastmenRebelArmyArchetypesPoolDataResources()
    return {
        GreatBrayShaman = {
            AgentSubtypes = {"bst_bray_shaman_beasts", "bst_bray_shaman_death", "bst_bray_shaman_wild", },
            UnitTags = {"Gors", "Monsters", },
            Weighting = 2,
        },
        GreatBrayShamanChaosInvasionStage1 = {
            AgentSubtypes = {"bst_bray_shaman_beasts", "bst_bray_shaman_death", "bst_bray_shaman_wild", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_cygor_0 = 1,
                wh_dlc03_bst_mon_chaos_spawn_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Monsters" },
            Weighting = 0,
        },
        GreatBrayShamanChaosInvasionStage2 = {
            AgentSubtypes = {"bst_bray_shaman_beasts", "bst_bray_shaman_death", "bst_bray_shaman_wild", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_cygor_0 = 2,
                wh_dlc03_bst_mon_chaos_spawn_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Monsters" },
            Weighting = 0,
        },
    };
end