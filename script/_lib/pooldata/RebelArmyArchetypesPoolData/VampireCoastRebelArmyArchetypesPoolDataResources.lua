function GetVampireCoastRebelArmyArchetypesPoolDataResources()
    return {
        VampireAdmiral = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            Weighting = 3,
            CanSpawnOnSea = true,
        },
        VampireAdmiralGhostsInvasionStage1 = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_inf_syreens = 2,
                wh2_dlc11_cst_cav_questing_knights_recruited = 1,
                wh2_dlc11_cst_cav_knights_of_the_realm_recruited = 2,
                wh2_dlc11_cst_cav_knights_errant_recruited = 3,
            },
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        VampireAdmiralInvasionStage1 = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_mon_rotting_leviathan_0 = 1,
                wh2_dlc11_cst_mon_rotting_prometheans_0 = 1,
            },
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        VampireAdmiralInvasionStage2 = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_mon_necrofex_colossus_0 = 1,
                wh2_dlc11_cst_inf_depth_guard_0 = 3,
                wh2_dlc11_cst_inf_depth_guard_1 = 2,
            },
            UnitTags = { "Zombies", "DepthGuard", "Artillery", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        VampireAdmiralMonstersInvasionStage2 = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_mon_terrorgheist = 1,
                wh2_dlc11_cst_mon_animated_hulks_0 = 3,
                wh2_dlc11_cst_mon_mournguls_0 = 2,
            },
            UnitTags = { "Zombies", "Beasts", "Monsters", "Artillery", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        VampireAdmiralSeaBeastsInvasionStage2 = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_mon_rotting_leviathan_0 = 1,
                wh2_dlc11_cst_mon_rotting_prometheans_0 = 2,
                wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 = 2,
            },
            UnitTags = { "Zombies", "Beasts", "Artillery", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        CountNoctilusReemerge = {
            RebellionFaction = "wh2_dlc11_cst_noctilus",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                wh2_dlc11_cst_noctilus = {
                    AgentSubtypeKey = "wh2_dlc11_cst_noctilus",
                },
            },
            MandatoryUnits = {
                wh2_dlc11_cst_mon_necrofex_colossus_0 = 1,
            },
            UnitTags = {"Zombies", "DepthGuard", "Beasts", "Artillery", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = {"wh2_main_the_galleons_graveyard", },
                wh2_main_great_vortex = { "wh2_main_vor_the_galleons_graveyard", },
            },
        },
    };
end