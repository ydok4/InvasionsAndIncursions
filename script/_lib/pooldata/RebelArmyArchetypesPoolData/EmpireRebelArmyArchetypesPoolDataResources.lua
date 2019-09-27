function GetEmpireRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_emp_empire = {
            EmpireGeneral = {
                AgentSubtypes = {
                    emp_lord = {
                        AgentSubtypeKey = "emp_lord",
                        AgentSubTypeMount = "wh_main_anc_mount_emp_general_barded_warhorse",
                    },
                },
                UnitTags = {"StateTroops", "MidStateTroops", "GenericCavalry", },
                Weighting = 4,
            },
            ArchLector = {
                AgentSubtypes = {"dlc04_emp_arch_lector", },
                MandatoryUnits = {
                    wh_dlc04_emp_inf_flagellants_0 = 3,
                },
                UnitTags = {"StateTroops", "EliteStateTroops", },
                Weighting = 1,
            },
        },
    };
end