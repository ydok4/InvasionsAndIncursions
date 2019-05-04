IncursionPoolData = {
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
        NarrativeData = nil,
    },
    goblins = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 15,
                Maximum = 30,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 10,
                Maximum = 15,
            },
            DisableDiplomacy = true,
        },
        RAMData = {
            PrimaryForce = {
                Key = "goblins_main",
                IsFactionLeader = false,
                Subtypes = {"grn_goblin_great_shaman", },
                MandatoryUnits = {

                },
                UnitTags = {"Goblins", "ForestGoblins", "Monsters", },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_main_sc_grn_greenskins",
                FactionKey = "wh_main_grn_greenskins_qb1",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = false,
                TargetRegionOverride = nil,
            },
        },
        NarrativeData = {

        },
    },
    beastmen_basic = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 15,
                Maximum = 30,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 10,
                Maximum = 15,
            },
            DisableDiplomacy = true,
        },
        RAMData = {
            PrimaryForce = {
                Key = "beastmen_main",
                IsFactionLeader = false,
                Subtypes = {"dlc03_bst_beastlord", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 1,
                },
                UnitTags = {"Gors", "WarBeasts", },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_dlc03_sc_bst_beastmen",
                FactionKey = "wh_dlc03_bst_beastmen_qb1",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = false,
                TargetRegionOverride = nil,
            },
        },
        NarrativeData = {

        },
    },
    necromancer_basic = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 15,
                Maximum = 30,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 10,
                Maximum = 15,
            },
            DisableDiplomacy = true,
        },
        RAMData = {
            PrimaryForce = {
                Key = "necromancer_main",
                IsFactionLeader = false,
                Subtypes = {"vmp_master_necromancer", },
                MandatoryUnits = {
                    wh_main_vmp_inf_grave_guard_0 = 2,
                    wh_main_vmp_inf_grave_guard_1 = 1,
                },
                UnitTags = {"Chaff", "Beasts", "Spirits",},
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_main_sc_vmp_vampire_counts",
                FactionKey = "wh_main_vmp_vampire_counts_qb2",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = false,
                TargetRegionOverride = nil,
            },
        },
        NarrativeData = {

        },
    },
    ghoul_king = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 25,
                Maximum = 40,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 10,
                Maximum = 15,
            },
            DisableDiplomacy = true,
        },
        RAMData = {
            PrimaryForce = {
                Key = "ghoul_king",
                IsFactionLeader = false,
                Subtypes = {"dlc04_vmp_strigoi_ghoul_king", },
                MandatoryUnits = {
                    wh_main_vmp_mon_crypt_horrors = 2,
                },
                UnitTags = {"Ghouls", "Beasts", },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh_main_sc_vmp_vampire_counts",
                FactionKey = "wh_main_vmp_vampire_counts_qb2",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = false,
                TargetRegionOverride = nil,
            },
        },
        NarrativeData = {

        },
    },
    dark_elf_raiders = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 25,
                Maximum = 40,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 10,
                Maximum = 15,
            },
            DisableDiplomacy = true,
        },
        RAMData = {
            PrimaryForce = {
                Key = "dark_elf_raiders",
                IsFactionLeader = false,
                Subtypes = {"wh2_main_def_dreadlord", "wh2_main_def_dreadlord_fem" },
                MandatoryUnits = {
                },
                UnitTags = {"Warriors", "Corsairs", },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
                },
            },
        },
        IMData = {
            AreaOverrideKey = nil,
            FactionData = {
                SubcultureKey = "wh2_main_sc_def_dark_elves",
                FactionKey = "wh2_main_def_dark_elves_qb2",
            },
            TargetData = {
                Type = "REGION",
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = false,
                TargetRegionOverride = nil,
            },
        },
        NarrativeData = {

        },
    },
    feral_beasts = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 40,
                Maximum = 60,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 30,
                Maximum = 50,
            },
            DisableDiplomacy = true,
        },
        RAMData = {
            PrimaryForce = {
                Key = "feral_beasts",
                IsFactionLeader = true,
                Subtypes = {"wh2_dlc10_lzd_mon_carnosaur_boss", },
                MandatoryUnits = {
                    wh_main_vmp_mon_crypt_horrors = 2,
                },
                UnitTags = {"FeralBeasts", "TamedBeasts", },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
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
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = false,
                TargetRegionOverride = nil,
            },
        },
        NarrativeData = {

        },
    },
}