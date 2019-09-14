function GetEmpireRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_emp_empire = {
            EmpireGeneral = {
                AgentSubtypes = {"emp_lord", },
                UnitTags = {"StateTroops", "MidStateTroops", "GenericCavalry", },
                Weighting = 3,
            },
            ArchLector = {
                AgentSubtypes = {"dlc04_emp_arch_lector", },
                MandatoryUnits = {
                    wh_main_emp_art_great_cannon = 1,
                    wh2_dlc13_emp_cav_empire_knights_ror_1 = 1,
                    wh_dlc04_emp_cav_knights_blazing_sun_0 = 1,
                    wh_dlc04_emp_inf_flagellants_0 = 3,
                },
                UnitTags = {"StateTroops", "EliteStateTroops", },
                Weighting = 0,
            },
        },
    };
end