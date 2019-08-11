function GetChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources() 
    return {
        wh_main_sc_chs_chaos_corruption = {
            ChaosLordDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = {"chs_lord", },
                MandatoryUnits = {
                    wh_dlc06_chs_feral_manticore = 1,
                },
                UnitTags = {"Marauders", "ChaosWarriors", "Beasts", },
                ArmySize = 13,
                Weighting = 3,
            },
            ChaosLordLow = {
                CorruptionThreshold = 15,
                AgentSubtypes = {"chs_lord", },
                MandatoryUnits = {
                    wh_main_chs_inf_chosen_0 = 1,
                    wh_dlc06_chs_feral_manticore = 1,
                },
                UnitTags = {"Marauders", "ChaosWarriors", "Beasts", },
                ArmySize = 13,
                Weighting = 3,
            },
            ChaosLordMedium = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"chs_lord", },
                MandatoryUnits = {
                    wh_main_chs_cav_chaos_knights_0 = 1,
                    wh_main_chs_inf_chosen_0 = 1,
                },
                UnitTags = {"Marauders", "ChaosWarriors", "Beasts", },
                ArmySize = 17,
                Weighting = 3,
            },
            ChaosLordHigh = {
                CorruptionThreshold = 45,
                AgentSubtypes = {"chs_lord", },
                MandatoryUnits = {
                    wh_main_chs_inf_chosen_1 = 1,
                    wh_dlc01_chs_mon_dragon_ogre_shaggoth = 1,
                },
                UnitTags = {"Marauders", "ChaosWarriors", "Beasts", },
                ArmySize = 20,
                Weighting = 3,
            },
        },
    };
end