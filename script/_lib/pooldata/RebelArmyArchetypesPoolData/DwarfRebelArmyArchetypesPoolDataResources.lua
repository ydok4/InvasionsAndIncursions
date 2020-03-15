function GetDwarfRebelArmyArchetypesPoolDataResources()
    return {
        DwarfLord = {
            AgentSubtypes = {"dwf_lord", },
            UnitTags = {"Warriors", "RangedInfantry", "Rangers", },
            Weighting = 3,
        },
        Slayers = {
            AgentSubtypes = {"dwf_lord", },
            UnitTags = {"Slayers", },
            MandatoryUnits = {
                wh2_dlc10_dwf_inf_giant_slayers = 2,
            },
            Weighting = 0,
        },
        ThorgrimReemerge = {
            RebellionFaction = "wh_main_dwf_dwarfs",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                dwf_thorgrim_grudgebearer = {
                    AgentSubtypeKey = "dwf_thorgrim_grudgebearer",
                },
            },
            MandatoryUnits = {
                wh_main_dwf_inf_hammerers = 2,
                wh_main_dwf_inf_ironbreakers = 1,
            },
            UnitTags = {"Warriors", "RangedInfantry", "Artillery", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh_main_the_silver_road_karaz_a_karak", },
                wh2_main_great_vortex = nil,
            },
        },
    };
end