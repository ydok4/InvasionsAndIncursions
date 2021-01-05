function GetNorscaRebelArmyArchetypesPoolDataResources()
    return {
        ChieftainStandardArmy = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            UnitTags = {"Warriors", "Horsemen", "WarBeasts", },
            Weighting = 2,
            CanSpawnOnSea = false,
        },
        ChieftainSeaRaiders = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            UnitTags = {"Warriors", },
            Weighting = 4,
            CanSpawnOnSea = true,
        },
        ChieftainChaosInvasionStage1 = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            MandatoryUnits = {
                wh_dlc08_nor_mon_war_mammoth_0 = 1,
                wh_dlc08_nor_inf_marauder_berserkers_0 = 2,
                wh_dlc08_nor_inf_marauder_champions_0 = 1,
            },
            UnitTags = {"Warriors", "Horsemen", "WarBeasts", },
            Weighting = 0,
            CanSpawnOnSea = false,
        },
        ChieftainHorsemenChaosInvasionStage1 = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            MandatoryUnits = {
                wh_dlc08_nor_cav_marauder_horsemasters_0 = 2,
                wh_main_nor_mon_chaos_warhounds_0 = 2,
                wh_main_nor_mon_chaos_warhounds_1 = 1,
            },
            UnitTags = {"Horsemen", "Trolls", },
            Weighting = 0,
            CanSpawnOnSea = false,
        },
        ChieftainChaosInvasionStage2 = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            MandatoryUnits = {
                wh_dlc08_nor_mon_war_mammoth_1 = 1,
                wh_dlc08_nor_inf_marauder_berserkers_0 = 3,
                wh_dlc08_nor_inf_marauder_champions_0 = 2,
                wh_dlc08_nor_inf_marauder_champions_1 = 1,
            },
            UnitTags = {"Warriors", "Horsemen", "WarBeasts", },
            Weighting = 0,
            CanSpawnOnSea = false,
        },
        ChieftainHorsemenChaosInvasionStage2 = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            MandatoryUnits = {
                wh_dlc08_nor_cav_marauder_horsemasters_0 = 3,
                wh_main_nor_cav_chaos_chariot = 1,
                wh_main_nor_mon_chaos_warhounds_1 = 2,
            },
            UnitTags = {"Horsemen", "Trolls", },
            Weighting = 0,
            CanSpawnOnSea = false,
        },
    };
end