function GetDarkElfRebelArmyArchetypesPoolDataResources()
    return {
        DreadLord = {
            AgentSubtypes = {"wh2_main_def_dreadlord", "wh2_main_def_dreadlord_fem", },
            UnitTags = {"Warriors", { "Cavalry", "ColdOnes", }, },
            Weighting = 4,
        },
        DreadLordSpecial = {
            AgentSubtypes = {"wh2_main_def_dreadlord", "wh2_main_def_dreadlord_fem", },
            UnitTags = {"Warriors", { "Cavalry", "ColdOnes", }, { "Khainite", "Shades", }, },
            Weighting = 1,
        },
        Beastmaster = {
            AgentSubtypes = {"wh2_dlc14_def_high_beastmaster", },
            MandatoryUnits = {
                wh2_main_def_inf_harpies = 2,
                { wh2_dlc10_def_mon_feral_manticore_0 = 1, wh2_dlc14_def_cav_scourgerunner_chariot_0 = 1 },
            },
            UnitTags = {"Warriors", "Beasts", },
            Weighting = 1,
        },
        Corsairs = {
            AgentSubtypes = {"wh2_main_def_dreadlord", "wh2_main_def_dreadlord_fem", },
            MandatoryUnits = {
                wh2_main_def_inf_black_ark_corsairs_0 = 2,
                wh2_main_def_inf_black_ark_corsairs_1 = 1,
            },
            UnitTags = {"Corsairs", "Warriors", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
    };
end