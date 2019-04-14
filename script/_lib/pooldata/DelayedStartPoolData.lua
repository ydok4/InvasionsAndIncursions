DelayedStartPoolData = {
    -- Delayed Vampirates
    CylostraDirefan = {
        GrantTerritoryTo = {
            main_warhammer = "wh2_main_grn_blue_vipers",
            wh2_main_great_vortex = "wh2_main_def_ssildra_tor",
        },
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 1,
                Maximum = 1,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeOccurrence = nil,
        },
        RAMData = {
            PrimaryForce = {
                Key = "CylostraDirefan",
                IsFactionLeader = true,
                MandatoryUnits = {
                    wh2_dlc11_cst_inf_syreens = 2,
                    wh2_dlc11_cst_mon_mournguls_0 = 1,
                    wh2_dlc11_cst_art_carronade = 1,
                },
                UnitTags = {"Zombies", "Beasts", "DeckDroppers", },
                ArmySize = 19,
                XPLevel = 15,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = nil,
        },
        IMData = {
            AreaOverrideKey = "CylostraDirefan",
            FactionData = {
                SubcultureKey = "wh2_dlc11_sc_cst_vampire_coast",
                FactionKey = "wh2_dlc11_cst_the_drowned",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
                    main_warhammer = {
                        Regions = {"wh2_main_southern_jungle_of_pahualaxa_monument_of_the_moon"},
                        SpawnCoordinates = {"SeaOfSerpents",},
                    },
                    wh2_main_great_vortex = {
                        Regions = {"wh2_main_vor_grey_guardians_grey_rock_point"},
                        SpawnCoordinates = {"SeaOfSerpents",},
                    },
                },
            },
        },
        MMData = {

        },
    },
    -- Delayed Beastmen
    --[[Khazrak = {
        GrantTerritoryTo = nil,
        SubcultureKey = "wh_dlc03_sc_bst_beastmen",
        TurnNumbers = {
            Minimum = 100,
            Maximum = 140,
        },
        RAMData = {
            PrimaryForce = {
                Key = "Khazrak",
                FactionLeaderIsForceCommander = true,
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 2,
                    wh_dlc03_bst_inf_minotaurs_0 = 2,
                },
                UnitTags = {"Gors", "Minotaurs", "WarBeasts", },
                ArmySize = 19,
                XPLevel = 15,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = {
                SecondaryForce = {
                    Key = "SecondaryForce",
                    MandatoryUnits = {
    
                    },
                    UnitTags = {"Gors", "WarBeasts", },
                    ArmySize = 10,
                    XPLevel = 10,
                    SkillsToUnlock = {
                    },
                },
            },
        },
        IMData = {
            Target = {
                default = {
                    Type = "REGION",
                    FactionKey = "wh_dlc03_bst_beastmen",
                    TargetData = {
                        main_warhammer = {
                            Regions = {"wh_main_middenland_weismund", "wh_main_middenland_carroburg",},
                            SpawnCoordinates = {
                                {508, 550}, {501, 556},
                            },
                        },
                    },
                },
            },
        },
    },
    -- Delayed High Elves
    AlithAnar = {
        GrantTerritoryTo = {
            main_warhammer = "wh2_main_def_bleak_holds",
            wh2_main_great_vortex = "wh2_main_def_karond_kar",
        },
        SubcultureKey = "wh2_main_sc_hef_high_elves",
        TurnNumbers = {
            Minimum = 80,
            Maximum = 120,
        },
        RAMData = {
            PrimaryForce = {
                Key = "AlithAnar",
                FactionLeaderIsForceCommander = true,
                MandatoryUnits = {
                    wh2_dlc10_hef_inf_shadow_warriors_0 = 3,
                    wh2_dlc10_hef_inf_shadow_walkers_0 = 2,
                    wh2_main_hef_mon_great_eagle = 1,
                },
                UnitTags = {"ShadowWarriors", "Militia", },
                ArmySize = 19,
                XPLevel = 15,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = nil,
        },
        IMData = {
            Target = {
                default = {
                    Type = "REGION",
                    FactionKey = "wh2_main_hef_nagarythe",
                    TargetData = {
                        main_warhammer = {
                            Regions = {"wh2_main_the_black_coast_arnheim"},
                            SpawnCoordinates = {
                                {96, 392},
                            },
                        },
                        wh2_main_great_vortex = {
                            Regions = {"wh2_main_vor_the_broken_land_black_creek_spire"},
                            SpawnCoordinates = {
                                {350, 605},
                            },
                        },
                    },
                },
            },
        },
    },
    -- Delayed Dark Elves
    LokhirFellheart = {
        GrantTerritoryTo = {
            main_warhammer = "",
            wh2_main_great_vortex = "",
        },
        SubcultureKey = "wh2_main_sc_def_dark_elves",
        TurnNumbers = {
            Minimum = 100,
            Maximum = 200,
        },
        RAMData = {
            PrimaryForce = {
                Key = "LokhirFellheart",
                FactionLeaderIsForceCommander = true,
                MandatoryUnits = {
                    wh2_main_def_inf_black_ark_corsairs_0 = 2,
                    wh2_main_def_inf_black_ark_corsairs_1 = 2,
                    wh2_main_def_art_reaper_bolt_thrower = 1,
                },
                UnitTags = {"Warriors", "Corsairs", },
                ArmySize = 19,
                XPLevel = 15,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = nil,
        },
        IMData = {
            Target = {
                default = {
                    Type = "REGION",
                    FactionKey = "wh2_dlc11_def_the_blessed_dread",
                    TargetData = {
                        main_warhammer = {
                            Regions = {"wh2_main_headhunters_jungle_chupayotl"},
                            SpawnCoordinates = {
                                {250, 15},
                            },
                        },
                        wh2_main_great_vortex = {
                            Regions = {"wh2_main_vor_culchan_plains_chupayotl"},
                            SpawnCoordinates = {
                                {375, 15},
                            },
                        },
                    },
                },
            },
        },
    },
    -- Delayed Skaven
    LordSkrolk = {
        GrantTerritoryTo = {
            main_warhammer = "",
            wh2_main_great_vortex = "",
        },
        SubcultureKey = "wh2_main_sc_skv_skaven",
        TurnNumbers = {
            Minimum = 100,
            Maximum = 200,
        },
        RAMData = {
            PrimaryForce = {
                Key = "LordSkrolk",
                FactionLeaderIsForceCommander = true,
                MandatoryUnits = {
                    wh2_main_skv_inf_plague_monks = 2,
                    wh2_main_skv_inf_plague_monk_censer_bearer = 1,
                    wh2_main_skv_art_plagueclaw_catapult = 1,
                },
                UnitTags = {"ClanPestilens", "Warriors", "Slaves",},
                ArmySize = 19,
                XPLevel = 15,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = nil,
        },
        IMData = {
            Target = {
                default = {
                    Type = "REGION",
                    FactionKey = "wh2_main_skv_clan_pestilens",
                    TargetData = {
                        main_warhammer = {
                            Regions = {"wh2_main_headhunters_jungle_oyxl"},
                            SpawnCoordinates = {
                                {300, 13},
                            },
                        },
                        wh2_main_great_vortex = {
                            Regions = {"wh2_main_vor_the_lost_valleys_oyxl"},
                            SpawnCoordinates = {
                                {232, 114},
                            },
                        },
                    },
                },
            },
        },
    },

    TretchCraventail = {
        GrantTerritoryTo = {
            main_warhammer = "wh2_main_def_the_forgebound",
            wh2_main_great_vortex = "wh2_main_def_the_forgebound",
        },
        SubcultureKey = "wh2_main_sc_skv_skaven",
        TurnNumbers = {
            Minimum = 25,
            Maximum = 80,
        },
        RAMData = {
            PrimaryForce = {
                Key = "TretchCraventail",
                FactionLeaderIsForceCommander = true,
                MandatoryUnits = {
                    wh2_main_skv_inf_stormvermin_0 = 2,
                    wh2_main_skv_inf_stormvermin_1 = 1,
                    wh2_main_skv_veh_doomwheel = 1,
                },
                UnitTags = {"Warriors", "Slaves",},
                ArmySize = 19,
                XPLevel = 15,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = nil,
        },
        IMData = {
            Target = {
                default = {
                    Type = "REGION",
                    FactionKey = "wh2_dlc09_skv_clan_rictus",
                    TargetData = {
                        main_warhammer = {
                            Regions = {"wh2_main_the_clawed_coast_hoteks_column"},
                            SpawnCoordinates = {
                                {150, 529},
                            },
                        },
                        wh2_main_great_vortex = {
                            Regions = {"wh2_main_vor_the_clawed_coast_hoteks_column"},
                            SpawnCoordinates = {
                                {263, 581},
                            },
                        },
                    },
                },
            },
        },
    },--]]

    -- Vampires
    --[[HeinrichKemmler = {
        GrantTerritoryTo = {
            main_warhammer = "wh_main_dwf_karak_ziflin",
        },
        SubcultureKey = "wh_main_sc_vmp_vampire_counts",
        EmergeData = {
            TurnNumbers = {
                Minimum = 100,
                Maximum = 150,
            },
            RAMData = {
                HeinrichKemmler = {
                    Key = "HeinrichKemmler",
                    FactionLeaderIsForceCommander = true,
                    MandatoryUnits = {

                    },
                    UnitTags = {"Chaff", "Spirits",},
                    ArmySize = 19,
                    XPLevel = 15,
                    SkillsToUnlock = {
                    },
                },
            },
            IMData = {
                Target = {
                    default = {
                        Type = "REGION",
                        FactionKey = "wh2_dlc11_vmp_the_barrow_legion",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh_main_northern_grey_mountains_blackstone_post"},
                                SpawnCoordinates = {
                                    {410, 430},
                                },
                            },
                        },
                    },
                },
            },
        },
    },--]]

    -- Tomb Kings
    --[[Settra = {
        GrantTerritoryTo = nil,
        SubcultureKey = "wh2_dlc09_sc_tmb_tomb_kings",
        OnlyWoundFactionLeader = false,
        WoundTime = 9999,
        EmergeData = {
            TurnNumbers = {
                Minimum = 1,
                Maximum = 1,
            },
            RAMData = {
                Settra = {
                    Key = "Settra",
                    FactionLeaderIsForceCommander = true,
                    MandatoryUnits = {

                    },
                    UnitTags = {"SkeletonWarriors", "TombGuard", "Constructs", "ConstructMonsters", "Artillery"},
                    ArmySize = 19,
                    XPLevel = 20,
                    SkillsToUnlock = {
                    },
                },
            },
            IMData = {
                Target = {
                    default = {
                        Type = "RELEASE",
                        FactionKey = "wh2_dlc09_tmb_khemri",
                        TargetData = {
                            main_warhammer = {
                                Regions = nil,
                                SpawnCoordinates = {
                                    {560, 116},
                                },
                            },
                            wh2_main_great_vortex = {
                                Regions = nil,
                                SpawnCoordinates = {
                                    {668, 277},
                                },
                            },
                        },
                    },
                },
            },
        },
    },--]]
    --[[wh_main_vmp_mousillon = {
        GrantTerritoryTo = "wh_main_brt_lyonesse",
        LordsToWound = {
            "RED DUKE",
        },
    },

    wh_main_grn_greenskins = {
        GrantTerritoryTo = "wh_main_grn_red_fangs",
    },

    wh_main_grn_orcs_of_the_bloody_hand = {
        GrantTerritoryTo = "wh_main_brt_lyonesse",
    },

    wh2_main_vmp_the_silver_host = {
        GrantTerritoryTo = "",
    },

    wh2_dlc09_tmb_followers_of_nagash = {
        GrantTerritoryTo = "",
    },

    wh_dlc05_wef_wood_elves = {
        GrantTerritoryTo = "",
        LordsToWound = {
            "dlc05_wef_orion",
        },
    },

    wh_main_vmp_schwartzhafen = {
        GrantTerritoryTo = "",
    },

    wh_main_vmp_vampire_counts = {
        GrantTerritoryTo = "",
    },

    --]]
}