AreaPoolData = {
    main_warhammer = {
        NorthernBretonnia = {
            Events = {
                Incursions = {
                    goblins = {
                        SpawnLocations = { "ForestOfArden", },
                        TargetRegions = {"wh_main_couronne_et_languille_couronne", "wh_main_lyonesse_lyonesse"},
                        SubcultureTargets = {"wh_main_sc_brt_bretonnia", },
                        Weighting = 5,
                        NarrativeData = {
                        },
                    },
                    beastmen_basic = {
                        SpawnLocations = { "ForestOfArden", },
                        TargetRegions = {"wh_main_couronne_et_languille_couronne", "wh_main_lyonesse_lyonesse"},
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                    dark_elf_raiders = {
                        SpawnLocations = { "TheGreatOcean", },
                        TargetRegions = {"wh_main_couronne_et_languille_couronne", "wh_main_lyonesse_lyonesse"},
                        Weighting = 8,
                        NarrativeData = {
                        },
                    },
                },
                Invasions = {
                    greenskin_minor = {
                        SpawnLocations = { "ForestOfArden", },
                        TargetRegions = {"wh_main_couronne_et_languille_couronne", "wh_main_lyonesse_lyonesse"},
                        SubcultureTargets = {"wh_main_sc_brt_bretonnia", },
                        Weighting = 5,
                    },
                    norsca_minor = {
                        SpawnLocations = { "SeaOfClaws", },
                        TargetRegions = {"wh_main_couronne_et_languille_couronne", "wh_main_lyonesse_lyonesse"},
                        SubcultureTargets = {"wh_main_sc_brt_bretonnia", },
                        Weighting = 5,
                    },
                },
            },
        },
        SouthernBretonnia = {
            Events = {
                Incursions = {
                    goblins = {
                        SpawnLocations = { "MassifOrcal", },
                        TargetRegions = {"wh_main_carcassone_et_brionne_castle_carcassonne", "wh_main_bordeleaux_et_aquitaine_bordeleaux", "wh_main_parravon_et_quenelles_parravon", "wh_main_bastonne_et_montfort_castle_bastonne",},
                        SubcultureTargets = {"wh_main_sc_brt_bretonnia", },
                        Weighting = 5,
                        NarrativeData = {
                        },
                    },
                    beastmen_basic = {
                        SpawnLocations = { "ForestOfChalons", },
                        TargetRegions = {"wh_main_bordeleaux_et_aquitaine_bordeleaux", "wh_main_parravon_et_quenelles_parravon", "wh_main_bastonne_et_montfort_castle_bastonne",},
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                    dark_elf_raiders = {
                        SpawnLocations = { "EasternStraitsOfGreatOcean", },
                        TargetRegions = {"wh_main_carcassone_et_brionne_castle_carcassonne", "wh_main_bordeleaux_et_aquitaine_bordeleaux"},
                        Weighting = 8,
                        NarrativeData = {
                        },
                    },
                },
                Invasions = {
                    greenskin_minor = {
                        SpawnLocations = { "MassifOrcal", },
                        TargetRegions = {"wh_main_carcassone_et_brionne_castle_carcassonne", "wh_main_bordeleaux_et_aquitaine_bordeleaux", "wh_main_parravon_et_quenelles_parravon", "wh_main_bastonne_et_montfort_castle_bastonne",},
                        SubcultureTargets = {"wh_main_sc_brt_bretonnia", },
                        Weighting = 20,
                    },
                    norsca_minor = {
                        SpawnLocations = { "EasternStraitsOfGreatOcean", },
                        TargetRegions = {"wh_main_carcassone_et_brionne_castle_carcassonne", "wh_main_bordeleaux_et_aquitaine_bordeleaux", },
                        SubcultureTargets = {"wh_main_sc_brt_bretonnia", },
                        Weighting = 5,
                    },
                },
            },
        },

        -- Empire Forests
        ReikwaldForest = {
            Events = {
                Incursions = {
                    beastmen_basic = {
                        SpawnLocations = { "ReikwaldForest", },
                        TargetRegions = {"wh_main_reikland_grunburg", },
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                    necromancer_basic = {
                        SpawnLocations = { "ReikwaldForest", },
                        TargetRegions = {"wh_main_reikland_grunburg", },
                        Weighting = 3,
                        NarrativeData = {
                        },
                    },
                    ghoul_king= {
                        SpawnLocations = { "ReikwaldForest", },
                        TargetRegions = {"wh_main_reikland_grunburg", },
                        Weighting = 1,
                        NarrativeData = {
                        },
                    },
                    goblins = {
                        SpawnLocations = { "ReikwaldForest", },
                        TargetRegions = {"wh_main_reikland_grunburg", },
                        Weighting = 5,
                        NarrativeData = {
                        },
                    },
                },
            },
        },
        DrakwaldForest = {
            Events = {
                Incursions = {
                    beastmen_basic = {
                        SpawnLocations = { "DrakwaldForest", },
                        TargetRegions = {"wh_main_middenland_weismund", },
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                    necromancer_basic = {
                        SpawnLocations = { "DrakwaldForest", },
                        TargetRegions = {"wh_main_middenland_weismund", },
                        Weighting = 3,
                        NarrativeData = {
                        },
                    },
                    ghoul_king = {
                        SpawnLocations = { "DrakwaldForest", },
                        TargetRegions = {"wh_main_middenland_weismund", },
                        Weighting = 1,
                        NarrativeData = {
                        },
                    },
                    goblins = {
                        SpawnLocations = { "DrakwaldForest", },
                        TargetRegions = {"wh_main_middenland_weismund", },
                        Weighting = 5,
                        NarrativeData = {
                        },
                    },
                },
            },
        },
        ForestOfShadowsEmpire = {
            Events = {
                Incursions = {
                    beastmen_basic = {
                        SpawnLocations = { "ForestOfShadowsEmpire", },
                        TargetRegions = {"wh_main_ostland_norden", },
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                    necromancer_basic = {
                        SpawnLocations = { "ForestOfShadowsEmpire", },
                        TargetRegions = {"wh_main_ostland_norden", },
                        Weighting = 3,
                        NarrativeData = {
                        },
                    },
                    ghoul_king = {
                        SpawnLocations = { "ForestOfShadowsEmpire", },
                        TargetRegions = {"wh_main_ostland_norden", },
                        Weighting = 1,
                        NarrativeData = {
                        },
                    },
                    goblins = {
                        SpawnLocations = { "ForestOfShadowsEmpire", },
                        TargetRegions = {"wh_main_ostland_norden", },
                        Weighting = 5,
                        NarrativeData = {
                        },
                    },
                },
            },
        },
        ForestOfShadowsKislev = {
            Events = {
                Incursions = {
                    beastmen_basic = {
                        SpawnLocations = { "ForestOfShadowsKislev", },
                        TargetRegions = {"wh_main_southern_oblast_kislev", },
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                    necromancer_basic = {
                        SpawnLocations = { "ForestOfShadowsKislev", },
                        TargetRegions = {"wh_main_southern_oblast_kislev", },
                        Weighting = 3,
                        NarrativeData = {
                        },
                    },
                    ghoul_king = {
                        SpawnLocations = { "ForestOfShadowsKislev", },
                        TargetRegions = {"wh_main_southern_oblast_kislev", },
                        Weighting = 2,
                        NarrativeData = {
                        },
                    },
                    goblins = {
                        SpawnLocations = { "ForestOfShadowsKislev", },
                        TargetRegions = {"wh_main_southern_oblast_kislev", },
                        Weighting = 5,
                        NarrativeData = {
                        },
                    },
                },
            },
        },
        TheGreatForest = {
            Events = {
                Incursions = {
                    beastmen_basic = {
                        SpawnLocations = { "TheGreatForest", },
                        TargetRegions = {"wh_main_talabecland_talabheim", },
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                    necromancer_basic = {
                        SpawnLocations = { "TheGreatForest", },
                        TargetRegions = {"wh_main_talabecland_talabheim", },
                        Weighting = 3,
                        NarrativeData = {
                        },
                    },
                    ghoul_king = {
                        SpawnLocations = { "TheGreatForest", },
                        TargetRegions = {"wh_main_talabecland_talabheim", },
                        Weighting = 1,
                        NarrativeData = {
                        },
                    },
                    goblins = {
                        SpawnLocations = { "TheGreatForest", },
                        TargetRegions = {"wh_main_talabecland_talabheim", },
                        Weighting = 5,
                        NarrativeData = {
                        },
                    },
                },
            },
        },

        TheWasteland = {
            Events = {
                Incursions = {
                    beastmen_basic = {
                        SpawnLocations = { "DrakwaldForest", },
                        TargetRegions = {"wh_main_the_wasteland_gorssel", },
                        Weighting = 10,
                        NarrativeData = {
                        },
                    },
                },
                Invasions = {
                    norsca_minor = {
                        SpawnLocations = { "SeaOfClaws", },
                        TargetRegions = {"wh_main_the_wasteland_marienburg", },
                        Weighting = 5,
                    },
                },
            },
        },

        -- Naggaroth Chaos Wastes
        NaggarothChaosWastes = {
            Events = {
                Incursions = nil,
                Invasions = {
                    norsca_minor = {
                        SpawnLocations = { "IronFrostGlacier", },
                        TargetRegions = {"wh2_main_iron_mountains_naggarond", "wh2_main_the_road_of_skulls_har_ganeth", },
                        Weighting = 10,
                    },
                },
            },
        },

        -- Southlands
        EasternSouthlandsJungles = {
            Events = {
                Incursions = nil,
                Invasions = {
                    lizardmen_minor = {
                        SpawnLocations = { "TempleOfSkulls",  "Teotiqua"},
                        TargetRegions = {"wh2_main_crater_of_the_walking_dead_rasetra", "wh2_main_the_road_of_skulls_har_ganeth", },
                        Weighting = 3,
                    },
                    savage_orcs = {
                        SpawnLocations = { "TempleOfSkulls",  "Teotiqua"},
                        TargetRegions = {"wh2_main_crater_of_the_walking_dead_rasetra", "wh2_main_the_road_of_skulls_har_ganeth", },
                        Weighting = 7,
                    },
                },
            },
        },

        -- Lustria
        CentralLustria = {
            Events = {
                Incursions = {
                    feral_beasts = {
                        SpawnLocations = { "CentralLustria",  },
                        TargetRegions = {"wh2_main_northern_great_jungle_xahutec", "wh2_main_southern_great_jungle_itza", },
                        Weighting = 1,
                    },
                },
                Invasions = {
                    savage_orcs = {
                        SpawnLocations = { "CentralLustria"},
                        TargetRegions = {"wh2_main_northern_great_jungle_xahutec", "wh2_main_southern_great_jungle_itza", },
                        Weighting = 10,
                    },
                },
            },
        },

        -- Naggaroth
        MountainsOfNaggaroth = {
            Events = {
                Incursions = {
                    beastmen_basic = {
                        SpawnLocations = { "NaggarothMountains",  },
                        TargetRegions = {"wh2_main_doom_glades_hag_hall", "wh2_main_obsidian_peaks_clar_karond", },
                        Weighting = 10,
                    },
                },
                Invasions = nil;
            },
        },
    },
    wh2_main_great_vortex = {
        -- Naggaroth Chaos Wastes
        NaggarothChaosWastes = {
            Events = {
                Incursions = nil,
                Invasions = {
                    norsca_minor = {
                        SpawnLocations = { "IronFrostGlacier", },
                        TargetRegions = {"wh2_main_vor_naggarond_naggarond", "wh2_main_vor_the_road_of_skulls_har_ganeth", },
                        Weighting = 10,
                    },
                },
            },
        },
    },
}