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
        ShamanLordMonstersChaosInvasionStage1 = {
            AgentSubtypes = {"nor_shaman_sorcerer_lord_death", "nor_shaman_sorcerer_lord_fire", "nor_shaman_sorcerer_lord_metal",  },
            MandatoryUnits = {
                wh_dlc08_nor_mon_norscan_giant_0 = 1,
            },
            UnitTags = {"Warriors", "WarBeasts", "Trolls" },
            Weighting = 0,
        },
        ShamanLordMonstersChaosInvasionStage2 = {
            AgentSubtypes = {"nor_shaman_sorcerer_lord_death", "nor_shaman_sorcerer_lord_fire", "nor_shaman_sorcerer_lord_metal",  },
            MandatoryUnits = {
                wh_dlc08_nor_mon_frost_wyrm_0 = 1,
            },
            UnitTags = {"Warriors", "WarBeasts", "Trolls" },
            Weighting = 0,
        },
        FimirWarlordChaosInvasionStage2 = {
            AgentSubtypes = {"nor_fimir_warlord",  },
            UnitTags = {"FimirExclusive", "WarBeasts", "SkinWolves", },
            Weighting = 0,
        },
    };
end