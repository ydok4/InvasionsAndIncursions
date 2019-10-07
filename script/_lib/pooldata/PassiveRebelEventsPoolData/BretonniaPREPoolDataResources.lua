function GetBretonniaPREPoolDataResources()
    return {
        wh_main_sc_brt_bretonnia = {
            wh_main_sc_brt_bretonnia = {
                ReemergeanceArchetypeCouronne = {
                    MinimumRequriedPublicOrder = -100,
                    ArmyArchetypes = {"LouenReemerge", },
                    CleanUpRebelForce = false,
                    EffectBundleKey = "er_effect_bundle_generic_incursion_region",
                    EffectBundleEffects = {
                        wh_main_effect_public_order_events = -5,
                    },
                    EffectBundleDuration = 1,
                    InitialRebellionIncident = "er_generic_incursion";
                    TriggerRebellionWhenPREEnds = true,
                    Incidents = {
                        incident_example_key_1 = {
                            NumberOfTurns = 10,
                        },
                    },
                    Dilemmas = {
                        dilemma_example_key_1 = {
                            NumberOfTurns = 15,
                        },
                    },
                    Weighting = 0,
                },
            },
        },
    };
end