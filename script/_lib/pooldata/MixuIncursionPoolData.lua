MixuIncursionPoolData = {
    beastmen_doombull = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 45,
                Maximum = 70,
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
                Key = "beastmen_doombull",
                IsFactionLeader = false,
                Subtypes = {"bst_doombull", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_minotaurs_2 = 2,
                },
                UnitTags = {"Gors", "Minotaurs", "Monsters" },
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
        MMData = {

        },
    },
    fimir = {
        SpawningData = {
            StartingTurnNumbers = {
                Minimum = 45,
                Maximum = 80,
            },
            NextEventKey = nil,
            NumberOfTurnsBeforeReoccurrence = {
                Minimum = 50,
                Maximum = 75,
            },
            DisableDiplomacy = true,
        },
        RAMData = {
            PrimaryForce = {
                Key = "fimir",
                IsFactionLeader = false,
                Subtypes = {"nor_fimir_warlord", },
                MandatoryUnits = {
                    wh_dlc03_bst_inf_bestigor_herd_0 = 1,
                },
                UnitTags = {"Fimir", "WarBeasts", "Trolls" },
                ArmySize = nil,
                XPLevel = nil,
                SkillsToUnlock = {
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
                NumberOfTargets = 1,
                CanTargetAdjacentRegions = true,
                CanTargetProvinceCapital = false,
                TargetRegionOverride = nil,
            },
        },
        MMData = {

        },
    },
}