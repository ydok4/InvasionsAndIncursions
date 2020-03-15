function GetLizardmenRebelArmyArchetypesPoolDataResources()
    return {
        Saurus = {
            AgentSubtypes = {"wh2_main_lzd_saurus_old_blood", },
            UnitTags = {"Skinks", "Saurus", "ColdOnes", "FeralBeasts", },
            Weighting = 4,
        },
        Skinks = {
            AgentSubtypes = {"wh2_dlc12_lzd_red_crested_skink_chief", },
            MandatoryUnits = {
                wh2_dlc12_lzd_inf_skink_red_crested_0 = 2,
                wh2_main_lzd_mon_kroxigors = 1,
            },
            UnitTags = {"Skinks", "FeralBeasts", },
            Weighting = 1,
        },

        MazdamundiReemerge = {
            RebellionFaction = "wh2_main_lzd_hexoatl",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                wh2_main_lzd_lord_mazdamundi = {
                    AgentSubtypeKey = "wh2_main_lzd_lord_mazdamundi",
                },
            },
            MandatoryUnits = {
                wh2_main_lzd_inf_temple_guards = 2,
                wh2_main_lzd_mon_kroxigors = 1,
                wh2_main_lzd_mon_ancient_stegadon = 1,
            },
            UnitTags = {"Saurus", "ColdOnes", "TamedBeasts", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh2_main_isthmus_of_lustria_hexoatl", },
                wh2_main_great_vortex = { "wh2_main_vor_isthmus_of_lustria_hexoatl", },
            },
        },
    };
end