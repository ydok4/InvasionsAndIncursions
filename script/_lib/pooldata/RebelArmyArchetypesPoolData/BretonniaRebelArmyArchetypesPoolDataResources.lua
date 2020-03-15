function GetBretonniaRebelArmyArchetypesPoolDataResources()
    return {
        BretLord = {
            AgentSubtypes = {
                brt_lord = {
                    AgentSubtypeKey = "brt_lord",
                    AgentSubTypeMount = "wh_main_anc_mount_brt_general_barded_warhorse",
                },
            },
            UnitTags = {"Peasants", "MenAtArms", "Knights", },
            Weighting = 3,
        },
        LouenReemerge = {
            RebellionFaction = "wh_main_brt_bretonnia",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                brt_louen_leoncouer = {
                    AgentSubtypeKey = "brt_louen_leoncouer",
                    AgentSubTypeMount = "wh_main_anc_mount_brt_louen_barded_warhorse",
                },
            },
            MandatoryUnits = {
                wh_dlc07_brt_cav_royal_pegasus_knights_0 = 2,
                wh_dlc07_brt_cav_royal_hippogryph_knights_0 = 1,
            },
            UnitTags = {"MenAtArms", "Knights", "GrailKnights", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh_main_couronne_et_languille_couronne", },
                wh2_main_great_vortex = nil,
            },
        },
    };
end