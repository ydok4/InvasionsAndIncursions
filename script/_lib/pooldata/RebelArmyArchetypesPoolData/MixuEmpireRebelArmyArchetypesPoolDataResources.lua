function GetMixuEmpireRebelArmyArchetypesPoolDataResources()
    return {
        WizardLord = {
            AgentSubtypes = {"emp_wizard_lord_beasts", "emp_wizard_lord_light", "emp_wizard_lord_fire", "emp_wizard_lord_shadow", "emp_wizard_lord_heavens", "emp_wizard_lord_metal", "emp_wizard_lord_death", "emp_wizard_lord_life",  },
            MandatoryUnits = {
                wh_main_emp_veh_luminark_of_hysh_0 = 1,
            },
            UnitTags = {"StateTroops", "MidStateTroops", "GenericCavalry", },
            Weighting = 1,
        },
    };
end