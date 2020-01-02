function GetVampireCountsRebelArmyArchetypesPoolDataResources()
    return {
        MasterNecromancer = {
            AgentSubtypes = {"vmp_master_necromancer", },
            UnitTags = {"Chaff", "Beasts", "Spirits",},
            Weighting = 3,
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
    };
end