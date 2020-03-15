function GetHighElfRebelArmyArchetypesPoolDataResources()
    return {
        Prince = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", },
            Weighting = 4,
        },

        PrinceShadowWarriors = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", "ShadowWarriors", },
            Weighting = 1,
        },

        PrinceEllyrion = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", "Ellyrion" },
            Weighting = 0,
        },

        PrinceCaledor = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", "Caledor", "Beasts", },
            Weighting = 0,
        },

        PrinceChracian = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", "Chracian" },
            Weighting = 0,
        },

        PrinceAvelorn = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", "Avelorn", "Beasts", },
            Weighting = 0,
        },

        PrinceLothern = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", "Lothern" },
            Weighting = 0,
        },

        PrinceSaphery = {
            AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
            UnitTags = {"Militia", "Cavalry", "Saphery" },
            Weighting = 0,
        },

        TyrionReemerge = {
            RebellionFaction = "wh2_main_hef_eataine",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                wh2_main_hef_tyrion = {
                    AgentSubtypeKey = "wh2_main_hef_tyrion",
                },
            },
            MandatoryUnits = {
                wh2_dlc10_hef_inf_sisters_of_avelorn_0 = 1,
                wh2_main_hef_mon_phoenix_flamespyre = 1,
                wh2_main_hef_cav_ellyrian_reavers_1 = 2,
                wh2_main_hef_cav_dragon_princes = 1,
                wh2_main_hef_inf_white_lions_of_chrace_0 = 1,
                wh2_main_hef_inf_phoenix_guard = 1,
                wh2_main_hef_inf_swordmasters_of_hoeth_0 = 1,
            },
            UnitTags = {"Militia", "Cavalry", "Lothern", "Beasts", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh2_main_eataine_lothern", },
                wh2_main_great_vortex = { "wh2_main_vor_straits_of_lothern_lothern", },
            },
        },
    };
end