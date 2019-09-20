function GetHighElfRebelArmyArchetypesPoolDataResources()
    return {
        wh2_main_sc_hef_high_elves = {
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
                UnitTags = {"Militia", "Cavalry", "Caledor" },
                Weighting = 0,
            },

            PrinceChracian = {
                AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
                UnitTags = {"Militia", "Cavalry", "Chracian" },
                Weighting = 0,
            },

            PrinceAvelorn = {
                AgentSubtypes = {"wh2_main_hef_prince", "wh2_main_hef_princess", },
                UnitTags = {"Militia", "Cavalry", "Avelorn" },
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
        },
    };
end