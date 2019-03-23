DelayedStartPoolData = {
    -- Beastmen
    Malagor = {
        GrantTerritoryTo = nil,
        SubcultureKey = "wh_dlc03_sc_bst_beastmen",
        EmergeData = {
            TurnNumbers = {
                Minimum = 80,
                Maximum = 200,
            },
            RAMData = {
                Malagor = {
                    Key = "Malagor",
                    FactionLeaderIsForceCommander = true,
                    MandatoryUnits = {
                        wh_dlc03_bst_inf_cygor_0 = 1,
                    },
                    UnitTags = {"Gors", "WarBeasts", },
                    ArmySize = 19,
                    XPLevel = 15,
                    SkillsToUnlock = {
                    },
                },
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
            IMData = {
                Target = {
                    default = {
                        Type = "REGION",
                        FactionKey = "wh_dlc03_bst_jagged_horn",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh_main_southern_badlands_galbaraz", "wh_main_western_badlands_dragonhorn_mines", "wh_main_southern_badlands_agrul_migdhal", "wh_main_blightwater_deff_gorge", },
                                SpawnCoordinates = {
                                    {643, 191}, {629, 190},
                                },
                            },
                        },
                    },
                },
            },
        },
    },

    Morghur = {
        GrantTerritoryTo = nil,
        SubcultureKey = "wh_dlc03_sc_bst_beastmen",
        EmergeData = {
            TurnNumbers = {
                Minimum = 100,
                Maximum = 200,
            },
            RAMData = {
                Morghur = {
                    Key = "Morghur",
                    FactionLeaderIsForceCommander = true,
                    MandatoryUnits = {
                        wh_dlc03_bst_mon_chaos_spawn_0 = 4,
                    },
                    UnitTags = {"Gors", "WarBeasts", "Monsters" },
                    ArmySize = 19,
                    XPLevel = 15,
                    SkillsToUnlock = {
                    },
                },
                SecondaryForce = {
                    Key = "SecondaryForce",
                    MandatoryUnits = {
                        wh_dlc03_bst_mon_chaos_spawn_0 = 2,
                    },
                    UnitTags = {"Gors", "WarBeasts", "Monsters"},
                    ArmySize = 10,
                    XPLevel = 10,
                    SkillsToUnlock = {
                    },
                },
            },
            IMData = {
                Target = {
                    default = {
                        Type = "REGION",
                        FactionKey = "wh_dlc03_bst_redhorn",
                        TargetData = {
                            main_warhammer = {
                                Regions = {"wh_main_yn_edri_eternos_the_oak_of_ages", "wh_main_athel_loren_yn_edryl_korian", "wh_main_athel_loren_vauls_anvil", "wh_main_athel_loren_crag_halls", "wh_main_athel_loren_waterfall_palace"},
                                SpawnCoordinates = {
                                    {417, 291}, {413, 286},
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}

--[[    wh_main_grn_red_eye = {
        GrantTerritoryTo = "",
        LordsToWound = {
            "grn_azhag_the_slaughterer",
        },
    },
}--]]