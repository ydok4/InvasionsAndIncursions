function GetTombKingsRebelArmyArchetypesPoolDataResources()
    return {
        NewlyAwakenedTombKing = {
            AgentSubtypes = {"wh2_dlc09_tmb_tomb_king", },
            UnitTags = {"SkeletonWarriors", },
            Weighting = 4,
        },
        TombKing = {
            AgentSubtypes = {"wh2_dlc09_tmb_tomb_king", },
            MandatoryUnits = {
                wh2_dlc09_tmb_inf_tomb_guard_0 = 1,
            },
            UnitTags = {"SkeletonWarriors", "SkeletonCavalry", },
            Weighting = 1,
        },
        SettraReemerge = {
            RebellionFaction = "wh2_dlc09_tmb_khemri",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                wh2_dlc09_tmb_settra = {
                    AgentSubtypeKey = "wh2_dlc09_tmb_settra",
                },
            },
            MandatoryUnits = {
                wh2_dlc09_tmb_mon_ushabti_0 = 2,
                wh2_dlc09_tmb_mon_ushabti_1 = 1,
                wh2_dlc09_tmb_art_screaming_skull_catapult_0 = 2,
                wh2_dlc09_tmb_veh_khemrian_warsphinx_0 = 1,
            },
            UnitTags = { "TombGuard", "SkeletonCavalry", "ConstructMonsters", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh2_main_land_of_the_dead_khemri", },
                wh2_main_great_vortex = { "wh2_main_vor_land_of_the_dead_khemri", },
            },
        },
    };
end