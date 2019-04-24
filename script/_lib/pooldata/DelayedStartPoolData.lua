DelayedStartPoolData = {
    -- Vampirates
    CylostraDirefan = {
        GrantTerritoryTo = {
            main_warhammer = "wh2_main_grn_blue_vipers",
            wh2_main_great_vortex = "wh2_main_def_ssildra_tor",
        },
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 25,
                Maximum = 50,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = nil,
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
                ModelOverride = nil,
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
        NarrativeData = {
            Incidents = {
                {
                    Delay = -1,
                    Key = "wh_main_iandi_cylostra_direfan",
                },
            },
            Dilemmas = nil,
            Missions = nil,
        },
    },

    CountNoctilus = {
        GrantTerritoryTo = nil,
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 40,
                Maximum = 60,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = {
                OnlyWoundFactionLeader = true,
                ReplacementSubType = "wh2_dlc11_cst_admiral",
            },
        },
        RAMData = {
            PrimaryForce = {
                Key = "CountNoctilus",
                IsFactionLeader = true,
                MandatoryUnits = {
                    wh2_dlc11_cst_mon_necrofex_colossus_0 = 1,
                    wh2_dlc11_cst_inf_depth_guard_1 = 1,
                },
                UnitTags = {"Zombies", "Artillery", "DepthGuard",},
                ArmySize = 19,
                XPLevel = 20,
                SkillsToUnlock = {
                },
                ModelOverride = "wh2_dlc11_art_set_cst_noctilus_1",
            },
            SecondaryForces = nil,
        },
        IMData = {
            AreaOverrideKey = "CountNoctilus",
            FactionData = {
                SubcultureKey = "wh2_dlc11_sc_cst_vampire_coast",
                FactionKey = "wh2_dlc11_cst_noctilus",
            },
            TargetData = {
                Type = "RELEASE",
                NumberOfTargets = nil,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
                    main_warhammer = {
                        Regions = nil,
                        SpawnCoordinates = {"GalleonsGraveyard",},
                    },
                    wh2_main_great_vortex = {
                        Regions = nil,
                        SpawnCoordinates = {"GalleonsGraveyard",},
                    },
                },
            },
        },
        NarrativeData = {
            Incidents = {
                {
                    Delay = 0,
                    Key = "wh_main_iandi_count_noctilus",
                },
            },
            Dilemmas = nil,
            Missions = nil,
        },
    },

    -- Tomb Kings
    Settra = {
        GrantTerritoryTo = nil,
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 70,
                Maximum = 120,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = {
                OnlyWoundFactionLeader = true,
                ReplacementSubType = "wh2_dlc09_tmb_tomb_king",
            },
        },
        RAMData = {
            PrimaryForce = {
                Key = "Settra",
                IsFactionLeader = true,
                MandatoryUnits = {

                },
                UnitTags = {"SkeletonWarriors", "TombGuard", "Constructs", "ConstructMonsters", "Artillery"},
                ArmySize = 19,
                XPLevel = 20,
                SkillsToUnlock = {
                },
                -- For some weird reason spawning Settra's agent subtype causes a regular
                -- Tomb King to spawn. They have the right skill tree and stuff though.
                ModelOverride = "wh2_dlc09_art_set_tmb_settra",
            },
            SecondaryForces = nil,
        },
        IMData = {
            AreaOverrideKey = "Settra",
            FactionData = {
                SubcultureKey = "wh2_dlc09_sc_tmb_tomb_kings",
                FactionKey = "wh2_dlc09_tmb_khemri",
            },
            TargetData = {
                Type = "RELEASE",
                NumberOfTargets = nil,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
                    main_warhammer = {
                        Regions = nil,
                        SpawnCoordinates = {"Khemri",},
                    },
                    wh2_main_great_vortex = {
                        Regions = nil,
                        SpawnCoordinates = {"Khemri",},
                    },
                },
            },
        },
        NarrativeData = {
            Incidents = {
                {
                    Delay = 0,
                    Key = "wh_main_iandi_settra",
                },
            },
            Dilemmas = nil,
            Missions = nil,
        },
    },
    -- Delayed Beastmen
    Khazrak = {
        GrantTerritoryTo = nil,
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 100,
                Maximum = 140,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = nil,
        },
        RAMData = {
            PrimaryForce = {
                Key = "Khazrak",
                IsFactionLeader = true,
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 2,
                    wh_dlc03_bst_inf_minotaurs_0 = 2,
                },
                UnitTags = {"Gors", "Minotaurs", "WarBeasts", },
                ArmySize = 19,
                XPLevel = 15,
                SkillsToUnlock = {
                },
                ModelOverride = nil,
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
            AreaOverrideKey = "Khazrak",
            FactionData = {
                SubcultureKey = "wh_dlc03_sc_bst_beastmen",
                FactionKey = "wh_dlc03_bst_beastmen",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = nil,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
                    main_warhammer = {
                        Regions = {"wh_main_middenland_weismund", "wh_main_middenland_carroburg",},
                        SpawnCoordinates = {"DrakwaldForest",},
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
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 80,
                Maximum = 120,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = nil,
        },
        RAMData = {
            PrimaryForce = {
                Key = "AlithAnar",
                IsFactionLeader = true,
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
                ModelOverride = nil,
            },
            SecondaryForces = nil,
        },
        IMData = {
            AreaOverrideKey = "AlithAnar",
            FactionData = {
                SubcultureKey = "wh2_main_sc_hef_high_elves",
                FactionKey = "wh2_main_hef_nagarythe",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = nil,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
                    main_warhammer = {
                        Regions = {"wh2_main_the_black_coast_arnheim"},
                        SpawnCoordinates = {
                            "BleakCoast",
                        },
                    },
                    wh2_main_great_vortex = {
                        Regions = {"wh2_main_vor_the_broken_land_black_creek_spire"},
                        SpawnCoordinates = {
                            "ClarondKar",
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
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 100,
                Maximum = 200,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = nil,
        },
        RAMData = {
            PrimaryForce = {
                Key = "LokhirFellheart",
                IsFactionLeader = true,
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
                ModelOverride = nil,
            },
            SecondaryForces = nil,
        },
        IMData = {
            AreaOverrideKey = "LokhirFellheart",
            FactionData = {
                SubcultureKey = "wh2_main_sc_def_dark_elves",
                FactionKey = "wh2_dlc11_def_the_blessed_dread",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = nil,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
                    main_warhammer = {
                        Regions = {"wh2_main_headhunters_jungle_chupayotl"},
                        SpawnCoordinates = {
                            "SouthernOcean"
                        },
                    },
                    wh2_main_great_vortex = {
                        Regions = {"wh2_main_vor_culchan_plains_chupayotl"},
                        SpawnCoordinates = {
                            "SouthernOcean",
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
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 100,
                Maximum = 200,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = nil,
        },
        RAMData = {
            PrimaryForce = {
                Key = "LordSkrolk",
                IsFactionLeader = true,
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
                ModelOverride = nil,
            },
            SecondaryForces = nil,
        },
        IMData = {
            AreaOverrideKey = "LordSkrolk",
            FactionData = {
                SubcultureKey = "wh2_main_sc_skv_skaven",
                FactionKey = "wh2_main_skv_clan_pestilens",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = nil,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
                    main_warhammer = {
                        Regions = {"wh2_main_headhunters_jungle_oyxl"},
                        SpawnCoordinates = {
                            "SouthernLustriaSkrolk"
                        },
                    },
                    wh2_main_great_vortex = {
                        Regions = {"wh2_main_vor_the_lost_valleys_oyxl"},
                        SpawnCoordinates = {
                           "SouthernLustriaSkrolk"
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
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 25,
                Maximum = 80,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = nil,
            ReplacementData = nil,
        },
        RAMData = {
            PrimaryForce = {
                Key = "TretchCraventail",
                IsFactionLeader = true,
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
                ModelOverride = nil,
            },
            SecondaryForces = nil,
        },
        IMData = {
            AreaOverrideKey = "TretchCraventail",
            FactionData = {
                SubcultureKey = "wh2_main_sc_skv_skaven",
                FactionKey = "wh2_dlc09_skv_clan_rictus",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = nil,
                CanTargetAdjacentRegions = false,
                TargetRegionOverride = {
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
                    IsFactionLeader = true,
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