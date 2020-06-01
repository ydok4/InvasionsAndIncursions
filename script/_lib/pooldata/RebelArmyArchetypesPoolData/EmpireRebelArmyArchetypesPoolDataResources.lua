function GetEmpireRebelArmyArchetypesPoolDataResources()
    return {
        EmpireGeneral = {
            AgentSubtypes = {
                emp_lord = {
                    AgentSubtypeKey = "emp_lord",
                    AgentSubTypeMount = "wh_main_anc_mount_emp_general_barded_warhorse",
                },
            },
            UnitTags = {"StateTroops", "MidStateTroops", "GenericCavalry", },
            Weighting = 3,
        },
        ArchLector = {
            AgentSubtypes = {"dlc04_emp_arch_lector", },
            MandatoryUnits = {
                wh_dlc04_emp_inf_flagellants_0 = 3,
            },
            UnitTags = {"StateTroops", "EliteStateTroops", },
            Weighting = 1,
        },
        KarlFranzReemerge = {
            RebellionFaction = "wh_main_emp_empire",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                emp_karl_franz = {
                    AgentSubtypeKey = "emp_karl_franz",
                },
            },
            MandatoryUnits = {
                wh_main_emp_inf_greatswords = 2,
                wh_main_emp_cav_reiksguard = 1,
            },
            UnitTags = { "StateTroops", "MidStateTroops", "GenericCavalry", "Artillery", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh_main_reikland_altdorf", },
                wh2_main_great_vortex = nil,
            },
        },
        EmpireBandits = {
            AgentSubtypes = {
                emp_lord = {
                    AgentSubtypeKey = "emp_lord",
                },
            },
            MandatoryUnits = {
                wh_main_emp_art_great_cannon = 2,
                wh_main_emp_art_mortar = 1,
            },
            UnitTags = {"StateTroops", },
            Weighting = 5,
        },
    };
end