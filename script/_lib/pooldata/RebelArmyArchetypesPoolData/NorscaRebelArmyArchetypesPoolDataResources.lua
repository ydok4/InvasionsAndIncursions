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
            },
            UnitTags = {"Warriors", "Horsemen", "WarBeasts", },
            Weighting = 0,
            CanSpawnOnSea = false,
        },
    };
end