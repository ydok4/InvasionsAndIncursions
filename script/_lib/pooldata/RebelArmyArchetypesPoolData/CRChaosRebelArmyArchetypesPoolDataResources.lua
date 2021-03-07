function GetCRChaosRebelArmyArchetypesPoolDataResources()
    return {
        ChaosSorcerorLordDaemons = {
            AgentSubtypes = {"chs_sorcerer_lord_death", "chs_sorcerer_lord_fire", "chs_sorcerer_lord_metal", "dlc07_chs_sorcerer_lord_shadow", },
            MandatoryUnits = {
                wh_main_chs_mon_chaos_spawn = 1,
                wh_dlc01_chs_inf_forsaken_0 = 3,
            },
            UnitTags = { "ChaosWarriors", "Beasts", "Daemons" },
            Weighting = 1,
        },
    };
end