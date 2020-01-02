function GetVampireCoastRebelCorruptionArmyArchetypesPoolDataResources()
    return {
        VampireCoastDefault = {
            CorruptionThreshold = 0,
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            ArmySize = 10,
            Weighting = 3,
            CanSpawnOnSea = true,
        },
        VampireCoastDepthGuard = {
            CorruptionThreshold = 30,
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_inf_depth_guard_0 = 1,
            },
            UnitTags = {"Zombies", "DepthGuard", "Beasts", "Artillery", },
            ArmySize = 15,
            Weighting = 3,
            CanSpawnOnSea = true,
        },
        VampireCoastNecrofexColossus = {
            CorruptionThreshold = 75,
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_mon_necrofex_colossus_0 = 1,
            },
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            ArmySize = 17,
            Weighting = 1,
            CanSpawnOnSea = true,
        },
        VampireCoastTerrorgeist = {
            CorruptionThreshold = 75,
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_mon_terrorgheist = 1,
            },
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            ArmySize = 17,
            Weighting = 1,
            CanSpawnOnSea = true,
        },
    };
end