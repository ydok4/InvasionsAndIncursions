function GetVampireCoastRebelCorruptionArmyArchetypesPoolDataResources() 
    return {
        wh2_dlc11_sc_cst_vampire_coast_corruption = {
            VampireCoastDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
                MandatoryUnits = {
                    wh2_dlc11_cst_inf_depth_guard_0 = 2,
                },
                UnitTags = {"Zombies", "Artillery", },
                ArmySize = 13,
                Weighting = 3,
                CanSpawnOnSea = true,
            },
        },
    };
end