function GetMixuNorscaRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_nor_norsca = {
            FimirWarlord = {
                AgentSubtypes = {"nor_fimir_warlord",  },
                UnitTags = {"FimirExclusive", "WarBeasts", },
                Weighting = 1,
            },
            FimirShamanLord = {
                AgentSubtypes = {"nor_shaman_sorcerer_lord_death", "nor_shaman_sorcerer_lord_fire", "nor_shaman_sorcerer_lord_metal", },
                UnitTags = {"FimirExclusive", "WarBeasts", },
                Weighting = 1,
            },
        },
    };
end