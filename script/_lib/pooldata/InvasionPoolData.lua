InvasionPoolData = {
    EarlyNorscaInvasion = {
        GrantTerritoryTo = nil,
        SubcultureKey = "wh_main_sc_nor_norsca",
        FactionLeaderIsForceCommander = false,
        EmergeData = {
            TurnNumbers = {
                Minimum = 30,
                Maximum = 59,
            },
            RAMData = {
                MainForce = {
                    Key = "EarlyNorscaInvasion_Main",
                    MandatoryUnits = {
                        wh_dlc08_nor_inf_marauder_champions_1 = 1,
                        wh_dlc08_nor_mon_norscan_giant_0 = 1,
                    },
                    UnitTags = {"Warriors", "Horsemen", {"SkinWolves", "Trolls"}, },
                    ArmySize = 15,
                    XPLevel = 12,
                    SkillsToUnlock = {
                    },
                },
                SecondForce = {
                    Key = "EarlyNorscaInvasion_Second",
                    MandatoryUnits = nil,
                    UnitTags = {"Warriors", "Horsemen", "WarBeasts", },
                    ArmySize = 12,
                    XPLevel = 8,
                    SkillsToUnlock = {
                    },
                },
                ThirdForce = {
                    Key = "EarlyNorscaInvasion_Third",
                    MandatoryUnits = nil,
                    UnitTags = {"Warriors", "Horsemen", },
                    ArmySize = 10,
                    XPLevel = 5,
                    SkillsToUnlock = {
                    },
                },
            },
            IMData = {
                Target = {
                    wh_main_sc_brt_bretonnia = {
                        Type = "REGION",
                        FactionKey = "wh_main_nor_skaeling",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh_main_couronne_et_languille_couronne", "wh_main_couronne_et_languille_languille", "wh_main_forest_of_arden_castle_artois",
                                "wh_main_lyonesse_lyonesse", "wh_main_lyonesse_mousillon", "wh_main_bordeleaux_et_aquitaine_bordeleaux", "wh_main_carcassone_et_brionne_brionne",
                                "wh_main_carcassone_et_brionne_castle_carcassonne",
                                },
                                SpawnCoordinates = {
                                    {131, 266}, {158, 245}, {107, 299},
                                },
                            },
                        },
                    },
                    wh2_main_sc_hef_high_elves = {
                        Type = "REGION",
                        FactionKey = "wh2_main_nor_aghol",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh2_main_cothique_mistnar", "wh2_main_cothique_tor_koruali", "wh2_main_chrace_elisia", "wh2_main_chrace_tor_achare", },
                                SpawnCoordinates = {
                                    {266, 513}, {300, 515}, {350, 535},
                                },
                            },
                            wh2_main_great_vortex = {
                                Regions = {"wh2_main_vor_cothique_mistnar", "wh2_main_vor_cothique_tor_koruali", "wh2_main_vor_chrace_elisia", "wh2_main_vor_chrace_tor_achare", },
                                SpawnCoordinates = {
                                    {600, 675}, {620, 660}, {640, 670},
                                },
                            },
                        },
                    },
                    wh2_main_sc_def_dark_elves = {
                        Type = "REGION",
                        FactionKey = "wh2_main_nor_mung",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh2_main_iron_mountains_naggarond", "wh2_main_vor_naggarond_har_kaldra", "wh2_main_the_road_of_skulls_har_ganeth", "wh2_main_the_road_of_skulls_the_black_pillar", },
                                SpawnCoordinates = {
                                    {30, 710}, {90, 710}, {145, 705},
                                },
                            },
                            wh2_main_great_vortex = {
                                Regions = {"wh2_main_vor_naggarond_naggarond", "wh2_main_vor_naggarond_kaelra", "wh2_main_vor_the_road_of_skulls_har_ganeth", "wh2_main_vor_the_road_of_skulls_the_black_pillar", },
                                SpawnCoordinates = {
                                    {250, 715}, {290, 715}, {615, 715},
                                },
                            },
                        },
                    },
                    wh_main_sc_emp_empire = {
                        Type = "REGION",
                        FactionKey = "wh_main_nor_skaeling",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh_main_nordland_dietershafen", "wh_main_ostland_norden", },
                                SpawnCoordinates = {
                                    {460, 590}, {505, 600}, {615, 626},
                                },
                            },
                        },
                    },
                },
            }
        }
    },
}