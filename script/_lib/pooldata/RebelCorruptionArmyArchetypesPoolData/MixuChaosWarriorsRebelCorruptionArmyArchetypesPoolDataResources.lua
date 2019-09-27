function GetMixuChaosWarriorsRebelCorruptionArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_chs_chaos_corruption = {
            DragonOgreChampionMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"chs_shaggoth_champion", },
                MandatoryUnits = {
                    wh_dlc01_chs_mon_dragon_ogre = 1,
                },
                UnitTags = {"ChaosWarriors", "Beasts", },
                ArmySize = 15,
                Weighting = 1,
            },
            DragonOgreChampionHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"chs_shaggoth_champion", },
                MandatoryUnits = {
                    wh_dlc01_chs_mon_dragon_ogre = 1,
                    wh_dlc01_chs_mon_dragon_ogre_shaggoth = 1,
                },
                UnitTags = {"ChaosWarriors", "Beasts", },
                ArmySize = 20,
                Weighting = 1,
            },
        },
    };
end