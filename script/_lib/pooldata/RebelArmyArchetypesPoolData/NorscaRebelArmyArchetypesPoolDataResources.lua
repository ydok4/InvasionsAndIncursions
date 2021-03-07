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
    };
end