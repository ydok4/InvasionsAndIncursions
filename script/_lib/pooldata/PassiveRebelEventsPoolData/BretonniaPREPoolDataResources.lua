function GetBretonniaPREPoolDataResources()
    return {
        wh_main_sc_brt_bretonnia = {
            ReemergeanceArchetypeCouronne = {
                MinimumRequriedPublicOrder = -99,
                ArmyArchetypes = {"LouenReemerge", },
                CleanUpRebelForce = false,
                EffectBundleKey = "er_effect_bundle_generic_incursion_region",
                EffectBundleEffects = {
                    wh_main_effect_public_order_events = -5,
                },
                PREDuration = 5,
                InitialRebellionIncident = {
                    default = "er_generic_incursion",
                    wh_main_sc_emp_empire = "er_generic_incursion",
                },
                TriggerRebellionWhenPREEnds = true,
                Incidents = {
                    default = {
                        er_generic_incursion = {
                            NumberOfTurns = 10,
                        },
                    },
                    wh_main_sc_emp_empire = {
                        er_generic_incursion = {
                            NumberOfTurns = 10,
                        },
                    },
                },
                AutoDilemmas = {
                    default = {
                        wh2_main_dilemma_treasure_hunt_spider_nest = {
                            NumberOfTurns = 10,
                        },
                    },
                    wh_main_sc_emp_empire = {
                        wh2_main_dilemma_treasure_hunt_the_underworld_sea = {
                            NumberOfTurns = 1,
                        },
                    },
                },
                AgentDeployDilemmas = {
                    default = {
                        wh2_main_dilemma_treasure_hunt_skaven_ambush = {
                            NumberOfTurns = 10,
                        },
                    },
                    wh_main_sc_emp_empire = {
                        wh2_main_dilemma_treasure_hunt_slaanesh_fungi = {
                            NumberOfTurns = 2,
                        },
                    },
                },
                Weighting = 0,
            },
        },
    };
end