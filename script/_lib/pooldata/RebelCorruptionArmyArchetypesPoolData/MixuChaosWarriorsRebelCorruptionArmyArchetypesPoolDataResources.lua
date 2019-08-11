function GetMixuChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_chs_chaos_corruption = {
            DragonOgreChampionLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"chs_shaggoth_champion", },
                MandatoryUnits = {
                    wh_dlc01_chs_mon_dragon_ogre = 1,
                },
                UnitTags = {"ChaosWarriors", "Beasts", },
                ArmySize = 13,
                Weighting = 3,
            },
            DragonOgreChampionMedium = {
                CorruptionThreshold = 45,
                AgentSubtypes = {"chs_shaggoth_champion", },
                MandatoryUnits = {
                    wh_dlc01_chs_mon_dragon_ogre = 1,
                },
                UnitTags = {"ChaosWarriors", "Beasts", },
                ArmySize = 17,
                Weighting = 3,
            },
            DragonOgreChampionHigh = {
                CorruptionThreshold = 60,
                AgentSubtypes = {"chs_shaggoth_champion", },
                MandatoryUnits = {
                    wh_dlc01_chs_mon_dragon_ogre = 2,
                    wh_dlc01_chs_mon_dragon_ogre_shaggoth = 1,
                },
                UnitTags = {"ChaosWarriors", "Beasts", },
                ArmySize = 20,
                Weighting = 3,
            },
        },
    };
end