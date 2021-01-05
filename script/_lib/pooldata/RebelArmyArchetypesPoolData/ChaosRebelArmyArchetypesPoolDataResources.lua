function GetChaosRebelArmyArchetypesPoolDataResources()
    return {
        ChaosLordSea = {
            AgentSubtypes = {"chs_lord", },
            MandatoryUnits = {
                wh_dlc06_chs_feral_manticore = 2,
            },
            UnitTags = {"Marauders", "ChaosWarriors", "Beasts", },
            Weighting = 0,
            CanSpawnOnSea = true,
        },
        ChaosLord = {
            AgentSubtypes = {"chs_lord", },
            UnitTags = {"Marauders", "MarauderHorsemen", "ChaosWarriors", "Beasts", },
            Weighting = 5,
        },
        ChaosLordWarriorsInvasionStage2 = {
            AgentSubtypes = {"chs_lord", },
            MandatoryUnits = {
                wh_main_chs_cav_chaos_knights_0 = 1,
            },
            UnitTags = {"ChaosWarriors", "Chosen", "ChaosCavalry", },
            Weighting = 0,
        },
        ChaosLordMonstersInvasionStage2 = {
            AgentSubtypes = {"chs_lord", },
            MandatoryUnits = {
                wh_dlc01_chs_mon_dragon_ogre_shaggoth = 1,
            },
            UnitTags = {"ChaosWarriors", "Chosen", "Monsters", },
            Weighting = 0,
        },
        ChaosSorcerorLordInvasionStage1 = {
            AgentSubtypes = {"chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
            MandatoryUnits = {
                wh_main_chs_mon_chaos_spawn = 1,
                wh_dlc01_chs_inf_forsaken_0 = 3,
            },
            UnitTags = { "ChaosWarriors", "Monsters", },
            Weighting = 0,
        },
        ChaosSorcerorLord = {
            AgentSubtypes = {"chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
            MandatoryUnits = {
                wh_dlc01_chs_inf_forsaken_0 = 2,
            },
            UnitTags = { "Marauders", "MarauderHorsemen", "ChaosWarriors", "Beasts", },
            Weighting = 1,
        },
    };
end