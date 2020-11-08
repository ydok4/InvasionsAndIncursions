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
            UnitTags = {"Corsairs", "Warriors", "Beasts", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        BlackArk = {
            AgentSubtypes = {"wh2_main_def_dreadlord", "wh2_main_def_dreadlord_fem", },
            MandatoryUnits = {
                wh2_main_def_inf_black_ark_corsairs_0 = 2,
                wh2_main_def_inf_black_ark_corsairs_1 = 1,
            },
            UnitTags = {"Corsairs", "Warriors", "Beasts", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        MalekithReemerge = {
            RebellionFaction = "wh2_main_def_naggarond",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                wh2_main_def_malekith = {
                    AgentSubtypeKey = "wh2_main_def_malekith",
                },
            },
            MandatoryUnits = {
                wh2_main_def_inf_black_guard_0 = 2,
                wh2_main_def_mon_black_dragon = 1,
            },
            UnitTags = {"Warriors", { "Cavalry", "ColdOnes", }, { "Khainite", "Shades", }, },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh2_main_iron_mountains_naggarond", },
                wh2_main_great_vortex = { "wh2_main_vor_naggarond_naggarond", },
            },
        },
    };
end