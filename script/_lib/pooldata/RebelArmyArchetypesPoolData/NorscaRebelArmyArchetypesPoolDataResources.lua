function GetNorscaRebelArmyArchetypesPoolDataResources()
    return {
        ChieftainStandardArmy = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            UnitTags = {"Warriors", "Horsemen", "WarBeasts", },
            Weighting = 1,
            CanSpawnOnSea = false,
        },
        ChieftainSeaRaiders = {
            AgentSubtypes = {"nor_marauder_chieftain",  },
            UnitTags = {"Warriors", },
            Weighting = 3,
            CanSpawnOnSea = true,
        },
    };
end