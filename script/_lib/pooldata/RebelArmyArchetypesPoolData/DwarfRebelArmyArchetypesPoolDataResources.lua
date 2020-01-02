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
    };
end