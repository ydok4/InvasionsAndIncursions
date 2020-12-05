function GetCRSkyCutterSubcultureArmyPoolDataResources()
    return {
        -- High Elves
        wh2_main_sc_hef_high_elves = {
            Lothern = {
                Late = {
                    cr_hef_veh_lothern_skycutter = 1,
                },
            },
            -- Cataph's Sea Helm
            --[[SeaHelm = {
                Early = {
                    AK_hef_sea_company = 3,
                },
                Mid = {
                    AK_hef_sea_company = 2,
                    AK_hef_sea_rangers = 1,
                    AK_hef_sea_roc_riders = 1,
                },
                Late = {
                    AK_hef_sea_company = 2,
                    AK_hef_sea_rangers = 2,
                    AK_hef_sea_roc_riders = 1,
                },
            },--]]
        },
    };
end


function GetCRSpearChukkaSubcultureArmyPoolDataResources()
    return {
        -- Orcs
        wh_main_sc_grn_greenskins = {
            Artillery = {
                Early = {
                    cr_grn_art_spear_chukka = 1,
                    wh_main_grn_art_goblin_rock_lobber = false,
                },
            },
        },
    };
end

function GetCRGhorgonSubcultureArmyPoolDataResources()
    return {
        -- Beastmen
        wh_dlc03_sc_bst_beastmen = {
            Minotaurs = {
                Late = {
                    cr_bst_mon_ghorgon_0 = 1,
                },
            },
        },
    };
end

function GetCRPreytonSubcultureArmyPoolDataResources()
    return {
        -- Beastmen
        wh_dlc03_sc_bst_beastmen = {
            Monsters = {
                Late = {
                    cr_bst_mon_preyton_0 = 1,
                },
            },
        },
    };
end

function GetCRChimaeratSubcultureArmyPoolDataResources()
    return {
        -- Skaven
        wh2_main_sc_skv_skaven = {
            ClanMoulder = {
                Mid = {
                    cr_skv_mon_chimaerat_0 = 1,
                },
            },
        },
    };
end

--[[function GetCRDaemonettesSubcultureArmyPoolDataResources()
    return {
        -- Chaos
        wh_main_sc_chs_chaos = {
            Daemons = {
                Early = {
                    bacr_chs_inf_daemonette = 1,
                },
            },
        },
    };
end

function GetCRBloodletterSubcultureArmyPoolDataResources()
    return {
        -- Chaos
        wh_main_sc_chs_chaos = {
            Daemons = {
                Early = {
                    kho_bloodletter = 1,
                },
            },
        },
    };
end

function GetCRPlaguebearerSubcultureArmyPoolDataResources()
    return {
        -- Chaos
        wh_main_sc_chs_chaos = {
            Daemons = {
                Early = {
                    rbt_nurgle_daemon = 1,
                },
            },
        },
    };
end--]]

function GetCRDaemonSubcultureArmyPoolDataResources()
    return {
        -- Chaos
        wh_main_sc_chs_chaos = {
            Daemons = {
                Early = {
                    { bacr_chs_inf_daemonette = 1, kho_bloodletter = 1,  rbt_nurgle_daemon = 1, },
                },
                Mid = {
                    { bacr_chs_inf_daemonette = 2, kho_bloodletter = 2,  rbt_nurgle_daemon = 2, },
                },
                Late = {
                    { bacr_chs_inf_daemonette = 3, kho_bloodletter = 3,  rbt_nurgle_daemon = 3, },
                },
            },
        },
    };
end