function GetBeastmenRebelArmyArchetypesPoolDataResources()
    return {
        BeastLord = {
            AgentSubtypes = {"dlc03_bst_beastlord", },
            UnitTags = {"Ungors", "Gors", "WarBeasts", },
            Weighting = 5,
        },
        GreatBrayShaman = {
            AgentSubtypes = {"wh2_twa04_bst_great_bray_shaman_beasts", "wh2_twa04_bst_great_bray_shaman_death", "wh2_twa04_bst_great_bray_shaman_shadows", "wh2_twa04_bst_great_bray_shaman_wild", },
            UnitTags = {"Gors", "Monsters", },
            Weighting = 2,
        },
        DoomBull = {
            AgentSubtypes = {"wh2_dlc17_bst_doombull", },
            MandatoryUnits = {
                wh_dlc03_bst_inf_minotaurs_0 = 1,
            },
            UnitTags = {"Gors", "WarBeasts", "Minotaurs" },
            Weighting = 1,
        },
    };
end