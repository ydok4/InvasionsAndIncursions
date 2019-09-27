function GetVampireCountsRebelCorruptionArmyArchetypesPoolDataResources() 
    return {
        wh_main_sc_vmp_vampire_counts_corruption = {
            MasterNecromancerDefault = {
                CorruptionThreshold = 0,
                AgentSubtypes = {"vmp_master_necromancer", },
                MandatoryUnits = {
                    wh_dlc04_vmp_veh_corpse_cart_1 = 1,
                },
                UnitTags = {"Chaff", "Beasts", "Spirits",},
                ArmySize = 13,
                Weighting = 3,
            },
            MasterNecromancerLow = {
                CorruptionThreshold = 30,
                AgentSubtypes = {"vmp_master_necromancer", },
                MandatoryUnits = {
                    wh_dlc04_vmp_veh_corpse_cart_2 = 1,
                },
                UnitTags = {"Chaff", "Beasts", "Spirits",},
                ArmySize = 13,
                Weighting = 2,
            },
            MasterNecromancerMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"vmp_master_necromancer", },
                MandatoryUnits = {
                    wh_main_vmp_inf_cairn_wraiths = 1,
                    wh_dlc04_vmp_veh_mortis_engine_0 = 1,
                },
                UnitTags = {"Chaff", "Beasts", "Spirits",},
                ArmySize = 17,
                Weighting = 3,
            },
            StrigoiGhoulKingMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"dlc04_vmp_strigoi_ghoul_king", },
                MandatoryUnits = {
                    wh_main_vmp_mon_crypt_horrors = 1,
                },
                UnitTags = {"Ghouls", "Beasts", },
                ArmySize = 17,
                Weighting = 1,
            },
            VampireLordMedium = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"vmp_lord", },
                MandatoryUnits = {
                    wh_main_vmp_cav_black_knights_3 = 1,
                },
                UnitTags = {"Chaff", "GraveGuard", "BlackKnights", "VampiricBeasts"},
                ArmySize = 20,
                Weighting = 1,
            },
            VonCarsteinHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_dlc11_vmp_bloodline_von_carstein", },
                MandatoryUnits = {
                    wh_main_vmp_mon_vargheists = 1,
                    wh_main_vmp_mon_varghulf = 1,
                },
                UnitTags = {"Chaff", "GraveGuard", "BlackKnights", "VampiricBeasts"},
                ArmySize = 20,
                Weighting = 1,
            },
            BloodDragonHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_dlc11_vmp_bloodline_blood_dragon", },
                MandatoryUnits = {
                    wh_dlc02_vmp_cav_blood_knights_0 = 1,
                },
                UnitTags = {"Chaff", "GraveGuard", "BloodKnights"},
                ArmySize = 20,
                Weighting = 1,
            },
            StrigoiHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_dlc11_vmp_bloodline_strigoi", },
                MandatoryUnits = {
                    wh_main_vmp_mon_crypt_horrors = 2,
                },
                UnitTags = {"Chaff", "GraveGuard", "Ghouls"},
                ArmySize = 20,
                Weighting = 1,
            },
            LahmianHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_dlc11_vmp_bloodline_lahmian", },
                MandatoryUnits = {
                    wh_main_vmp_veh_black_coach = 1,
                },
                UnitTags = {"Chaff", "GraveGuard", "BlackKnights", "VampiricBeasts"},
                ArmySize = 20,
                Weighting = 1,
            },
            NecrarchHigh = {
                CorruptionThreshold = 75,
                AgentSubtypes = {"wh2_dlc11_vmp_bloodline_necrarch", },
                MandatoryUnits = {
                    wh_main_vmp_inf_cairn_wraiths = 2,
                    wh_main_vmp_mon_terrorgheist = 1,
                },
                UnitTags = {"Chaff", "Beasts", "GraveGuard", "VampiricBeasts"},
                ArmySize = 20,
                Weighting = 1,
            },
        },
    };
end