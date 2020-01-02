function GetChaosRebelArmyArchetypesPoolDataResources()
    return {
        ChaosLord = {
            AgentSubtypes = {"chs_lord", },
            UnitTags = {"Marauders", "MarauderHorsemen", "ChaosWarriors", "Beasts", },
            Weighting = 4,
        },
        ChaosSorcerorLord = {
            AgentSubtypes = {"chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
            UnitTags = { "Marauders", "MarauderHorsemen", "ChaosWarriors", "Beasts", },
            Weighting = 1,
        },
    };
end