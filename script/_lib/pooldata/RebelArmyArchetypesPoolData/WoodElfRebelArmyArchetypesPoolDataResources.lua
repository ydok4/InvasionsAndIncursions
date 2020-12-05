function GetWoodElfRebelArmyArchetypesPoolDataResources()
    return {
        GladeLords = {
            AgentSubtypes = {"dlc05_wef_glade_lord", "dlc05_wef_glade_lord_fem", },
            UnitTags = {"GladeGuard", "EternalGuard", "GladeRiders", },
            Weighting = 3,
        },
        SpellWeavers = {
            AgentSubtypes = {"wh2_dlc16_wef_spellweaver_beasts", "wh2_dlc16_wef_spellweaver_dark", "wh2_dlc16_wef_spellweaver_high", "wh2_dlc16_wef_spellweaver_life", "wh2_dlc16_wef_spellweaver_shadows",  },
            UnitTags = {"GladeGuard", "EternalGuard", "GladeRiders", "TreeSpirits", },
            Weighting = 1,
        },
    };
end