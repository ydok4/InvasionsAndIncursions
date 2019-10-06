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
                Weighting = 4,
            },
            GreySeerDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = { "wh2_main_skv_grey_seer_plague", "wh2_main_skv_grey_seer_ruin", },
                MandatoryUnits = {
                    wh2_main_skv_mon_rat_ogres = 1,
                },
                UnitTags = {"Warriors", "SkavenSlaves", },
                Weighting = 1,
            },
            -- Low clan data
            ClanEshinLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_inf_gutter_runners_0 = 1,
                    wh2_main_skv_inf_gutter_runner_slingers_1 = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanEshin", },
                ArmySize = 13,
                Weighting = 1,
            },
            ClanMoulderLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_mon_rat_ogres = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanMoulder", },
                ArmySize = 13,
                Weighting = 1,
            },
            ClanSkryreLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"wh2_main_skv_warlord",  "wh2_dlc12_skv_warlock_master", },
                MandatoryUnits = {
                    wh2_main_skv_inf_warpfire_thrower = 1,
                    wh2_main_skv_inf_poison_wind_globadiers = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanSkyre",},
                ArmySize = 13,
                Weighting = 1,
            },
            StormVerminLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"wh2_main_skv_warlord", "wh2_main_skv_grey_seer_plague", "wh2_main_skv_grey_seer_ruin", },
                MandatoryUnits = {
                    wh2_main_skv_inf_stormvermin_0 = 2,
                    wh2_main_skv_inf_stormvermin_1 = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", },
                ArmySize = 13,
                Weighting = 1,
            },
            ClanPestilensLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_inf_plague_monks = 2,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanPestilens"},
                ArmySize = 13,
                Weighting = 1,
            },
            -- Medium clan data
            ClanEshinMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_inf_gutter_runners_1 = 1,
                    wh2_main_skv_inf_gutter_runner_slingers_1 = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanEshin", },
                ArmySize = 15,
                Weighting = 1,
            },
            ClanMoulderMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_mon_rat_ogres = 2,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanMoulder", },
                ArmySize = 15,
                Weighting = 1,
            },
            ClanSkryreMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"wh2_main_skv_warlord",  "wh2_dlc12_skv_warlock_master", },
                MandatoryUnits = {
                    wh2_main_skv_inf_warpfire_thrower = 1,
                    wh2_main_skv_inf_poison_wind_globadiers = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanSkyre",},
                ArmySize = 15,
                Weighting = 1,
            },
            ClanPestilensMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_inf_plague_monks = 2,
                    wh2_main_skv_art_plagueclaw_catapult = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanPestilens"},
                ArmySize = 15,
                Weighting = 1,
            },
            -- High clan data
            ClanEshinHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_inf_death_runners_0 = 1,
                    wh2_main_skv_inf_gutter_runners_1 = 1,
                    wh2_main_skv_inf_gutter_runner_slingers_1 = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanEshin", },
                ArmySize = 20,
                Weighting = 1,
            },
            ClanMoulderHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_mon_hell_pit_abomination = 1,
                    wh2_main_skv_mon_rat_ogres = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanMoulder", },
                ArmySize = 20,
                Weighting = 1,
            },
            ClanSkryreHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_main_skv_warlord",  "wh2_dlc12_skv_warlock_master", },
                MandatoryUnits = {
                    { wh2_dlc12_skv_inf_ratling_gun_0 = 1, wh2_dlc12_skv_inf_warplock_jezzails_0 = 1 },
                    { wh2_main_skv_art_warp_lightning_cannon = 1, wh2_main_skv_veh_doomwheel = 1 },
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanSkyre",},
                ArmySize = 20,
                Weighting = 1,
            },
            ClanPestilensHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_main_skv_warlord", },
                MandatoryUnits = {
                    wh2_main_skv_inf_plague_monks = 2,
                    wh2_main_skv_inf_plague_monk_censer_bearer = 1,
                    wh2_main_skv_art_plagueclaw_catapult = 1,
                },
                UnitTags = {"SkavenSlaves", "Warriors", "ClanPestilens"},
                ArmySize = 20,
                Weighting = 1,
            },
        },
    };
end