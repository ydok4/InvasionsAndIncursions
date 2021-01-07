function GetAOVVampireCoastRebelArmyArchetypesPoolDataResources()
    return {
        VampireAdmiralGhostsInvasionStage1 = {
            AgentSubtypes = {"wh2_dlc11_cst_admiral_death", "wh2_dlc11_cst_admiral_deep", "wh2_dlc11_cst_admiral_fem_death", "wh2_dlc11_cst_admiral_fem_deep", "wh2_dlc11_cst_admiral", "wh2_dlc11_cst_admiral_fem",},
            MandatoryUnits = {
                wh2_dlc11_cst_inf_syreens = 2,
                wh2_dlc11_cst_cav_questing_knights_recruited = 1,
                wh2_dlc11_cst_cav_knights_of_the_realm_recruited = 2,
                wh2_dlc11_cst_cav_knights_errant_recruited = 3,
                wh2_dlc11_cst_mon_mournguls_0 = false,
                wh2_dlc11_cst_mon_animated_hulks_0 = false,
            },
            UnitTags = {"Zombies", "Beasts", "Artillery", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
    };
end