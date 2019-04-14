AreaPoolData = {
    main_warhammer = {
        NorthernBretonnia = {
            StartingTurn = 1,
            ReoccurrenceThreshold = nil,
            Events = {
                Incursions = {
                    GoblinIncursion = {
                        SpawnLocations = { "ForestOfArden", },
                        TargetRegions = {"wh_main_couronne_et_languille_couronne", "wh_main_lyonesse_lyonesse"},
                        OccurenceModifier = 0,
                    },
                },
                Invasions = {
                    EarlyNorsca = {
                        SpawnLocations = { "SeaOfClaws", },
                        TargetRegions = {"wh_main_couronne_et_languille_couronne", "wh_main_lyonesse_lyonesse"},
                        OccurenceModifier = 20,
                    },
                },
            },
        },
        --[[SouthernBretonnia = {

        },--]]
    },
    wh2_main_great_vortex = {

    },
}