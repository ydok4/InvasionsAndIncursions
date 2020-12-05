function GetSkavenRebelArmyArchetypesPoolDataResources()
    return {
        SkavenWarlord = {
            AgentSubtypes = {"wh2_main_skv_warlord", },
            UnitTags = {"SkavenSlaves", "Warriors", },
            Weighting = 5,
        },
        --[[SkavenSlaves = {
            AgentSubtypes = {"wh2_main_skv_warlord", },
            UnitTags = {"SkavenSlaves", },
            Weighting = 2,
        },--]]
        ClanEshin = {
            AgentSubtypes = {"wh2_dlc14_skv_master_assassin", },
            MandatoryUnits = {
                wh2_main_skv_inf_death_runners_0 = 1,
            },
            UnitTags = {"SkavenSlaves", "Warriors", "ClanEshin", },
            Weighting = 1,
        },
        ClanMoulder = {
            AgentSubtypes = {"wh2_main_skv_warlord", },
            MandatoryUnits = {
                wh2_dlc16_skv_mon_rat_ogre_mutant = 1,
            },
            UnitTags = {"SkavenSlaves", "Warriors", "ClanMoulder", },
            Weighting = 1,
        },
        ClanSkryre = {
            AgentSubtypes = {"wh2_main_skv_warlord",  "wh2_dlc12_skv_warlock_master", },
            MandatoryUnits = {
                { wh2_main_skv_inf_warpfire_thrower = 1, wh2_main_skv_inf_poison_wind_globadiers = 1 },
            },
            UnitTags = {"SkavenSlaves", "Warriors", "ClanSkyre",},
            Weighting = 1,
        },
        StormVermin = {
            AgentSubtypes = {"wh2_main_skv_warlord", "wh2_main_skv_grey_seer_plague", "wh2_main_skv_grey_seer_ruin", },
            MandatoryUnits = {
                wh2_main_skv_inf_stormvermin_0 = 2,
                wh2_main_skv_inf_stormvermin_1 = 1,
            },
            UnitTags = {"SkavenSlaves", "Warriors", },
            Weighting = 0,
        },
        ClanPestilens = {
            AgentSubtypes = {"wh2_main_skv_warlord", },
            UnitTags = {"SkavenSlaves", "Warriors", "ClanPestilens"},
            Weighting = 1,
        },
        ClanPestilensChaosInvasionStage2 = {
            AgentSubtypes = {"wh2_main_skv_warlord", },
            MandatoryUnits = {
                wh2_main_skv_inf_plague_monk_censer_bearer = 2,
                wh2_main_skv_art_plagueclaw_catapult = 1,
            },
            UnitTags = {"SkavenSlaves", "Warriors", "ClanPestilens"},
            Weighting = 0,
        },
        IkitClawReemerge = {
            RebellionFaction = "wh2_main_skv_clan_skyre",
            SpawnWithExistingCharacter = true,
            AgentSubtypes = {
                wh2_dlc12_skv_ikit_claw = {
                    AgentSubtypeKey = "wh2_dlc12_skv_ikit_claw",
                },
            },
            MandatoryUnits = {
                wh2_main_skv_inf_stormvermin_0 = 2,
                wh2_main_skv_inf_stormvermin_1 = 2,
                wh2_dlc12_skv_inf_warplock_jezzails_0 = 1,
                wh2_main_skv_art_warp_lightning_cannon = 1,
            },
            UnitTags = {"Warriors", "ClanSkyre", },
            ArmySize = 18,
            Weighting = 0,
            OverrideSpawnRegion = {
                main_warhammer = { "wh2_main_skavenblight_skavenblight", },
                wh2_main_great_vortex = nil,
            },
        },
    };
end