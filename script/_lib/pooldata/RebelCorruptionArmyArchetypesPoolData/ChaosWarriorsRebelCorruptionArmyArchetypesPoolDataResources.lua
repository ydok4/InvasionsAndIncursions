function GetChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources() 
    return {
        wh_main_sc_chs_chaos_corruption = {
            ChaosLordDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = {"chs_lord", },
                UnitTags = { "Marauders", "MarauderHorsemen", "ChaosWarriors", "Beasts", },
                ArmySize = 13,
                Weighting = 4,
            },
            ChaosSorcerorLordDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = {"chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
                UnitTags = { "Marauders", "MarauderHorsemen", "ChaosWarriors", "Beasts", },
                ArmySize = 13,
                Weighting = 2,
            },
            ChaosLordLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"chs_lord", },
                MandatoryUnits = {
                    wh_main_chs_inf_chosen_0 = 1,
                    wh_dlc06_chs_feral_manticore = 1,
                },
                UnitTags = { "Marauders", "ChaosWarriors", "Beasts", },
                ArmySize = 13,
                Weighting = 4,
            },
            ChaosSorcerorLordLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
                MandatoryUnits = {
                    wh_main_chs_inf_chosen_0 = 1,
                    wh_dlc06_chs_feral_manticore = 1,
                },
                UnitTags = { "Marauders", "ChaosWarriors", "Beasts", },
                ArmySize = 13,
                Weighting = 2,
            },
            ChaosLordMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"chs_lord", },
                MandatoryUnits = {
                    wh_main_chs_cav_chaos_knights_0 = 1,
                    wh_main_chs_inf_chosen_0 = 1,
                },
                UnitTags = { "Marauders", "ChaosWarriors", "ChaosCavalry", "Beasts", },
                ArmySize = 17,
                Weighting = 4,
            },
            ChaosSorcerorLordMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = { "chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
                MandatoryUnits = {
                    wh_main_chs_cav_chaos_knights_0 = 1,
                    wh_main_chs_inf_chosen_0 = 1,
                },
                UnitTags = { "Marauders", "ChaosWarriors", "ChaosCavalry", "Beasts", },
                ArmySize = 17,
                Weighting = 2,
            },
            ChaosLordHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"chs_lord", },
                MandatoryUnits = {
                    wh_main_chs_inf_chosen_1 = 1,
                    wh_dlc01_chs_mon_dragon_ogre_shaggoth = 1,
                },
                UnitTags = { "ChaosWarriors", "ChaosCavalry", "Beasts", },
                ArmySize = 20,
                Weighting = 4,
            },
            ChaosSorcerorLordHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
                MandatoryUnits = {
                    wh_main_chs_inf_chosen_1 = 1,
                    wh_dlc01_chs_mon_dragon_ogre_shaggoth = 1,
                },
                UnitTags = { "ChaosWarriors", "ChaosCavalry", "Beasts", },
                ArmySize = 20,
                Weighting = 2,
            },
        },
    };
end