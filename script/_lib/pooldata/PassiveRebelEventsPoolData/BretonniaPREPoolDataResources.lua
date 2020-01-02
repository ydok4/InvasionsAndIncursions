function GetBretonniaPREPoolDataResources()
    return {
        ReemergeanceArchetypeCouronne = {
            MinimumRequriedPublicOrder = -99,
            PRESubculture = "wh_main_sc_brt_bretonnia",
            ArmyArchetypes = {"LouenReemerge", },
            CleanUpRebelForce = false,
            EffectBundleKey = "er_effect_bundle_generic_incursion_region",
            EffectBundleEffects = {
                wh_main_effect_public_order_events = -5,
            },
            PREDuration = 5,
            InitialRebellionIncident = {
                default = "poe_generic_incursion",
                wh_main_sc_emp_empire = "er_louen_reemerging_faction_incident_3_generic",
            },
            TriggerArmySpawnWhenPREEnds = true,
            OverrideSpawnRegion = nil,
            OverrideTargetRegion = {
                main_warhammer = "wh_main_couronne_et_languille_couronne",
                wh2_main_great_vortex = nil,
            },
            Incidents = {
                default = {
                    er_louen_reemerging_faction_incident_1_empire = {
                        NumberOfTurns = 10,
                    },
                },
                wh_main_sc_emp_empire = {
                    er_louen_reemerging_faction_incident_1_empire = {
                        NumberOfTurns = 1,
                    },
                    er_louen_reemerging_faction_incident_2_empire = {
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
                wh_main_sc_emp_empire = {
                    poe_deploy_agents_louen_reemerging_faction_dilemma_1_empire = {
                        NumberOfTurns = 4,
                    },
                },
            },
            Weighting = 0,
        },
    };
end