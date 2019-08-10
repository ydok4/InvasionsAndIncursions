function GetGreenskinRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_grn_greenskins = {
            NightGoblinWarboss = {
                AgentSubtypes = {"dlc06_grn_night_goblin_warboss", },
                UnitTags = {"Goblins", "NightGoblins", "Squigs", },
                Weighting = 1,
            },
            GoblinGreatShaman = {
                AgentSubtypes = {"grn_goblin_great_shaman", },
                UnitTags = {"Goblins", "ForestGoblins", "Artillery", },
                Weighting = 1,
            },
            OrcWarboss = {
                AgentSubtypes = {"grn_orc_warboss", },
                UnitTags = {"Orcs", "Monsters", },
                Weighting = 2,
            },
        },
    };
end