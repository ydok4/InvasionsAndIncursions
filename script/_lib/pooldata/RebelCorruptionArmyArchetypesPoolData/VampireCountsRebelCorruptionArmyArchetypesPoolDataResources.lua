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
            MasterNecromancer = {
                CorruptionThreshold = 20,
                AgentSubtypes = {"vmp_master_necromancer", },
                MandatoryUnits = {
                    wh_dlc04_vmp_veh_corpse_cart_2 = 1,
                },
                UnitTags = {"Chaff", "Beasts", "Spirits",},
                ArmySize = 13,
                Weighting = 2,
            },
            StrigoiGhoulKing = {
                CorruptionThreshold = 40,
                AgentSubtypes = {"dlc04_vmp_strigoi_ghoul_king", },
                MandatoryUnits = {
                    wh_main_vmp_mon_crypt_horrors = 2,
                },
                UnitTags = {"Ghouls", "Beasts", },
                ArmySize = 17,
                Weighting = 1,
            },
            VampireLord = {
                CorruptionThreshold = 50,
                AgentSubtypes = {"vmp_lord", },
                MandatoryUnits = {
                    wh_dlc02_vmp_cav_blood_knights_0 = 1,
                },
                UnitTags = {"Chaff", "GraveGuard", "VampiricBeasts"},
                ArmySize = 20,
                Weighting = 1,
            },
        },
    };
end