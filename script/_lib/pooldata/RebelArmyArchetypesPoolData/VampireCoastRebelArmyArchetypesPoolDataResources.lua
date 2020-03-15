function GetVampireCoastRebelArmyArchetypesPoolDataResources()
    return {
        VampireAdmiral = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            Weighting = 3,
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