function GetVampireCountsRebelArmyArchetypesPoolDataResources()
    return {
        MasterNecromancer = {
            AgentSubtypes = {"vmp_master_necromancer", },
            UnitTags = {"Chaff", "Beasts", "Spirits",},
            Weighting = 4,
        },
        StrigoiGhoulKing = {
            AgentSubtypes = {"dlc04_vmp_strigoi_ghoul_king", },
            UnitTags = {"Ghouls", "Beasts", },
            Weighting = 1,
        },
        VampireLord = {
            AgentSubtypes = {"vmp_lord", },
            UnitTags = {"Chaff", "GraveGuard", "VampiricBeasts"},
            Weighting = 1,
        },
        MannfredReemerge = {
            RebellionFaction = "wh_main_vmp_vampire_counts",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                vmp_mannfred_von_carstein = {
                    AgentSubtypeKey = "vmp_mannfred_von_carstein",
                },
            },
            MandatoryUnits = {
                wh_main_vmp_mon_varghulf = 1,
                wh_dlc02_vmp_cav_blood_knights_0 = 1,
            },
            UnitTags = {"Chaff", "GraveGuard", "VampiricBeasts"},
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = {"wh_main_eastern_sylvania_castle_drakenhof", },
                wh2_main_great_vortex = nil,
            },
        },
        VampireNecrarch = {
            AgentSubtypes = {"wh2_dlc11_vmp_bloodline_necrarch", },
            UnitTags = {"Chaff", "GraveGuard", "VampiricBeasts"},
            Weighting = 0,
        },
    };
end