function GetMixuEmpireRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_emp_empire = {
            WizardLord = {
                AgentSubtypes = {"emp_wizard_lord_beasts", "emp_wizard_lord_light", "emp_wizard_lord_fire", "emp_wizard_lord_shadow", "emp_wizard_lord_heavens", },
                MandatoryUnits = {
                    wh_main_emp_veh_luminark_of_hysh_0 = 1,
                },
                UnitTags = {"StateTroops", "GenericCavalry", },
                Weighting = 1,
            },
        },
    };
end