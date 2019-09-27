function GetSkavenRebelArmyArchetypesPoolDataResources()
    return {
        wh2_main_sc_skv_skaven = {
            SkavenWarlord = {
                AgentSubtypes = {"wh2_main_skv_warlord", },
                UnitTags = {"SkavenSlaves", "Warriors", },
                Weighting = 5,
            },
            SkavenSlaves = {
                AgentSubtypes = {"wh2_main_skv_warlord", },
                UnitTags = {"SkavenSlaves", },
                Weighting = 2,
            },
            ClanEshin = {
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_inf_death_runners_0 = 1,
                    wh2_main_skv_inf_gutter_runners_1 = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanEshin", },
                Weighting = 0,
            },
            ClanMoulder = {
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_mon_rat_ogres = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanMoulder", },
                Weighting = 0,
            },
            ClanSkryre = {
                AgentSubtypes = {"wh2_main_skv_warlord",  "wh2_dlc12_skv_warlock_master", },
                MandatoryUnits = {
                    wh2_main_skv_inf_warpfire_thrower = 1,
                    wh2_main_skv_inf_poison_wind_globadiers = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanSkyre",},
                Weighting = 0,
            },
            StormVermin = {
                AgentSubtypes = {"wh2_main_skv_warlord", "wh2_main_skv_grey_seer_plague", "wh2_main_skv_grey_seer_ruin", },
                MandatoryUnits = {
                    wh2_main_skv_inf_stormvermin_0 = 2,
                    wh2_main_skv_inf_stormvermin_1 = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", },
                Weighting = 0,
            },
            ClanPestilens = {
                AgentSubtypes = {"wh2_main_skv_warlord", },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanPestilens"},
                Weighting = 0,
            },
        },
    };
end