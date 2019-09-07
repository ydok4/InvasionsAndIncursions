function GetDarkElfRebelArmyArchetypesPoolDataResources()
    return {
        wh2_main_sc_def_dark_elves = {
            DreadLord = {
                AgentSubtypes = {"wh2_main_def_dreadlord", "wh2_main_def_dreadlord_fem", },
                UnitTags = {"Warriors", "Cavalry", },
                Weighting = 3,
            },
            Corsairs = {
                AgentSubtypes = {"wh2_main_def_dreadlord", "wh2_main_def_dreadlord_fem", },
                MandatoryUnits = {
                    wh2_main_def_inf_black_ark_corsairs_0 = 2,
                    wh2_main_def_inf_black_ark_corsairs_1 = 1,
                },
                UnitTags = {"Corsairs", "Warriors", },
                Weighting = 1,
                CanSpawnOnSea = false,
            },
        },
    };
end