function GetDecoKislevRebelArmyArchetypesPoolDataResources()
    return {
        KislevGeneral = false;
        KislevVoevoda = {
            AgentSubtypes = { "wh2_deco_voevoda", },
            UnitTags = {"DecoKossarInfantry", "DecoCavalry", {"DecoArtillery", "DecoCheckists", }, },
            Weighting = 4,
        },
        KislevUngol = {
            AgentSubtypes = { "wh2_deco_warlord", },
            UnitTags = {"DecoUngol", "DecoCavalry", {"DecoArtillery", "DecoCheckists", }, },
            Weighting = 2,
        },
    };
end