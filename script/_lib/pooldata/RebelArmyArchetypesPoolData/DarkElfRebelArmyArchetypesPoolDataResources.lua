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
                UnitTags = {"Corsairs", "Warriors", },
                Weighting = 1,
                CanSpawnOnSea = false,
            },
        },
    };
end