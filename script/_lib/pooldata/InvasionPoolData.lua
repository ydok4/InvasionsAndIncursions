InvasionPoolData = {
    default = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 10,
                Maximum = 10,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 0,
                Maximum = 10,
            },
            DisableDiplomacy = nil,
        },
        RAMData = nil,
        IMData = nil,
    },
    norsca_minor = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 30,
                Maximum = 50,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 25,
                Maximum = 40,
            },
        },
        RAMData = {
            PrimaryForce = {
                Key = "norsca_minor_main",
                IsFactionLeader = false,
                Subtypes = {"nor_marauder_chieftain", },
                MandatoryUnits = {
                    wh_dlc08_nor_inf_marauder_champions_1 = 1,
                    wh_dlc08_nor_mon_norscan_giant_0 = 1,
                },
                UnitTags = {"Warriors", "Horsemen", {"SkinWolves", "Trolls"}, },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = {
                SecondForce = {
                    Key = "norsca_minor_second",
                    IsFactionLeader = false,
                    Subtypes = {"nor_marauder_chieftain", },
                    MandatoryUnits = nil,
                    UnitTags = {"Warriors", "Horsemen", "WarBeasts", },
                    ArmySize = nil,
                    XPLevel = nil,
                    SkillsToUnlock = {
                    },
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_main_sc_nor_norsca",
                FactionKey = "wh_main_nor_norsca_qb2",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 2,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = true,
                TargetRegionOverride = nil,
            },
        },
        MMData = {

        },
    },
    lizardmen_minor = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 60,
                Maximum = 70,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 30,
                Maximum = 100,
            },
        },
        RAMData = {
            PrimaryForce = {
                Key = "lizardmen_minor_main",
                IsFactionLeader = true,
                Subtypes = {"wh2_main_lzd_saurus_old_blood", },
                MandatoryUnits = {
                    wh_dlc08_nor_inf_marauder_champions_1 = 1,
                    wh_dlc08_nor_mon_norscan_giant_0 = 1,
                },
                UnitTags = {"Skinks", "Saurus", "Kroxigors", "TamedBeasts" },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = {
                SecondForce = {
                    Key = "lizardmen_minor_second",
                    IsFactionLeader = false,
                    Subtypes = {"wh2_main_lzd_saurus_old_blood", },
                    MandatoryUnits = nil,
                    UnitTags = {"Skinks", "Saurus", "Kroxigors", "FeralBeasts"  },
                    ArmySize = nil,
                    XPLevel = nil,
                    SkillsToUnlock = {
                    },
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh2_main_sc_lzd_lizardmen",
                FactionKey = "wh2_main_lzd_lizardmen_qb2",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 2,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = true,
                TargetRegionOverride = nil,
            },
        },
        MMData = {

        },
    },
    savage_orcs = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 1,
                Maximum = 1,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 30,
                Maximum = 50,
            },
        },
        RAMData = {
            PrimaryForce = {
                Key = "savage_orcs",
                IsFactionLeader = false,
                Subtypes = {"grn_orc_warboss", },
                MandatoryUnits = {
                    wh_dlc08_nor_inf_marauder_champions_1 = 1,
                    wh_dlc08_nor_mon_norscan_giant_0 = 1,
                },
                UnitTags = {"SavageOrcs", },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = {
                SecondForce = {
                    Key = "savage_orcs_second",
                    IsFactionLeader = false,
                    Subtypes = {"grn_goblin_great_shaman", },
                    MandatoryUnits = nil,
                    UnitTags = {"SavageOrcs", },
                    ArmySize = 12,
                    XPLevel = 8,
                    SkillsToUnlock = {
                    },
                },
                ThirdForce = {
                    Key = "savage_orcs_third",
                    IsFactionLeader = false,
                    Subtypes = {"grn_goblin_great_shaman", },
                    MandatoryUnits = nil,
                    UnitTags = {"SavageOrcs",  },
                    ArmySize = 10,
                    XPLevel = 5,
                    SkillsToUnlock = {
                    },
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_main_sc_grn_savage_orcs",
                FactionKey = "wh_main_grn_greenskins_qb2",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 2,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = true,
                TargetRegionOverride = nil,
            },
        },
        MMData = {

        },
    },
    greenskin_minor = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 20,
                Maximum = 40,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 10,
                Maximum = 25,
            },
        },
        RAMData = {
            PrimaryForce = {
                Key = "greenskin_minor",
                IsFactionLeader = false,
                Subtypes = {"grn_orc_warboss", },
                MandatoryUnits = {
                    wh_dlc08_nor_inf_marauder_champions_1 = 1,
                    wh_dlc08_nor_mon_norscan_giant_0 = 1,
                },
                UnitTags = {"Orcs", "Monsters", "Artillery",},
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
            SecondaryForces = {
                SecondForce = {
                    Key = "savage_orcs_second",
                    IsFactionLeader = false,
                    Subtypes = {"grn_goblin_great_shaman", },
                    MandatoryUnits = nil,
                    UnitTags = {"SavageOrcs", },
                    ArmySize = 12,
                    XPLevel = 8,
                    SkillsToUnlock = {
                    },
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_main_grn_greenskins",
                FactionKey = "wh_main_grn_greenskins_qb2",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 2,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = true,
                TargetRegionOverride = nil,
            },
        },
        MMData = {

        },
    },
}