function GetLizardmenRebelArmyArchetypesPoolDataResources()
    return {
        wh2_main_sc_lzd_lizardmen = {
            Saurus = {
                AgentSubtypes = {"wh2_main_lzd_saurus_old_blood", },
                UnitTags = {"Saurus", "ColdOnes", "FeralBeasts", },
                Weighting = 3,
            },
            Skinks = {
                AgentSubtypes = {"wh2_dlc12_lzd_red_crested_skink_chief", },
                MandatoryUnits = {
                    wh2_dlc12_lzd_inf_skink_red_crested_0 = 2,
                    wh2_main_lzd_mon_kroxigors = 1,
                },
                UnitTags = {"Skinks", "wh2_main_lzd_mon_kroxigors", "FeralBeasts", },
                Weighting = 1,
            },
        },
    };
end