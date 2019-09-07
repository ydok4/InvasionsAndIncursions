function GetGreenskinRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_grn_greenskins = {
            DrakwaldGoblins = {
                AgentSubtypes = {
                    grn_goblin_great_shaman = {
                        AgentSubtypeKey = "grn_goblin_great_shaman",
                        AgentSubTypeMount = "wh_main_anc_mount_grn_goblin_great_shaman_giant_wolf",
                        MinimumLevel = 8,
                    },
                },
                MandatoryUnits = {
                    wh_main_grn_mon_arachnarok_spider_0 = 1,
                },
                UnitTags = {"Goblins", "ForestGoblins", },
                Weighting = 0,
            },
            NightGoblinWarboss = {
                AgentSubtypes = {"dlc06_grn_night_goblin_warboss", },
                UnitTags = {"Goblins", "NightGoblins", "Squigs", },
                Weighting = 2,
            },
            GoblinWolfRiderz = {
                AgentSubtypes = {
                    grn_goblin_great_shaman = {
                        AgentSubtypeKey = "grn_goblin_great_shaman",
                        AgentSubTypeMount = "wh_main_anc_mount_grn_goblin_great_shaman_giant_wolf",
                        MinimumLevel = 9,
                    },
                },
                MandatoryUnits = {
                    wh_main_grn_cav_goblin_wolf_riders_0 = 2,
                    wh_main_grn_cav_goblin_wolf_riders_1 = 1,
                },
                UnitTags = {"Goblins", "GoblinWolfRiders", },
                Weighting = 0,
            },
            GoblinGreatShaman = {
                AgentSubtypes = {"grn_goblin_great_shaman", },
                UnitTags = {"Goblins", "ForestGoblins", "Artillery", },
                Weighting = 2,
            },
            OrcBoarBoyz = {
                AgentSubtypes = {
                    grn_orc_warboss = {
                        AgentSubtypeKey = "grn_orc_warboss",
                        AgentSubTypeMount = "wh_main_anc_mount_grn_orc_warboss_war_boar",
                        MinimumLevel = 8,
                    },
                },
                MandatoryUnits = {
                    wh_main_grn_cav_orc_boar_boyz = 2,
                    wh_main_grn_cav_orc_boar_boy_big_uns = 1,
                },
                UnitTags = {"Orcs", "OrcBoarBoyz", },
                Weighting = 0,
            },
            OrcWarboss = {
                AgentSubtypes = {"grn_orc_warboss", },
                UnitTags = {"Goblins", "Orcs", "Monsters", },
                Weighting = 3,
            },
        },
    };
end