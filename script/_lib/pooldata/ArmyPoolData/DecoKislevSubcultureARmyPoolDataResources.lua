function GetDecoKislevSubcultureArmyPoolDataResources()
    return {
        -- Kislev
        wh_main_sc_ksl_kislev = {
            StateTroops = {
                Early = {
                    wh_main_emp_inf_spearmen_0 = 3,
                    wh_dlc04_emp_inf_free_company_militia_0 = 1,
                },
                Mid = {
                    wh_main_emp_inf_spearmen_0 = 1,
                    wh_main_emp_inf_spearmen_1 = 1,
                    wh_main_emp_inf_crossbowmen = 1,
                    wh_dlc04_emp_inf_free_company_militia_0 = 1,
                },
                Late = {
                    wh_main_emp_inf_spearmen_1 = 2,
                    wh_main_emp_inf_crossbowmen = 1,
                    wh_dlc04_emp_inf_free_company_militia_0 = 1,
                },
            },
            EliteStateTroops = {
                Early = {
                    wh_main_emp_inf_swordsmen = 1,
                },
                Mid = {
                    wh_main_emp_inf_halberdiers = 1,
                    wh_main_emp_inf_handgunners = 1,
                },
                Late = {
                    wh_main_emp_inf_halberdiers = 2,
                    wh_main_emp_inf_handgunners = 1,
                    wh_main_emp_inf_greatswords = 1,
                },
            },
            GenericCavalry = {
                Early = {
                    wh_main_emp_cav_empire_knights = 1,
                },
                Mid = {
                    wh_main_emp_cav_pistoliers_1 = 1,
                    wh_main_emp_cav_empire_knights = 2,
                },
                Late = {
                    wh_main_emp_cav_empire_knights = 2,
                    wh_main_emp_cav_outriders_0 = 1,
                },
            },
            Artillery = {
                Early = {
                    wh_main_emp_art_mortar = 1,
                },
                Mid = {
                    { wh_main_emp_art_great_cannon = 1, wh_main_emp_art_mortar = 2, },
                },
                Late = {
                    { wh_main_emp_art_mortar = 2, wh_main_emp_art_great_cannon = 2, },
                },
            },
        },
    };
end