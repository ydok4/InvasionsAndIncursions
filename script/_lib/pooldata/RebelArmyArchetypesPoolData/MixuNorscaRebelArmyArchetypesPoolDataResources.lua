function GetMixuNorscaRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_nor_norsca = {
            ShamanLord = {
                AgentSubtypes = {"nor_shaman_sorcerer_lord_death", "nor_shaman_sorcerer_lord_fire", "nor_shaman_sorcerer_lord_metal",  },
                UnitTags = {"Warriors", "WarBeasts", "Horsemen" },
                Weighting = 3,
            },
            FimirWarlord = {
                AgentSubtypes = {"nor_fimir_warlord",  },
                UnitTags = {"FimirExclusive", "WarBeasts", },
                Weighting = 0,
            },
            FimirShamanLord = {
                AgentSubtypes = {"nor_shaman_sorcerer_lord_death", "nor_shaman_sorcerer_lord_fire", "nor_shaman_sorcerer_lord_metal", },
                UnitTags = {"FimirExclusive", "WarBeasts", },
                Weighting = 0,
            },
        },
    };
end