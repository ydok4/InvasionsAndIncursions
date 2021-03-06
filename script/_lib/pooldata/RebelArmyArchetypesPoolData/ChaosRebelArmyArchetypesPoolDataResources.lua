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