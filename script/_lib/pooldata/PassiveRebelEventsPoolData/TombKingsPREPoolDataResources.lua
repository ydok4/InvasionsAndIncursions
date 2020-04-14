function GetTombKingsPREPoolDataResources()
    return {
        ReemergeanceArchetypeKhemri = {
            PRESubculture = "wh2_dlc09_sc_tmb_tomb_kings",
            ArmyArchetypes = {"SettraReemerge", },
            CleanUpRebelForce = false,
            EffectBundleKey = "er_effect_bundle_generic_incursion_region",
            EffectBundleEffects = {
                wh_main_effect_public_order_events = -5,
            },
            PREDuration = 5,
            InitialRebellionIncident = {
                default = "er_settra_reemerging_faction_incident_spawn_incident",
            },
            TriggerArmySpawnWhenPREEnds = true,
            IsRebelSpawnLocked = true,
            Incidents = {
                default = {

                },
                wh_main_sc_brt_bretonnia = {
                    er_settra_reemerging_faction_incident_1_brettonia = {
                        NumberOfTurns = 1,
                    },
                    er_settra_reemerging_faction_incident_2_bretonnia = {
                        NumberOfTurns = 4,
                    },
                },
                wh2_main_sc_def_dark_elves = {
                   er_settra_reemerging_faction_incident_1_dark_elves = {
                        NumberOfTurns = 1,
                    },
                   er_settra_reemerging_faction_incident_2_dark_elves = {
                        NumberOfTurns = 4,
                    },
                },
                wh_main_sc_dwf_dwarfs = {
                   er_settra_reemerging_faction_incident_1_dwarfs = {
                        NumberOfTurns = 1,
                    },
                    er_louen_reemerging_faction_incident_2_dwarfs = {
                        NumberOfTurns = 4,
                    },
                },
                wh_main_sc_emp_empire = {
                   er_settra_reemerging_faction_incident_1_empire = {
                        NumberOfTurns = 1,
                    },
                   er_settra_reemerging_faction_incident_2_empire = {
                        NumberOfTurns = 4,
                    },
                },
                wh_main_sc_grn_greenskins = {
                   er_settra_reemerging_faction_incident_1_greenskins = {
                        NumberOfTurns = 1,
                    },
                    er_louen_reemerging_faction_incident_2_greenskins = {
                        NumberOfTurns = 4,
                    },
                },
                wh2_main_sc_hef_high_elves = {
                   er_settra_reemerging_faction_incident_1_high_elves = {
                        NumberOfTurns = 1,
                    },
                   er_settra_reemerging_faction_incident_2_high_elves = {
                        NumberOfTurns = 4,
                    },
                },
                wh2_main_sc_lzd_lizardmen = {
                   er_settra_reemerging_faction_incident_1_lizardmen = {
                        NumberOfTurns = 1,
                    },
                   er_settra_reemerging_faction_incident_2_lizardmen = {
                        NumberOfTurns = 4,
                    },
                },
                wh2_main_sc_skv_skaven = {
                   er_settra_reemerging_faction_incident_1_skaven = {
                        NumberOfTurns = 1,
                    },
                   er_settra_reemerging_faction_incident_2_skaven = {
                        NumberOfTurns = 4,
                    },
                },
                wh2_dlc11_sc_cst_vampire_coast = {
                   er_settra_reemerging_faction_incident_1_vampire_coast = {
                        NumberOfTurns = 1,
                    },
                   er_settra_reemerging_faction_incident_2_vampire_coast = {
                        NumberOfTurns = 4,
                    },
                },
                wh_main_sc_vmp_vampire_counts = {
                   er_settra_reemerging_faction_incident_1_vampire_counts = {
                        NumberOfTurns = 1,
                    },
                    er_louen_reemerging_faction_incident_2_vampire_counts = {
                        NumberOfTurns = 4,
                    },
                },
                wh_dlc05_sc_wef_wood_elves = {
                   er_settra_reemerging_faction_incident_1_wood_elves = {
                        NumberOfTurns = 1,
                    },
                   er_settra_reemerging_faction_incident_2_wood_elves = {
                        NumberOfTurns = 4,
                    },
                },
            },
            AutoDilemmas = {
                --[[default = {
                    wh2_main_dilemma_treasure_hunt_spider_nest = {
                        NumberOfTurns = 10,
                    },
                },
                wh_main_sc_emp_empire = {
                    wh2_main_dilemma_treasure_hunt_the_underworld_sea = {
                        NumberOfTurns = 1,
                    },
                },--]]
            },
            AgentDeployDilemmas = {
                --[[default = {
                    wh2_main_dilemma_treasure_hunt_skaven_ambush = {
                        NumberOfTurns = 4,
                    },
                },--]]
            },
            Weighting = 0,
        },
    };
end