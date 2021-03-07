function GetMixuNorscaRebelArmyArchetypesPoolDataResources()
    return {
        ShamanLord = {
            AgentSubtypes = {"nor_shaman_sorcerer_lord_death", "nor_shaman_sorcerer_lord_fire", "nor_shaman_sorcerer_lord_metal",  },
            UnitTags = {"Warriors", "WarBeasts", "Horsemen" },
            Weighting = 2,
        },
        FimirWarlord = {
            AgentSubtypes = {"nor_fimir_warlord",  },
            UnitTags = {"FimirExclusive", "WarBeasts", },
            Weighting = 0,
        },
    };
end