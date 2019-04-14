IncursionPoolData = {
    GoblinIncursion = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 3,
                Maximum = 3,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeOccurrence = {
                Minimum = 10,
                Maximum = 15,
            },
        },
        RAMData = {
            PrimaryForce = {
                Key = "GoblinIncursion_Main",
                IsFactionLeader = false,
                MandatoryUnits = {
                    wh_dlc08_nor_inf_marauder_champions_1 = 1,
                    wh_dlc08_nor_mon_norscan_giant_0 = 1,
                },
                UnitTags = {"Goblins", "ForestGoblins", "Orcs", },
                ArmySize = 12,
                XPLevel = 5,
                SkillsToUnlock = {
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_main_sc_grn_greenskins",
                FactionKey = nil,
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = true,
                TargetRegionOverride = nil,
            },
        },
        MMData = {

        },
    },
    -- Orcs, Massif Orcal
    --[[OrcsMassifOrcal = {
        SubcultureKey = "wh_main_sc_grn_greenskins",
        EmergeData = {
            TurnNumbers = {
                Minimum = 20,
                Maximum = 25,
            },
            RAMData = {
                Warboss = {
                    Key = "Warboss",
                    FactionLeaderIsForceCommander = false,
                    MandatoryUnits = {

                    },
                    UnitTags = {"Goblins", "ForestGoblins", "Orcs"},
                    ArmySize = 12,
                    XPLevel = 5,
                    SkillsToUnlock = {
                    },
                },
            },
            IMData = {
                Target = {
                    default = {
                        Type = "REGION",
                        FactionKey = "wh_main_grn_broken_nose_waaagh",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh_main_bordeleaux_et_aquitaine_bordeleaux", "wh_main_bordeleaux_et_aquitaine_aquitaine", "wh_main_parravon_et_quenelles_parravon", "wh_main_parravon_et_quenelles_quenelles",
                                    "wh_main_carcassone_et_brionne_brionne", "wh_main_bastonne_et_montfort_castle_bastonne",
                                },
                                SpawnCoordinates = {
                                    "MassifOrcal",
                                },
                            },
                        },
                    },
                },
            },
        },
    },
    -- Skaven, BlackChasm
    SkavenBlackChasm = {
        SubcultureKey = "wh2_main_sc_skv_skaven",
        EmergeData = {
            TurnNumbers = {
                Minimum = 100,
                Maximum = 125,
            },
            RAMData = {
                Warlord = {
                    Key = "Warlord",
                    FactionLeaderIsForceCommander = false,
                    MandatoryUnits = {

                    },
                    UnitTags = {"ClanEshin", "ClanPestilens", "Skavenslaves", "Warriors"},
                    ArmySize = 12,
                    XPLevel = 5,
                    SkillsToUnlock = {
                    },
                },
            },
            IMData = {
                Target = {
                    default = {
                        Type = "REGION",
                        FactionKey = "wh2_main_skv_clan_eshin",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh_main_bordeleaux_et_aquitaine_bordeleaux", "wh_main_bordeleaux_et_aquitaine_aquitaine", "wh_main_parravon_et_quenelles_parravon", "wh_main_bastonne_et_montfort_castle_bastonne",
                                },
                                SpawnCoordinates = {
                                    "BlackChasm",
                                },
                            },
                        },
                    },
                },
            },
        },
    },
    -- Beastmen, ForestOfArden
    BeastmenForestOfArden = {
        SubcultureKey = "wh_dlc03_sc_bst_beastmen",
        EmergeData = {
            TurnNumbers = {
                Minimum = 30,
                Maximum = 50,
            },
            RAMData = {
                BeastLord = {
                    Key = "BeastLord",
                    FactionLeaderIsForceCommander = false,
                    MandatoryUnits = {

                    },
                    UnitTags = {"Gors", "WarBeasts",},
                    ArmySize = 15,
                    XPLevel = 8,
                    SkillsToUnlock = {
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
                                Regions = {"wh_main_forest_of_arden_castle_artois", "wh_main_forest_of_arden_gisoreux", "wh_main_bastonne_et_montfort_castle_bastonne", "wh_main_bastonne_et_montfort_montfort",
                                "wh_main_couronne_et_languille_languille",
                            }   ,
                                SpawnCoordinates = {
                                    "ForestOfArden",
                                },
                            },
                        },
                    },
                },
            },
        },
    },

    -- Beastmen, ForestOfChalons
    BeastmenForestOfChalons = {
        SubcultureKey = "wh_dlc03_sc_bst_beastmen",
        EmergeData = {
            TurnNumbers = {
                Minimum = 30,
                Maximum = 50,
            },
            RAMData = {
                BeastLord = {
                    Key = "BeastLord",
                    FactionLeaderIsForceCommander = false,
                    MandatoryUnits = {

                    },
                    UnitTags = {"Gors", "WarBeasts",},
                    ArmySize = 14,
                    XPLevel = 8,
                    SkillsToUnlock = {
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
                                Regions = {"wh_main_bordeleaux_et_aquitaine_bordeleaux", "wh_main_bordeleaux_et_aquitaine_aquitaine", "wh_main_parravon_et_quenelles_parravon", "wh_main_parravon_et_quenelles_quenelles",
                                "wh_main_carcassone_et_brionne_brionne", "wh_main_bastonne_et_montfort_castle_bastonne",
                                },
                                SpawnCoordinates = {
                                    "ForestOfChalons",
                                },
                            },
                        },
                    },
                },
            },
        },
    },--]]
}