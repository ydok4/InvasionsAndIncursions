function GetSkavenRebelCorruptionArmyArchetypesPoolDataResources() 
    return {
        wh2_main_sc_skv_skaven_corruption = {
            WarlordDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_mon_rat_ogres = 1,
                },
                UnitTags = {"Warriors", "SkavenSlaves", },
                ArmySize = 13,
                Weighting = 3,
            },
        },
    };
end