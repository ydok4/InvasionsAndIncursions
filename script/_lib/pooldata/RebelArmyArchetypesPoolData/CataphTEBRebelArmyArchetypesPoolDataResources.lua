function GetCataphTEBRebelArmyArchetypesPoolDataResources()
    return {
        wh_main_sc_teb_teb = {
            TEBGeneral = false;
            TEBGeneralDefault = {
                AgentSubtypes = { "teb_lord", },
                UnitTags = {"TEBStateTroops", {"BorderPrincesCavalry", "EstalianCavalry", "TileanCavalry", }, "Mercenary", },
                Weighting = 4,
            },
            BorderRanger = {
                AgentSubtypes = { "bor_ranger_lord", },
                UnitTags = {"TEBStateTroops", "BorderPrincesTroops", "BorderPrincesCavalry", "Mercenary", },
                Weighting = 1,
            },
            InquisitorLord = {
                AgentSubtypes = { "est_inquisitor", },
                UnitTags = {"TEBStateTroops", "EstalianTroops", "EstalianCavalry", "Mercenary", },
                Weighting = 1,
            },
            MerchantPrince = {
                AgentSubtypes = { "til_merchant", },
                UnitTags = {"TEBStateTroops", "TileanTroops", "TileanCavalry", "Mercenary", },
                Weighting = 1,
            },
        },
    };
end