local m_oxyotl_faction_key = "wh2_dlc17_lzd_oxyotl"

local m_threat_map_missions_started = false

local m_mission_wave_details = {
	-- config table to control the size and speed of mission waves once the feature is active.
	mission_count = {
		min = 3,
		max = 4
	},
	mission_type_limits = {
		herdstone = {max = 1, current = 0},
		norsca_region = {max = 1, current = 0},
		chaos_army = {max = 2, current = 0},
		corrupted_army = {max = 2, current = 0},
		region_marker = {max = 1, current = 0},
		spawned_army = {max = 1, current = 0},
		sanctum_defence = {max = 1, current = 0}
	},
	cooldown = {
		min = 11,
		max = 15,
		current = 0
	},
	incident_key = "wh2_dlc17_lzd_oxyotl_new_threat_map_mission",
	incident_fired_this_turn = false
}

local m_beastmen_culture = "wh_dlc03_bst_beastmen"
local m_chaos_culture = "wh_main_chs_chaos"
local m_norsca_culture = "wh_dlc08_nor_norsca"

local m_skaven_culture = "wh2_main_skv_skaven"
local m_vamp_count_culture = "wh_main_vmp_vampire_counts"
local m_vamp_coast_culture = "wh2_dlc11_cst_vampire_coast"
local m_cult_of_pleasure_faction_key = "wh2_main_def_cult_of_pleasure"

local m_dilemma_region_attack = "wh2_dlc17_threat_map_region_raze"
local m_region_marker_id = "oxy_region_marker_mission"
local m_region_razed_marker = false
local m_dilemma_sanctum_attack = "wh2_dlc17_threat_map_sanctum_attack"
local m_sanctum_marker_id = "oxy_sanctum_marker_mission"
local m_sanctum_marker = false
local m_latest_marker_interaction_cqi = false
local m_scripted_battle_active = {active = false, mission_key = nil, mission_id = nil}

local m_invasion_count = 0
local m_chaos_force_details = {
	{template_key = "wh_main_sc_chs_chaos", faction_key = "wh_main_chs_chaos_qb1", general_subtype = "chs_lord", subculture = "wh_main_sc_chs_chaos"},
	{template_key = "wh_dlc03_sc_bst_beastmen", faction_key = "wh2_main_bst_blooded_axe", general_subtype = "dlc03_bst_beastlord", subculture = "wh_dlc03_sc_bst_beastmen"},
	{template_key = "wh_main_sc_nor_norsca", faction_key = "wh2_dlc17_nor_deadwood_ravagers", general_subtype = "nor_marauder_chieftain", subculture = "wh_main_sc_nor_norsca"}
}

local m_force_difficulty_values = {
	easy = {strength_min = 100000, strength_max = 500000, force_size = {min = 5, max = 8}, force_power = {min = 5, max = 8}, can_be_leader = true},
	medium = {strength_min = 500001, strength_max = 800000, force_size = {min = 10, max = 13}, force_power = {min = 10, max = 13}, can_be_leader = true},
	hard = {strength_min = 800001, strength_max = nil, force_size = {min = 15, max = 18}, force_power = {min = 15, max = 18}, can_be_leader = true}
}

local m_active_mission_details = {}
local m_active_mission_consequences = {}
local m_active_mission_rewards = {}
local m_oxyotl_mission_keys = {
	starting = "wh2_dlc17_oxyotl_chaos_map_dummy_mission_starting",
	easy = {
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_easy_1",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_easy_2",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_easy_3",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_easy_4",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_easy_5"
	},
	medium = {
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_med_1",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_med_2",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_med_3",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_med_4",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_med_5"
	},
	hard = {
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_hard_1",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_hard_2",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_hard_3",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_hard_4",
		"wh2_dlc17_oxyotl_chaos_map_dummy_mission_hard_5"
	}
}
local m_oxyotl_final_battle_key = "wh2_dlc17_qb_lzd_final_battle_oxyotl";
local m_oxyotl_movie_path = "warhammer2/silence/";

local m_blessed_spawning_mission_rewards = {
	easy = {
		{unit_key = "wh2_main_lzd_inf_skink_skirmishers_blessed_0", min = 2, max = 3},
		{unit_key = "wh2_main_lzd_inf_chameleon_skinks_blessed_0", min = 2, max = 3},
		{unit_key = "wh2_main_lzd_cav_horned_ones_blessed_0", min = 2, max = 3},
		{unit_key = "wh2_main_lzd_cav_terradon_riders_blessed_1", min = 2, max = 3}
	},
	medium = {
		{unit_key = "wh2_main_lzd_inf_saurus_warriors_blessed_1", min = 1, max = 3},
		{unit_key = "wh2_main_lzd_inf_saurus_spearmen_blessed_1", min = 1, max = 3},
		{unit_key = "wh2_main_lzd_cav_cold_one_spearriders_blessed_0", min = 1, max = 3},
		{unit_key = "wh2_main_lzd_mon_kroxigors_blessed", min = 1, max = 3},
		{unit_key = "wh2_main_lzd_mon_bastiladon_blessed_2", min = 1, max = 3}
	},
	hard = {
		{unit_key = "wh2_main_lzd_inf_temple_guards_blessed", min = 1, max = 2},
		{unit_key = "wh2_main_lzd_mon_carnosaur_blessed_0", min = 1, max = 2},
		{unit_key = "wh2_main_lzd_mon_stegadon_blessed_1", min = 1, max = 2}
	}
}

local m_sanctum_stones_mission_rewards = {
	easy = 3,
	medium = 6,
	hard = 9,
	starting = 8
}

local m_mission_difficulty_ratios = {
	-- each of these should add up to 100
	{start_turn = 1, end_turn = 39, easy_chance = 70, medium_chance = 25, hard_chance = 5},
	{start_turn = 40, end_turn = 89, easy_chance = 50, medium_chance = 35, hard_chance = 15},
	{start_turn = 90, end_turn = 139, easy_chance = 25, medium_chance = 50, hard_chance = 25},
	{start_turn = 140, end_turn = 9999, easy_chance = 10, medium_chance = 55, hard_chance = 35}
}

local m_blocked_region_list = {}
local m_region_marker_mission_details = {active = false}
local m_sanctum_marker_mission_details = {active= false}

local m_spawn_distance = {
	min = 7,
	max = 10
}

local m_mission_config = {
	herdstone = {
		objective = "RAZE_OR_OWN_SETTLEMENTS",
		title = {
			"mission_text_text_wh2_dlc17_threat_map_title_herdstone_1",
			"mission_text_text_wh2_dlc17_threat_map_title_herdstone_2",
			"mission_text_text_wh2_dlc17_threat_map_title_herdstone_3"
		},
		description = {
			"mission_text_text_wh2_dlc17_threat_map_description_herdstone_1",
			"mission_text_text_wh2_dlc17_threat_map_description_herdstone_2",
			"mission_text_text_wh2_dlc17_threat_map_description_herdstone_3"
		},
		failure_payloads = {
			keys = {
				"wh2_dlc17_threat_map_consequence_herdstone_1"
			}
		},
		conditions = {
			"region"
		},
		duration = {
			min = 7,
			max = 10
		},
		difficulty = {
			-- number of armies the faction has
			easy = {
				min = 0,
				max = 1
			},
			medium = {
				min = 2,
				max = 2
			},
			hard = {
				min = 3,
				max = 999
			}
		},
		rewards = {
			primary = true,
			keys = {
				easy = {
					"wh2_dlc17_threat_map_reward_settlements_1_easy",
					"wh2_dlc17_threat_map_reward_settlements_2_easy",
					"wh2_dlc17_threat_map_reward_settlements_3_easy",
					"wh2_dlc17_threat_map_reward_settlements_4_easy",
					"wh2_dlc17_threat_map_reward_settlements_6_easy",
					"wh2_dlc17_threat_map_reward_settlements_7_easy",
					"wh2_dlc17_threat_map_reward_settlements_8_easy"
				},
				medium = {
					"wh2_dlc17_threat_map_reward_settlements_1_medium",
					"wh2_dlc17_threat_map_reward_settlements_2_medium",
					"wh2_dlc17_threat_map_reward_settlements_3_medium",
					"wh2_dlc17_threat_map_reward_settlements_4_medium",
					"wh2_dlc17_threat_map_reward_settlements_6_medium",
					"wh2_dlc17_threat_map_reward_settlements_7_medium",
					"wh2_dlc17_threat_map_reward_settlements_8_medium"
				},
				hard = {
					"wh2_dlc17_threat_map_reward_settlements_1_hard",
					"wh2_dlc17_threat_map_reward_settlements_2_hard",
					"wh2_dlc17_threat_map_reward_settlements_3_hard",
					"wh2_dlc17_threat_map_reward_settlements_4_hard",
					"wh2_dlc17_threat_map_reward_settlements_6_hard",
					"wh2_dlc17_threat_map_reward_settlements_7_hard",
					"wh2_dlc17_threat_map_reward_settlements_8_hard"
				},
				duration = 5
			},
			money = {
				easy = 1000,
				medium = 3000,
				hard = 5000
			}
		},
		consequences = {
			devastation = {
				min = 10,
				max = 20
			}
		}
	},

	norsca_region = {
		objective = "RAZE_OR_OWN_SETTLEMENTS",
		title = {
			"mission_text_text_wh2_dlc17_threat_map_title_norsca_region_1",
			"mission_text_text_wh2_dlc17_threat_map_title_norsca_region_2",
			"mission_text_text_wh2_dlc17_threat_map_title_norsca_region_3"
		},
		description = {
			"mission_text_text_wh2_dlc17_threat_map_description_norsca_region_1",
			"mission_text_text_wh2_dlc17_threat_map_description_norsca_region_2",
			"mission_text_text_wh2_dlc17_threat_map_description_norsca_region_3"
		},
		failure_payloads = {
			keys = {
				"wh2_dlc17_threat_map_consequence_norsca_region_1",
				"wh2_dlc17_threat_map_consequence_norsca_region_2",
				"wh2_dlc17_threat_map_consequence_norsca_region_3",
				"wh2_dlc17_threat_map_consequence_norsca_region_4"
			},
			duration = 5
		},
		conditions = {
			"region"
		},
		difficulty = {
			-- number of armies the faction has
			easy = {
				min = 0,
				max = 1
			},
			medium = {
				min = 2,
				max = 2
			},
			hard = {
				min = 3,
				max = 999
			}
		},
		duration = {
			min = 7,
			max = 10
		},
		rewards = {
			primary = true,
			keys = {
				easy = {
					"wh2_dlc17_threat_map_reward_settlements_1_easy",
					"wh2_dlc17_threat_map_reward_settlements_2_easy",
					"wh2_dlc17_threat_map_reward_settlements_3_easy",
					"wh2_dlc17_threat_map_reward_settlements_4_easy",
					"wh2_dlc17_threat_map_reward_settlements_6_easy",
					"wh2_dlc17_threat_map_reward_settlements_7_easy",
					"wh2_dlc17_threat_map_reward_settlements_8_easy"
				},
				medium = {
					"wh2_dlc17_threat_map_reward_settlements_1_medium",
					"wh2_dlc17_threat_map_reward_settlements_2_medium",
					"wh2_dlc17_threat_map_reward_settlements_3_medium",
					"wh2_dlc17_threat_map_reward_settlements_4_medium",
					"wh2_dlc17_threat_map_reward_settlements_6_medium",
					"wh2_dlc17_threat_map_reward_settlements_7_medium",
					"wh2_dlc17_threat_map_reward_settlements_8_medium"
				},
				hard = {
					"wh2_dlc17_threat_map_reward_settlements_1_hard",
					"wh2_dlc17_threat_map_reward_settlements_2_hard",
					"wh2_dlc17_threat_map_reward_settlements_3_hard",
					"wh2_dlc17_threat_map_reward_settlements_4_hard",
					"wh2_dlc17_threat_map_reward_settlements_6_hard",
					"wh2_dlc17_threat_map_reward_settlements_7_hard",
					"wh2_dlc17_threat_map_reward_settlements_8_hard"
				},
				duration = 5
			},
			money = {
				easy = 1000,
				medium = 3000,
				hard = 5000
			}
		}
	},

	chaos_army = {
		objective = "ENGAGE_FORCE",
		title = {
			"mission_text_text_wh2_dlc17_threat_map_title_chaos_army_1",
			"mission_text_text_wh2_dlc17_threat_map_title_chaos_army_2",
			"mission_text_text_wh2_dlc17_threat_map_title_chaos_army_3"
		},
		description = {
			"mission_text_text_wh2_dlc17_threat_map_description_chaos_army_1",
			"mission_text_text_wh2_dlc17_threat_map_description_chaos_army_2",
			"mission_text_text_wh2_dlc17_threat_map_description_chaos_army_3"
		},
		failure_payloads = {
			keys = {
				"wh2_dlc17_threat_map_consequence_kill_army_1",
				"wh2_dlc17_threat_map_consequence_kill_army_2",
				"wh2_dlc17_threat_map_consequence_kill_army_3",
				"wh2_dlc17_threat_map_consequence_kill_army_4",
				"wh2_dlc17_threat_map_consequence_kill_army_5",
				"wh2_dlc17_threat_map_consequence_kill_army_6",
				"wh2_dlc17_threat_map_consequence_kill_army_7"
			},
			duration = 0
		},
		conditions = {
			"cqi",
			"requires_victory"
		},
		duration = {
			min = 7,
			max = 10
		},
		rewards = {
			primary = true,
			keys = {
				easy = {
					"wh2_dlc17_threat_map_reward_kill_army_1_easy",
					"wh2_dlc17_threat_map_reward_kill_army_2_easy",
					"wh2_dlc17_threat_map_reward_kill_army_3_easy",
					"wh2_dlc17_threat_map_reward_kill_army_4_easy",
					"wh2_dlc17_threat_map_reward_kill_army_5_easy",
					"wh2_dlc17_threat_map_reward_kill_army_6_easy",
					"wh2_dlc17_threat_map_reward_kill_army_7_easy",
					"wh2_dlc17_threat_map_reward_kill_army_8_easy"
				},
				medium = {
					"wh2_dlc17_threat_map_reward_kill_army_1_medium",
					"wh2_dlc17_threat_map_reward_kill_army_2_medium",
					"wh2_dlc17_threat_map_reward_kill_army_3_medium",
					"wh2_dlc17_threat_map_reward_kill_army_4_medium",
					"wh2_dlc17_threat_map_reward_kill_army_5_medium",
					"wh2_dlc17_threat_map_reward_kill_army_6_medium",
					"wh2_dlc17_threat_map_reward_kill_army_7_medium",
					"wh2_dlc17_threat_map_reward_kill_army_8_medium"
				},
				hard = {
					"wh2_dlc17_threat_map_reward_kill_army_1_hard",
					"wh2_dlc17_threat_map_reward_kill_army_2_hard",
					"wh2_dlc17_threat_map_reward_kill_army_3_hard",
					"wh2_dlc17_threat_map_reward_kill_army_4_hard",
					"wh2_dlc17_threat_map_reward_kill_army_5_hard",
					"wh2_dlc17_threat_map_reward_kill_army_6_hard",
					"wh2_dlc17_threat_map_reward_kill_army_7_hard",
					"wh2_dlc17_threat_map_reward_kill_army_8_hard"
				},
				duration = 5
			},
			money = {
				easy = 1000,
				medium = 3000,
				hard = 5000
			}
		}
	},

	corrupted_army = {
		objective = "ENGAGE_FORCE",
		title = {
			"mission_text_text_wh2_dlc17_threat_map_title_corrupted_army_1",
			"mission_text_text_wh2_dlc17_threat_map_title_corrupted_army_2",
			"mission_text_text_wh2_dlc17_threat_map_title_corrupted_army_3"
		},
		description = {
			"mission_text_text_wh2_dlc17_threat_map_description_corrupted_army_1",
			"mission_text_text_wh2_dlc17_threat_map_description_corrupted_army_2",
			"mission_text_text_wh2_dlc17_threat_map_description_corrupted_army_3"
		},
		failure_payloads = {
			keys = {
				"wh2_dlc17_threat_map_consequence_kill_army_1",
				"wh2_dlc17_threat_map_consequence_kill_army_2",
				"wh2_dlc17_threat_map_consequence_kill_army_3",
				"wh2_dlc17_threat_map_consequence_kill_army_4",
				"wh2_dlc17_threat_map_consequence_kill_army_5",
				"wh2_dlc17_threat_map_consequence_kill_army_6",
				"wh2_dlc17_threat_map_consequence_kill_army_7"
			},
			duration = 0
		},
		conditions = {
			"cqi",
			"requires_victory"
		},
		duration = {
			min = 7,
			max = 10
		},
		rewards = {
			primary = true,
			keys = {
				easy = {
					"wh2_dlc17_threat_map_reward_kill_army_1_easy",
					"wh2_dlc17_threat_map_reward_kill_army_2_easy",
					"wh2_dlc17_threat_map_reward_kill_army_3_easy",
					"wh2_dlc17_threat_map_reward_kill_army_4_easy",
					"wh2_dlc17_threat_map_reward_kill_army_5_easy",
					"wh2_dlc17_threat_map_reward_kill_army_6_easy",
					"wh2_dlc17_threat_map_reward_kill_army_7_easy",
					"wh2_dlc17_threat_map_reward_kill_army_8_easy"
				},
				medium = {
					"wh2_dlc17_threat_map_reward_kill_army_1_medium",
					"wh2_dlc17_threat_map_reward_kill_army_2_medium",
					"wh2_dlc17_threat_map_reward_kill_army_3_medium",
					"wh2_dlc17_threat_map_reward_kill_army_4_medium",
					"wh2_dlc17_threat_map_reward_kill_army_5_medium",
					"wh2_dlc17_threat_map_reward_kill_army_6_medium",
					"wh2_dlc17_threat_map_reward_kill_army_7_medium",
					"wh2_dlc17_threat_map_reward_kill_army_8_medium"
				},
				hard = {
					"wh2_dlc17_threat_map_reward_kill_army_1_hard",
					"wh2_dlc17_threat_map_reward_kill_army_2_hard",
					"wh2_dlc17_threat_map_reward_kill_army_3_hard",
					"wh2_dlc17_threat_map_reward_kill_army_4_hard",
					"wh2_dlc17_threat_map_reward_kill_army_5_hard",
					"wh2_dlc17_threat_map_reward_kill_army_6_hard",
					"wh2_dlc17_threat_map_reward_kill_army_7_hard",
					"wh2_dlc17_threat_map_reward_kill_army_8_hard"
				},
				duration = 5
			},
			money = {
				easy = 1000,
				medium = 3000,
				hard = 5000
			}
		}
	},

	region_marker = {
		objective = "SCRIPTED",
		title = {
			"mission_text_text_wh2_dlc17_threat_map_title_region_marker_1",
			"mission_text_text_wh2_dlc17_threat_map_title_region_marker_2",
			"mission_text_text_wh2_dlc17_threat_map_title_region_marker_3"
		},
		description = {
			"mission_text_text_wh2_dlc17_threat_map_description_region_marker_1",
			"mission_text_text_wh2_dlc17_threat_map_description_region_marker_2",
			"mission_text_text_wh2_dlc17_threat_map_description_region_marker_3"
		},
		difficulty = {
			-- Mission is available at each difficulty if the player has euqal or more settlements than the below values.
			easy = 8,
			medium = 15,
			hard = 20
		},
		failure_payloads = {
			keys = {
				"wh2_dlc17_threat_map_consequence_region_razed"
			}
		},
		conditions = {
			"script_key",
			"position",
			"override_text mission_text_text_wh2_dlc17_threat_map_objective_region_razed"
		},
		duration = {
			min = 7,
			max = 10
		},
		rewards = {
			primary = true,
			keys = {
				easy = {
					"wh2_dlc17_threat_map_reward_region_razed_1_easy",
					"wh2_dlc17_threat_map_reward_region_razed_2_easy",
					"wh2_dlc17_threat_map_reward_region_razed_3_easy",
					"wh2_dlc17_threat_map_reward_region_razed_4_easy",
					"wh2_dlc17_threat_map_reward_region_razed_5_easy",
					"wh2_dlc17_threat_map_reward_region_razed_6_easy",
					"wh2_dlc17_threat_map_reward_region_razed_7_easy"
				},
				medium = {
					"wh2_dlc17_threat_map_reward_region_razed_1_medium",
					"wh2_dlc17_threat_map_reward_region_razed_2_medium",
					"wh2_dlc17_threat_map_reward_region_razed_3_medium",
					"wh2_dlc17_threat_map_reward_region_razed_4_medium",
					"wh2_dlc17_threat_map_reward_region_razed_5_medium",
					"wh2_dlc17_threat_map_reward_region_razed_6_medium",
					"wh2_dlc17_threat_map_reward_region_razed_7_medium"
				},
				hard = {
					"wh2_dlc17_threat_map_reward_region_razed_1_hard",
					"wh2_dlc17_threat_map_reward_region_razed_2_hard",
					"wh2_dlc17_threat_map_reward_region_razed_3_hard",
					"wh2_dlc17_threat_map_reward_region_razed_4_hard",
					"wh2_dlc17_threat_map_reward_region_razed_5_hard",
					"wh2_dlc17_threat_map_reward_region_razed_6_hard",
					"wh2_dlc17_threat_map_reward_region_razed_7_hard"
				},
				duration = 5
			}
		}
	},

	spawned_army = {
		objective = "ENGAGE_FORCE",
		title = {
			"mission_text_text_wh2_dlc17_threat_map_title_spawned_army_1",
			"mission_text_text_wh2_dlc17_threat_map_title_spawned_army_2",
			"mission_text_text_wh2_dlc17_threat_map_title_spawned_army_3"
		},
		description = {
			"mission_text_text_wh2_dlc17_threat_map_description_spawned_army_1",
			"mission_text_text_wh2_dlc17_threat_map_description_spawned_army_2",
			"mission_text_text_wh2_dlc17_threat_map_description_spawned_army_3"
		},
		failure_payloads = {
			keys = {
				"wh2_dlc17_threat_map_consequence_army_will_raid"
			},
			money = {
				easy = -2500,
				medium = -5000,
				hard = -7500
			}
		},
		conditions = {
			"cqi",
			"requires_victory"
		},
		duration = {
			min = 7,
			max = 10
		},
		rewards = {
			primary = true,
			money = {
				easy = 5000,
				medium = 7500,
				hard = 10000
			},
			duration = 5
		}
	},

	sanctum_defence = {
		objective = "SCRIPTED",
		title = {
			"mission_text_text_wh2_dlc17_threat_map_title_sanctum_destroyed_1",
			"mission_text_text_wh2_dlc17_threat_map_title_sanctum_destroyed_2",
			"mission_text_text_wh2_dlc17_threat_map_title_sanctum_destroyed_3"
		},
		description = {
			"mission_text_text_wh2_dlc17_threat_map_description_sanctum_destroyed_1",
			"mission_text_text_wh2_dlc17_threat_map_description_sanctum_destroyed_2",
			"mission_text_text_wh2_dlc17_threat_map_description_sanctum_destroyed_3",
		},
		failure_payloads = {
			keys = {
				"wh2_dlc17_threat_map_consequence_sanctum_defence"
			}
		},
		difficulty = {
			-- Mission is available at each difficulty if the player has euqal or more settlements than the below values.
			easy = 5,
			medium = 8,
			hard = 12
		},
		conditions = {
			"script_key",
			"position",
			"override_text mission_text_text_wh2_dlc17_threat_map_objective_sanctum_attacked"
		},
		duration = {
			min = 7,
			max = 10
		},
		rewards = {
			primary = false,
			sanctum_gems = {
				amount = {
					easy = 6,
					medium = 9,
					hard = 12
				},
				keys = {
					easy = "wh2_dlc17_threat_map_reward_sanctum_marker_easy",
					medium = "wh2_dlc17_threat_map_reward_sanctum_marker_hard",
					hard = "wh2_dlc17_threat_map_reward_sanctum_marker_medium"
				}
			}
		}
	}
}

local m_enemy_army_buffs = {
	-- these keys should match the effect keys from the chaos/corrupted army failure payloads.
	["wh2_dlc17_threat_map_consequence_kill_army_1"] = "wh_main_effect_force_unit_stat_melee_attack",
	["wh2_dlc17_threat_map_consequence_kill_army_2"] = "wh_main_effect_force_unit_stat_melee_defence",
	["wh2_dlc17_threat_map_consequence_kill_army_3"] = "wh2_dlc17_effect_weapon_str_for_all",
	["wh2_dlc17_threat_map_consequence_kill_army_4"] = "wh_main_effect_force_unit_stat_morale",
	["wh2_dlc17_threat_map_consequence_kill_army_5"] = "wh_main_effect_force_army_battle_movement_speed",
	["wh2_dlc17_threat_map_consequence_kill_army_6"] = "wh_main_effect_unit_stat_mod_ward_save",
	["wh2_dlc17_threat_map_consequence_kill_army_7"] = "wh_main_effect_force_unit_stat_fatigue_resistance_medium"
}

local m_starting_mission_config = {
	difficulty = "medium",
	id = "oxy_starting_mission",
	region = {
		["wh2_main_great_vortex"] = "wh2_main_vor_deadwood_nagrar",
		["main_warhammer"] = "wh2_main_deadwood_nagrar"
	},
	position = {
		["wh2_main_great_vortex"] = {x = 352, y = 680},
		["main_warhammer"] = {x = 250, y = 665}
	},
	objective = "DESTROY_FACTION",
	faction_target = "wh2_dlc17_nor_deadwood_ravagers",
	heading = "mission_text_text_wh2_dlc17_threat_map_title_starting",
	description = "mission_text_text_wh2_dlc17_threat_map_description_starting",
	reward = "wh2_dlc17_threat_map_missions_starting",
	money = 5000,
	failure_payload = "wh2_dlc17_threat_map_missions_starting"
}

local m_chaos_invasion_failure_keys = {
	time = "wh2_dlc17_threat_map_consequence_invasion_time",
	power = "wh2_dlc17_threat_map_consequence_invasion_power"
}

local m_chaos_factions = {
	-- logs chaos subcultures and faction keys
	[m_beastmen_culture] = true,
	[m_chaos_culture] = true,
	[m_norsca_culture] = true
}

local m_corrupted_factions = {
	-- logs chaos subcultures and faction keys
	[m_skaven_culture] = true,
	[m_vamp_count_culture] = true,
	[m_vamp_coast_culture] = true,
	[m_cult_of_pleasure_faction_key] = true
}

local m_sanctum_stone_effect_bundle_keys = {
	easy = "wh2_dlc17_threat_map_reward_sanctum_stones_easy",
	medium = "wh2_dlc17_threat_map_reward_sanctum_stones_medium",
	hard = "wh2_dlc17_threat_map_reward_sanctum_stones_hard",
	starting = "wh2_dlc17_threat_map_reward_sanctum_stones_starting"
}

local m_latest_failure_payload_key = ""

local m_chaos_invasion_campaigns = {
	["main_warhammer"] = true,
	["wh2_main_great_vortex"] = false
}

local m_blocked_factions = {
	-- don't use taurox for any threat map missions
	"wh2_dlc17_bst_taurox",

	-- copy and paste of the faction keys within the cai_diplomacy_excluded_factions table.
	-- This isn't the most future proof solution but in the interest of time it will do.
	-- Try to chase down a new function that lets you check if two factions can use diplomacy with eachother
	"wh2_dlc10_def_blood_voyage",
	"wh2_dlc13_lzd_avengers",
	"wh2_main_bst_blooded_axe_brayherd",
	"wh2_main_bst_manblight_brayherd",
	"wh2_main_bst_ripper_horn_brayherd",
	"wh2_main_bst_shadowgor_brayherd",
	"wh2_main_bst_skrinderkin_brayherd",
	"wh2_main_bst_stone_horn_brayherd",
	"wh2_main_chs_chaos_incursion_def",
	"wh2_main_chs_chaos_incursion_def",
	"wh2_main_chs_chaos_incursion_hef",
	"wh2_main_chs_chaos_incursion_hef",
	"wh2_main_chs_chaos_incursion_lzd",
	"wh2_main_chs_chaos_incursion_lzd",
	"wh2_main_chs_chaos_incursion_skv",
	"wh2_main_def_dark_elves_intervention",
	"wh2_main_grn_arachnos_waaagh",
	"wh2_main_grn_blue_vipers_waaagh",
	"wh2_main_hef_high_elves_intervention",
	"wh2_main_lzd_lizardmen_intervention",
	"wh2_main_nor_hung_incursion_def",
	"wh2_main_nor_hung_incursion_hef",
	"wh2_main_nor_hung_incursion_lzd",
	"wh2_main_nor_hung_incursion_skv",
	"wh2_main_skv_skaven_intervention",
	"wh2_main_skv_unknown_clan_def",
	"wh2_main_skv_unknown_clan_hef",
	"wh2_main_skv_unknown_clan_lzd",
	"wh2_main_skv_unknown_clan_skv",
	"wh_dlc03_bst_beastmen_brayherd",
	"wh_dlc03_bst_beastmen_chaos_brayherd",
	"wh_dlc03_bst_beastmen_rebels_brayherd",
	"wh_dlc03_bst_jagged_horn_brayherd",
	"wh_dlc03_bst_redhorn_brayherd",
	"wh_main_grn_black_venom_waaagh",
	"wh_main_grn_bloody_spearz_waaagh",
	"wh_main_grn_broken_nose_waaagh",
	"wh_main_grn_crooked_moon_waaagh",
	"wh_main_grn_greenskins_rebels_waaagh",
	"wh_main_grn_greenskins_waaagh",
	"wh_main_grn_necksnappers_waaagh",
	"wh_main_grn_orcs_of_the_bloody_hand_waaagh",
	"wh_main_grn_red_eye_waaagh",
	"wh_main_grn_red_fangs_waaagh",
	"wh_main_grn_scabby_eye_waaagh",
	"wh_main_grn_skull-takerz_waaagh",
	"wh_main_grn_skullsmasherz_waaagh",
	"wh_main_grn_teef_snatchaz_waaagh",
	"wh_main_grn_top_knotz_waaagh"
}

local m_enemy_immobile_debuff = "wh2_dlc17_effect_campaign_movement_immobile"



--------------------------------------------------------------
----------------------- Region Blocking ----------------------
--------------------------------------------------------------

local function is_region_blocked(region)
	local region_blocked = m_blocked_region_list[region] or false

	return region_blocked
end

local function update_blocked_region_list()
	-- wipe the blocked region list before updating its entries.
	m_blocked_region_list = {}
	local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
	local oxyotl_has_home = oxyotl_faction:has_home_region()

	-- regions linked to active missions
	for k, v in ipairs(m_active_mission_details) do
		local region = cm:get_region(v.region)
		local adjacent_region_list = region:adjacent_region_list()

		m_blocked_region_list[v.region] = true

		for i = 0, adjacent_region_list:num_items() - 1 do
			local adjacent_region = adjacent_region_list:item_at(i):name()
			m_blocked_region_list[adjacent_region] = true
		end
	end

	-- regions near oxyotl's home region.
	if(oxyotl_has_home) then
		local region = oxyotl_faction:home_region()
		local adjacent_region_list = region:adjacent_region_list()

		m_blocked_region_list[region:name()] = true

		for i = 0, adjacent_region_list:num_items() - 1 do
			local adjacent_region = adjacent_region_list:item_at(i):name()
			m_blocked_region_list[adjacent_region] = true
		end
	end

	if(Silent_Sanctums:get_sanctum_transport_region() ~= "") then
		local region = cm:get_region(Silent_Sanctums:get_sanctum_transport_region())
		local adjacent_region_list = region:adjacent_region_list()

		m_blocked_region_list[region:name()] = true

		for i = 0, adjacent_region_list:num_items() - 1 do
			local adjacent_region = adjacent_region_list:item_at(i):name()
			m_blocked_region_list[adjacent_region] = true
		end
	end
end



--------------------------------------------------------------
----------- Scripted Battles/force generation ----------------
--------------------------------------------------------------

local function get_chaos_faction_force_details(faction_key)
	-- get the details neccisary for spawning forces/battles.
	
	if(faction_key ~= nil) then
		for k, v in ipairs(m_chaos_force_details) do
			local faction = cm:get_faction(faction_key)
			local subculture
			if(faction) then
				subculture = faction:subculture()
			end
			if(v.faction_key == faction_key or subculture == v.subculture) then
				local general_subtype = v.general_subtype
				local force_template_key = v.template_key
				subculture = v.subculture

				return faction_key, force_template_key, general_subtype, subculture
			end
		end

		out.design("Provided faction "..faction_key.." didn't match any chaos force details. Reverting to random force details")
	end

	local faction_roll = cm:random_number(#m_chaos_force_details)

	local faction_key = m_chaos_force_details[faction_roll].faction_key
	local force_template_key = m_chaos_force_details[faction_roll].template_key
	local general_subtype = m_chaos_force_details[faction_roll].general_subtype
	local subculture = m_chaos_force_details[faction_roll].subculture

	return faction_key, force_template_key, general_subtype, subculture
end

local function oxyotl_pre_battle_retreat_listener()
	core:add_listener(
		"Oxy_RetreatCheck",
		"ComponentLClickUp",
		function(context)
			if(m_scripted_battle_active.active) then
				return context.string == "button_dismiss"
			end
		end,
		function(context) 
			cm:fail_custom_mission(m_oxyotl_faction_key, m_scripted_battle_active.mission_key)
			m_scripted_battle_active = {active = false}
		end,
		true
	)
end

local function oxyotl_post_battle_mission_completion_listener()
	core:add_listener(
		"Oxy_PostInvasionBattle",
		"CharacterCompletedBattle",
		function(context)
			if(m_scripted_battle_active.active) then
				return true
			end

			return false
		end,
		function(context) 
			local uim = cm:get_campaign_ui_manager()

			cm:disable_event_feed_events(false, "","","diplomacy_faction_destroyed")
			core:remove_listener("Oxy_RetreatCheck")

			if(cm:pending_battle_cache_attacker_victory()) then
				cm:complete_scripted_mission_objective(m_scripted_battle_active.mission_key, m_scripted_battle_active.mission_id, true)
			else
				cm:fail_custom_mission(m_oxyotl_faction_key, m_scripted_battle_active.mission_key)
			end

			m_scripted_battle_active = {active = false}
		end,
		true
	)
end

local function get_oxyotl_force_cqi()
	local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
	local oxyotl_force_cqi = oxyotl_faction:faction_leader():military_force():command_queue_index()
	return oxyotl_force_cqi
end

local function launch_scripted_battle(target_force_cqi, difficulty, is_ambush, mission_key, mission_id)
	local uim = cm:get_campaign_ui_manager()
	local faction_key, template_key, general_subtype = get_chaos_faction_force_details()
	local generated_force_is_attacker, invite_allies, command_queue = false, false, false
	local destroy_generated_force_after_battle = true
	local force_size = cm:random_number(m_force_difficulty_values[difficulty].force_size.max, m_force_difficulty_values[difficulty].force_size.min)
	local force_power = cm:random_number(m_force_difficulty_values[difficulty].force_power.max, m_force_difficulty_values[difficulty].force_power.min)
	local victory_incident, defeat_incident = nil, nil

	target_force_cqi = target_force_cqi or get_oxyotl_force_cqi()

	Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
		target_force_cqi,
		faction_key,
		template_key,
		force_size,
		force_power,
		generated_force_is_attacker,
		destroy_generated_force_after_battle,
		is_ambush,
		victory_incident,
		defeat_incident,
		general_subtype
	)

	cm:disable_event_feed_events(true, "","","diplomacy_faction_destroyed")
	m_scripted_battle_active = {active = true, mission_key = mission_key, mission_id = mission_id}
end

local function spawn_army_for_faction(faction_key, x, y, difficulty, no_upkeep, raiding)
	local force_size = cm:random_number(m_force_difficulty_values[difficulty].force_size.max, m_force_difficulty_values[difficulty].force_size.min)
	local force_power = cm:random_number(m_force_difficulty_values[difficulty].force_power.max, m_force_difficulty_values[difficulty].force_power.min) 
	local generate_as_table, faction_leader = false, false
	local use_thresholds, maintain_strength = true, true
	local coordinates = {x, y}
	local faction_key, template_key, general_subtype, subculture = get_chaos_faction_force_details(faction_key)
	local invasion_key = "oxyotl_invasion_"..m_invasion_count
	m_invasion_count = m_invasion_count + 1

	local general_names = generate_character_name(subculture, general_subtype)

	local force_list = WH_Random_Army_Generator:generate_random_army(invasion_key, template_key, force_size, force_power, use_thresholds, generate_as_table)
	local invasion = invasion_manager:new_invasion(invasion_key, faction_key, force_list, coordinates)

	invasion:create_general(faction_leader, general_subtype, general_names[1], general_names[2], general_names[3], general_names[4])	
	invasion:start_invasion(maintain_strength)

	if(no_upkeep) then
		invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", 0)
	end

	-- make new armies immune to attrition for a few turns due to spawning them all in random places.
	local duration = 10
	invasion:apply_effect("wh_main_effect_force_army_campaign_attrition_all_immunity", duration)
	
	if(raiding) then
		local general_cqi = invasion:get_general():cqi()
		cm:force_character_force_into_stance("character_cqi:"..general_cqi, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID")
		invasion:remove_aggro_radius()
		invasion:apply_effect(m_enemy_immobile_debuff, 0)
	else
		out.design("---------------")
		out.design("spawning oxyotl force")
		out.design("size: "..force_size)
		out.design("power: "..force_power)
		out.design("strength: "..invasion:get_force():strength())
		out.design("--------------")
		invasion:release()
	end

	return invasion
end



--------------------------------------------------------------
----------------------- Active Mission Functions -------------
--------------------------------------------------------------

local function log_new_active_threat_mission(mission_key, region, mission_type, difficulty, target_army)
	-- this event is used in other systems, such as standard missions
	if(mission_key ~= m_oxyotl_mission_keys.starting) then
		-- this stops the early game mission for the threat map firing turn 1 with the starting mission, and instead fires with the first wave of proper missions.
		core:trigger_event("ScriptEventOxyThreatMapCreated")
	end

	m_active_mission_consequences[mission_key] = {}

	table.insert(m_active_mission_details, {mission_key = mission_key, region = region, mission_type = mission_type, difficulty = difficulty, target_army = target_army})
	
	if(m_mission_wave_details.incident_fired_this_turn == false) then
		m_mission_wave_details.incident_fired_this_turn = true
		cm:trigger_incident(m_oxyotl_faction_key, m_mission_wave_details.incident_key, true)
	end
	
	if(region) then
		cm:make_region_visible_in_shroud(m_oxyotl_faction_key, region)
		update_blocked_region_list()
	end
end


local function oxyotl_reapply_mission_vision_listener()
	core:add_listener(
		"Oxy_ThreatMapMissionVision",
		"FactionTurnStart",
		function(context)
			local faction = context:faction():name()

			if(faction == m_oxyotl_faction_key) then
				return true
			end

			return false
		end,
		function(context)
			for k, v in ipairs(m_active_mission_details) do
				if(v.mission_type == "oxy_natural_corrupted_army_mission" or v.mission_type == "oxy_natural_chaos_army_mission") then
					if(v.target_army) then
						v.region = cm:get_military_force_by_cqi(v.target_army):general_character():region():name()
					end
				end
				cm:make_region_visible_in_shroud(m_oxyotl_faction_key, v.region)
			end
		end,
		true
	)
end

local function get_available_threat_mission_key(difficulty)
	for k, v in ipairs(m_oxyotl_mission_keys[difficulty]) do
		local key_available = true

		-- check each dummy key against keys in the active mission list until available key found.
		for key, val in ipairs(m_active_mission_details) do
			if(v == val.mission_key) then
				key_available = false
				break
			end
		end
		
		if(key_available == true) then
			return v
		end
	end

	-- We should never reach a situation where all keys are in use and another key is requested
	-- If this is returning false due to increasing the amount of missions that can be active at once you might need to create more dummy keys and add them to m_oxyotl_mission_keys
	return false
end

local function is_active_threat_map_mission(mission_key)
	for k, v in ipairs(m_active_mission_details) do
		if(v.mission_key == mission_key) then
			return true
		end
	end
	return false
end

local function check_number_within_range(number, min, max)
	-- checks if supplied number is between two ranges.
	-- if max is nil then it checks if the number is just higher than the min.
	if(number >= min) then
		if(max == nil or number <= max) then
			return true
		end
	end
	return false
end

local function is_blocked_faction(faction_key)
	for k, v in ipairs(m_blocked_factions) do
		if(faction_key == v) then
			return true
		end
	end

	return false
end

local function select_mission_difficulty()
	 local turn_no = cm:turn_number()
	 local easy_min, easy_max, med_min, med_max, hard_min, hard_max
	
	for k, v in ipairs(m_mission_difficulty_ratios) do
		if(check_number_within_range(turn_no, v.start_turn, v.end_turn)) then
			-- set the ratios for the given turn number.
			easy_min = 1
			easy_max = v.easy_chance
			med_min = easy_max + 1
			med_max = easy_max + v.medium_chance
			hard_min = med_max + 1
			hard_max = med_max + v.hard_chance
			break
		end
	end

	local diff_roll = cm:random_number(hard_max, easy_min)

	if(diff_roll >= easy_min and diff_roll <= easy_max) then
		return "easy"
	elseif(diff_roll >= med_min and diff_roll <= med_max) then
		return "medium"
	else
		return "hard"
	end
end

local function is_chaos_or_corrupted_faction(faction)
	local faction_key = faction:name()
	local faction_culture = faction:culture()

	if(m_chaos_factions[faction_key] or m_chaos_factions[faction_culture] or m_corrupted_factions[faction_key] or m_corrupted_factions[faction_culture]) then
		return true
	end

	return false
end

local function get_garrison_army_strength(faction_interface, region_key)
	-- returns the combiend strength of a regions natural garrison plus any armies stationed within the settlement
	local strength = 0
	local character_list = faction_interface:character_list()
	for i = 0, character_list:num_items() - 1 do 
		local character = character_list:item_at(i)
		local character_region = character:region()
		local region_name = ""

		if(character_region:is_null_interface() == false) then
			region_name = character_region:name()
		end

		if(region_name == region_key and character:in_settlement()) then
			strength = strength + character:military_force():strength()
		end
	end

	return strength
end



--------------------------------------------------------------
----------------- REWARDS/CONSEQUENCES -----------------------
--------------------------------------------------------------

local function log_mission_gem_rewards(mission_key, amount)
	-- insert the reward function under the relevant mission key
	m_active_mission_rewards[mission_key] = {
		gems = {
			amount = amount
		}
	}
end

local function log_army_mission_consequence(mission_key, force_cqi)
	if(m_latest_failure_payload_key ~= nil and m_latest_failure_payload_key ~= "") then
		m_active_mission_consequences[mission_key].army = {
				force_cqi = force_cqi,
				effect_key = m_enemy_army_buffs[m_latest_failure_payload_key]
			}
	end

	m_latest_failure_payload_key = ""
end

local function get_primary_mission_reward(mission_key, difficulty)
	local reward_type = cm:random_number(2, 1)
	local reward
	if(reward_type ~= 1) then
		-- Sanctum Gems
		local amount = m_sanctum_stones_mission_rewards[difficulty]

		log_mission_gem_rewards(mission_key, amount)
		
		reward = "effect_bundle{bundle_key "..m_sanctum_stone_effect_bundle_keys[difficulty]..";turns 0;}"
	else
		-- Blessed Units
		local unit_list = m_blessed_spawning_mission_rewards[difficulty]
		local unit_choice_roll = cm:random_number(#unit_list, 1)
		local unit_choice = unit_list[unit_choice_roll].unit_key
		local unit_count = cm:random_number(unit_list[unit_choice_roll].max, unit_list[unit_choice_roll].min)

		reward = "add_mercenary_to_faction_pool{unit_key "..unit_choice..";amount "..unit_count..";}"
	end

	return reward
end

local function get_secondary_mission_reward(mission_key, mission_config, difficulty)
	local effect_rewards = mission_config.rewards.keys
	local money_rewards = mission_config.rewards.money
	local sanctum_rewards = mission_config.rewards.sanctum_gems
	local reward_list = {}

	if(sanctum_rewards) then
		local amount = sanctum_rewards.amount[difficulty]

		log_mission_gem_rewards(mission_key, amount)

		return "effect_bundle{bundle_key "..sanctum_rewards.keys[difficulty]..";turns 0;}"
	else
		if(effect_rewards) then
			for k, v in ipairs(effect_rewards[difficulty]) do
				table.insert(reward_list, "effect_bundle{bundle_key "..v..";turns "..effect_rewards.duration..";}")
			end
		end

		if(money_rewards) then
			table.insert(reward_list, "money "..money_rewards[difficulty])
		end

		

		if(#reward_list > 0) then
			local reward_roll = cm:random_number(#reward_list, 1)

			return reward_list[reward_roll]
		else
			return false
		end
	end
end

local function grant_sanctum_gems(mission_key)
	local amount = m_active_mission_rewards[mission_key].gems.amount
	Silent_Sanctums:add_sanctum_gems(amount)
end

local function grant_mission_rewards(mission_key)
	local rewards = m_active_mission_rewards[mission_key]

	if(rewards) then
		if(rewards.gems) then
			grant_sanctum_gems(mission_key)
		end
	end
end

local function spawn_brayherd_at_region(mission_key)
	local consequence = m_active_mission_consequences[mission_key].herdstone
	local faction_key = consequence.faction
	local region = cm:get_region(consequence.region)
	local at_sea = false
	local same_region = true
	local spawn_distance = cm:random_number(m_spawn_distance.max, m_spawn_distance.min)
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region:name(), at_sea, same_region, spawn_distance)
	local difficulty = consequence.difficulty

	if(x ~= nil and x ~= -1 and y ~= nil and y ~= -1) then
		spawn_army_for_faction(faction_key, x, y, difficulty)
	end
end

local function defile_region(mission_key)
	local region_key = m_active_mission_consequences[mission_key].herdstone.region
	local bloodground = Bloodgrounds:is_bloodground_region(region_key) 
	if(bloodground) then
		local min = m_mission_config.herdstone.consequences.devastation.min
		local max = m_mission_config.herdstone.consequences.devastation.max
		local amount = cm:random_number(max, min)

		Bloodgrounds:modify_devastation(bloodground, amount)
		CampaignUI.TriggerCampaignScriptEvent(0, Bloodgrounds.ritual_script_trigger_prefix..region_key)
	end
end

local function destroy_buildings_in_region(mission_key)
	local region_key = m_active_mission_consequences[mission_key].region_attacked
	local slot_list = cm:get_region(region_key):settlement():slot_list()
	local broken_health_percent = 0

	for i = 0, slot_list:num_items() - 1 do
		local slot = slot_list:item_at(i)
		if(slot:has_building()) then
			local building_key = slot:building():name()
			cm:instant_set_building_health_percent(region_key, building_key, broken_health_percent)
		end
	end
end

local function buff_enemy_army(mission_key)
	local effect_bundle = m_active_mission_consequences[mission_key].army.effect_bundle
	local force_cqi = m_active_mission_consequences[mission_key].army.force_cqi
	-- 0 = permenant
	local duration = 0
	cm:apply_effect_bundle_to_force(effect_bundle, force_cqi, duration)
end

local function decrease_chaos_invasion_timer()
	-- this modifies data in wh2_chaos_invasion.lua. decreases the turns until the chaos invasion starts by 2
	CI_DATA.CI_EARLY_TURNS = CI_DATA.CI_EARLY_TURNS + 2
	out.design("Reducing time until chaos invasion by 2 turns")
end

local function increase_chaos_invasion_power()
	-- this modifies data in wh2_chaos_invasion.lua. increases the amount of armies that spawn by 1
	CI_DATA.CI_EXTRA_ARMIES = CI_DATA.CI_EXTRA_ARMIES + 1
	out.design("Increasing armies that will spawn in chaos invasion by 1")
end

local function destroy_buildings_in_sanctum(mission_key)
	local region_key = m_active_mission_consequences[mission_key].sanctum_attacked
	local slot_list = cm:get_region(region_key):foreign_slot_manager_for_faction(m_oxyotl_faction_key):slots()

	for i = 0, slot_list:num_items() - 1 do
		local slot = slot_list:item_at(i)
		if(slot:is_null_interface() == false) then
			local has_building = slot:has_building()
			if(has_building) then
				local building = slot:building()
				if(building ~= "wh2_dlc17_silent_sanctum_core_0" and building ~= "wh2_dlc17_silent_sanctum_core_1") then
					cm:foreign_slot_instantly_dismantle_building(slot)
				end
			end
		end
	end
end

local function perform_mission_consequences(mission_key)
	local consequences = m_active_mission_consequences[mission_key]

	if(consequences) then
		if(consequences.herdstone) then
			spawn_brayherd_at_region(mission_key)
			defile_region(mission_key)
		end
		if(consequences.region_attacked) then
			destroy_buildings_in_region(mission_key)
		end
		if(consequences.army) then
			buff_enemy_army(mission_key)
		end
		if(consequences.ci_timer) then
			decrease_chaos_invasion_timer()
		end
		if(consequences.ci_power) then
			increase_chaos_invasion_power()
		end
		if(consequences.sanctum_attacked) then
			destroy_buildings_in_sanctum(mission_key)
		end
	end
end

--------------------------------------------------------------
-----------------------  MISSION SETUP -----------------------
--------------------------------------------------------------

local function trigger_threat_mission(mission_key, difficulty, mission_config, target, position, script_id)
	-- target can be a faction_key, region_key or force cqi
	-- position is only needed for SCRIPTED missions
	-- script_id is only needed for SCRIPTED missions

	local mm = mission_manager:new(m_oxyotl_faction_key, mission_key)
	local mission_duration = cm:random_number(mission_config.duration.max, mission_config.duration.min)
	local title_choice = cm:random_number(#mission_config.title, 1)
	local campaign_type = cm:get_campaign_name()
	local primary_reward = mission_config.rewards.primary
	local secondary_rewards = get_secondary_mission_reward(mission_key, mission_config, difficulty)
	local failure_duration = mission_config.failure_payloads.duration or 0
	local description_choice
	

	if(title_choice <= #mission_config.description) then
		-- title _1 in the db is currently designed to be paired with description _1 etc.
		description_choice = title_choice
	else
		-- title didn't have a matching description choice, defaulting to random
		description_choice = cm:random_number(#mission_config.description, 1)
	end

	mm:add_new_objective(mission_config.objective)

	for k, v in ipairs(mission_config.conditions) do
		if(v == "region") then
			local settlement = cm:get_region(target):settlement()
			local x = settlement:logical_position_x()
			local y = settlement:logical_position_y()

			mm:add_condition("region "..target)
			mm:add_condition("position "..x..","..y)
		elseif(v == "cqi") then
			mm:add_condition("cqi "..target)
		elseif(v == "faction") then
			mm:add_condition("faction "..target)
		elseif(v == "script_key") then
			mm:add_condition("script_key "..script_id)
		elseif(v == "position") then
			mm:add_condition("position "..position.x..","..position.y)
		else
			-- any remaining conditions are hard-coded/don't need variables.
			mm:add_condition(v)
		end
	end
	
	mm:add_heading(mission_config.title[title_choice])
	mm:add_description(mission_config.description[description_choice])
	mm:set_turn_limit(mission_duration)

	if(mission_config.objective == "ENGAGE_FORCE") then
		-- we make forces immobile so that they cant enter hidden stances
		cm:apply_effect_bundle_to_force(m_enemy_immobile_debuff, target, mission_duration)
	end

	if(primary_reward) then
		mm:add_payload(get_primary_mission_reward(mission_key, difficulty))
	end

	if(secondary_rewards) then
		mm:add_payload(secondary_rewards)
	end

	if(mission_config.failure_payloads.keys) then
		local consequence = cm:random_number(#mission_config.failure_payloads.keys , 1)
		m_latest_failure_payload_key = mission_config.failure_payloads.keys[consequence]
		mm:add_failure_payload("effect_bundle{bundle_key "..m_latest_failure_payload_key..";turns "..failure_duration..";}")
	end

	if(m_chaos_invasion_campaigns[campaign_type] == true) then
		-- Add Chaos Invasion consequences in mortal empires
		local roll = cm:random_number(10, 1)
		if(roll == 1) then
			-- 1/10 chance to increase chaos invasion difficulty
			m_active_mission_consequences[mission_key].ci_power = true
			mm:add_failure_payload("effect_bundle{bundle_key "..m_chaos_invasion_failure_keys.power..";turns 0;}")
		elseif(roll >= 2 and roll <= 4) then
			-- 3/10 chance to reduce chaos invasion timer
			m_active_mission_consequences[mission_key].ci_timer = true
			mm:add_failure_payload("effect_bundle{bundle_key "..m_chaos_invasion_failure_keys.time..";turns 0;}")
		end
	end

	if(mission_config.failure_payloads.money) then
		mm:add_failure_payload("money "..mission_config.failure_payloads.money[difficulty])
	end
	
	mm:set_should_whitelist(false)
	mm:trigger()
end

local function get_faction_army_count(faction_interface)
	local character_list = faction_interface:character_list()
	local army_count = 0
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		if(character:character_type("general")) then
			army_count = army_count + 1
		end
	end

	return army_count
end

local function toggle_settlement_ai_targeting(region_key, disable_targeting)
	if(region_key) then
		if(disable_targeting == true) then
			cm:cai_disable_targeting_against_settlement("settlement:"..region_key)
		else
			cm:cai_enable_targeting_against_settlement("settlement:"..region_key)
		end
	end
end



--------------------------------------------------------------
----------------------- STARTING MISSION----------------------
--------------------------------------------------------------

local function start_starting_mission()
	-- a hard coded mission to start off the feature. Once this mission is completed/failed, other missions can start to spawn.
	local difficulty = m_starting_mission_config.difficulty
	local mission_id = m_starting_mission_config.id
	local mission_key = m_oxyotl_mission_keys.starting
	local settlement, x, y
	local campaign = cm:get_campaign_name()
	local region = m_starting_mission_config.region[campaign]
	local x = m_starting_mission_config.position[campaign].x
	local y = m_starting_mission_config.position[campaign].y

	log_new_active_threat_mission(mission_key, region, mission_id, difficulty)
	
	local mm = mission_manager:new(m_oxyotl_faction_key, mission_key)
	mm:add_new_objective(m_starting_mission_config.objective)
	mm:add_condition("faction "..m_starting_mission_config.faction_target)

	-- destroy faction mission type doesn't have a dynamic location, set coordinates in the middle of the three starting regions
	mm:add_condition("position "..x..","..y)

	mm:add_heading(m_starting_mission_config.heading)
	mm:add_description(m_starting_mission_config.description)

	mm:set_turn_limit(20)

	mm:add_payload("effect_bundle{bundle_key "..m_starting_mission_config.reward..";turns 0;}")
	mm:add_payload("effect_bundle{bundle_key "..m_sanctum_stone_effect_bundle_keys.starting..";turns 0;}")
	log_mission_gem_rewards(mission_key, m_sanctum_stones_mission_rewards.starting)
	mm:add_payload("money "..m_starting_mission_config.money)

	mm:add_failure_payload("effect_bundle{bundle_key "..m_starting_mission_config.failure_payload..";turns 0;}")

	mm:set_should_whitelist(false)
	mm:trigger()
end

--------------------------------------------------------------
----------------------- HERDSTONE MISSION---------------------
--------------------------------------------------------------

local function log_herdstone_mission_consequence(mission_key, faction_key, region_key, difficulty)
	m_active_mission_consequences[mission_key].herdstone = {
			region = region_key,
			faction = faction_key,
			difficulty = difficulty
		}
end

local function start_natural_herdstone_mission(difficulty)
	if(m_mission_wave_details.mission_type_limits.herdstone.current < m_mission_wave_details.mission_type_limits.herdstone.max) then
		local faction_list = cm:model():world():faction_list()
		local trimmed_region_list = {}

		for i = 0, faction_list:num_items() - 1 do
			-- generate a list of all beastmen owned regions (herdstones) that aren't in blocked regions
			local faction = faction_list:item_at(i)
			if(faction:is_human() == false) then
				local faction_culture = faction:culture()
				
				if(faction_culture == m_beastmen_culture) then
					local faction_name = faction:name()
					local faction_region_list = faction:region_list()
					for j = 0, faction_region_list:num_items() - 1 do
						local region = faction_region_list:item_at(j)
						local region_name = region:name()
						local garrison_strength = get_garrison_army_strength(faction, region_name)
						if(check_number_within_range(garrison_strength, m_force_difficulty_values[difficulty].strength_min, m_force_difficulty_values[difficulty].strength_max)) then
							local region_blocked = is_region_blocked(region_name)

							if(region_blocked == false) then
								table.insert(trimmed_region_list, region_name)
							end
						end
					end
				end
			end
		end

		if(#trimmed_region_list > 0) then
			local mission_id = "oxy_herdstone_mission"
			local random_index = cm:random_number(#trimmed_region_list, 1)
			local target_region = trimmed_region_list[random_index]
			local mission_key = get_available_threat_mission_key(difficulty)
			local bst_faction_key = cm:get_region(target_region):owning_faction():name()

			log_new_active_threat_mission(mission_key, target_region, mission_id, difficulty)
			log_herdstone_mission_consequence(mission_key, bst_faction_key, target_region, difficulty)
			trigger_threat_mission(mission_key, difficulty, m_mission_config.herdstone, target_region)
			toggle_settlement_ai_targeting(target_region, true)
			
			out.design("starting herdstone mission at: "..target_region)

			m_mission_wave_details.mission_type_limits.herdstone.current = m_mission_wave_details.mission_type_limits.herdstone.current + 1
			return true, mission_id, mission_key
		end
	end

	-- No Valid Herdstones Found
	out.design("Failed to launch "..difficulty.." Herdstone Mission")
	return false
end



--------------------------------------------------------------
------------------ NORSCA SETTLEMENT MISSION -----------------
--------------------------------------------------------------

local function start_natural_norscan_region_mission(difficulty)
	if(m_mission_wave_details.mission_type_limits.norsca_region.current < m_mission_wave_details.mission_type_limits.norsca_region.max) then
		local faction_list = cm:model():world():faction_list()
		local trimmed_region_list = {}

		for i = 0, faction_list:num_items() - 1 do
			-- generate a list of all norsca owned regions that aren't in blocked regions
			local faction = faction_list:item_at(i)
			if(faction:is_human() == false) then
				local faction_culture = faction:culture()

				if(faction_culture == m_norsca_culture or faction_culture == m_chaos_culture) then
					local faction_region_list = faction:region_list()
					for j = 0, faction_region_list:num_items() - 1 do
						local region = faction_region_list:item_at(j)
						local region_name = region:name()
						local garrison_strength = get_garrison_army_strength(faction, region_name)
						if(check_number_within_range(garrison_strength, m_force_difficulty_values[difficulty].strength_min, m_force_difficulty_values[difficulty].strength_max)) then
							local region_blocked = is_region_blocked(region_name)

							if(region_blocked == false) then
								table.insert(trimmed_region_list, region_name)
							end
						end
					end
				end
			end
		end

		if(#trimmed_region_list > 0) then
			local mission_id = "oxy_norsca_settlement_mission"
			local random_index = cm:random_number(#trimmed_region_list, 1)
			local target_region = trimmed_region_list[random_index]
			local mission_key = get_available_threat_mission_key(difficulty)
			local nor_faction_key = cm:get_region(target_region):owning_faction():name()

			log_new_active_threat_mission(mission_key, target_region, mission_id, difficulty)
			trigger_threat_mission(mission_key, difficulty, m_mission_config.norsca_region, target_region)
			toggle_settlement_ai_targeting(target_region, true)

			out.design("starting norscan settlement mission at: "..target_region)

			m_mission_wave_details.mission_type_limits.norsca_region.current = m_mission_wave_details.mission_type_limits.norsca_region.current + 1
			return true, mission_id, mission_key
		end
	end

	out.design("Failed to launch "..difficulty.." Norsca Settlement missions")
	-- No Valid Settlement Found
	return false
end



--------------------------------------------------------------
------------------ NATURAL CHAOS ARMY MISSION ----------------
--------------------------------------------------------------

local function start_natural_chaos_army_mission(difficulty)
	if(m_mission_wave_details.mission_type_limits.chaos_army.current < m_mission_wave_details.mission_type_limits.chaos_army.max) then
		local faction_list = cm:model():world():faction_list()
		local trimmed_army_list = {}

		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i)
			if(faction:is_human() == false) then
				local faction_culture = faction:culture()

				if(m_chaos_factions[faction_culture]) then
					local faction_character_list = faction:character_list()
					for j = 0, faction_character_list:num_items() - 1 do
						local character = faction_character_list:item_at(j)
						local faction_leader = character:is_faction_leader()
						if(is_blocked_faction(faction:name()) == false and faction:is_quest_battle_faction() == false and character:has_military_force() and character:in_settlement() == false and (faction_leader == false or faction_leader == m_force_difficulty_values[difficulty].can_be_leader) and character:is_at_sea() == false) then
							local region = character:region()
							if(region:is_null_interface() == false) then
								local region_key = region:name()
								local region_blocked = is_region_blocked(region_key)

								if(region_blocked == false) then
									-- filter armies based off difficulty and the strength of the army
									local military_force = character:military_force()
									local current_stance = military_force:active_stance()
									if(current_stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_AMBUSH" and current_stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SETTLE") then
										local upkeep = military_force:upkeep()
										local strength = military_force:strength()
										if(check_number_within_range(strength, m_force_difficulty_values[difficulty].strength_min, m_force_difficulty_values[difficulty].strength_max)) then
											local force_cqi = military_force:command_queue_index()
											table.insert(trimmed_army_list, {cqi = force_cqi, region = region_key})
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if(#trimmed_army_list > 0) then
			local mission_id = "oxy_natural_chaos_army_mission"
			local random_index = cm:random_number(#trimmed_army_list, 1)
			local target_army = trimmed_army_list[random_index].cqi
			local target_army_region = trimmed_army_list[random_index].region
			local mission_key = get_available_threat_mission_key(difficulty)

			log_new_active_threat_mission(mission_key, target_army_region, mission_id, difficulty, target_army)
			trigger_threat_mission(mission_key, difficulty, m_mission_config.chaos_army, target_army)
			log_army_mission_consequence(mission_key, target_army)

			out.design("starting chaos army mission with force cqi: "..target_army)

			m_mission_wave_details.mission_type_limits.chaos_army.current = m_mission_wave_details.mission_type_limits.chaos_army.current + 1
			return true, mission_id, mission_key
		end
	end

	out.design("Failed to launch "..difficulty.." Chaos Army mission")
	-- No valid armies found
	return false 
end



--------------------------------------------------------------
--------------- NATURAL CORRUPTED ARMY MISSION ---------------
--------------------------------------------------------------

local function start_natural_corrupted_army_mission(difficulty)
	if(m_mission_wave_details.mission_type_limits.corrupted_army.current < m_mission_wave_details.mission_type_limits.corrupted_army.max) then
		local faction_list = cm:model():world():faction_list()
		local trimmed_army_list = {}

		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i)
			if(faction:is_human() == false) then
				local faction_culture = faction:culture()
				local faction_key = faction:name()

				if(m_corrupted_factions[faction_culture] or m_corrupted_factions[faction_key]) then
					local faction_character_list = faction:character_list()
					for j = 0, faction_character_list:num_items() - 1 do
						local character = faction_character_list:item_at(j)
						local faction_leader = character:is_faction_leader()
						if(is_blocked_faction(faction:name()) == false and faction:is_quest_battle_faction() == false and character:has_military_force() and character:in_settlement() == false and (faction_leader == false or faction_leader == m_force_difficulty_values[difficulty].can_be_leader) and character:is_at_sea() == false) then
							local region = character:region()
							if(region:is_null_interface() == false) then
								local region_key = region:name()
								local region_blocked = is_region_blocked(region_key)

								if(region_blocked == false) then
									-- filter armies based off difficulty and the strength of the army
									local military_force = character:military_force()
									local current_stance = military_force:active_stance()
									if(current_stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_AMBUSH" and current_stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SETTLE") then
										local upkeep = military_force:upkeep()
										local strength = military_force:strength()
										if(check_number_within_range(strength, m_force_difficulty_values[difficulty].strength_min, m_force_difficulty_values[difficulty].strength_max)) then
											local force_cqi = military_force:command_queue_index()
											table.insert(trimmed_army_list, {cqi = force_cqi, region = region_key})
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if(#trimmed_army_list > 0) then
			local mission_id = "oxy_natural_corrupted_army_mission"
			local random_index = cm:random_number(#trimmed_army_list, 1)
			local target_army_region = trimmed_army_list[random_index].region
			local target_army = trimmed_army_list[random_index].cqi
			local mission_key = get_available_threat_mission_key(difficulty)

			log_new_active_threat_mission(mission_key, target_army_region, mission_id, difficulty, target_army)
			trigger_threat_mission(mission_key, difficulty, m_mission_config.corrupted_army, target_army)
 			log_army_mission_consequence(mission_key, target_army)

			out.design("starting corrupted army mission with force cqi: "..target_army)

			m_mission_wave_details.mission_type_limits.corrupted_army.current = m_mission_wave_details.mission_type_limits.corrupted_army.current + 1
			return true, mission_id, mission_key
		end
	end

	out.design("Failed to launch "..difficulty.." Corrupted Army missions")
	-- No valid armies found
	return false 
end



--------------------------------------------------------------
------------------ REGION ATTACK MISSION ----------------------
--------------------------------------------------------------

local function setup_region_defence_marker()
	m_region_razed_marker = Interactive_Marker_Manager:new_marker_type(m_region_marker_id, "oxyotl_chaos_mission", nil, 1, m_oxyotl_faction_key, nil, true)
	m_region_razed_marker:add_dilemma(m_dilemma_region_attack, true)
	m_region_razed_marker:despawn_on_interaction(true, 0)
	m_region_razed_marker:add_interaction_event("ScriptEventThreatMapDilemmaTriggered", nil, true)
end

local function log_region_marker_mission_consequence(mission_key, region_key)
	m_active_mission_consequences[mission_key].region_attacked = region_key
end

local function start_scripted_region_attack_mission(difficulty)
	-- This mission type can only be active one at a time to reduce impact around the map.
	if(m_mission_wave_details.mission_type_limits.region_marker.current < m_mission_wave_details.mission_type_limits.region_marker.max) then
		local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
		local region_list = oxyotl_faction:region_list()
		local region_count = region_list:num_items()
		local trimmed_region_list = {}
		
		if(region_count >= m_mission_config.region_marker.difficulty[difficulty]) then
			for j = 0, region_list:num_items() - 1 do
				local region = region_list:item_at(j)
				local region_name = region:name()
				local region_blocked = is_region_blocked(region_name)

				if(region_blocked == false) then
					local settlement = region:settlement()
					local x = settlement:logical_position_x()
					local y = settlement:logical_position_y()
					table.insert(trimmed_region_list, {region = region_name, x = x, y = y})
				end
			end
		end

		if(#trimmed_region_list > 0) then
			local mission_id = m_region_marker_id
			local random_index = cm:random_number(#trimmed_region_list, 1)
			local target_region = trimmed_region_list[random_index].region
			local coords = {x = trimmed_region_list[random_index].x, y = trimmed_region_list[random_index].y}
			local mission_key = get_available_threat_mission_key(difficulty)

			m_region_marker_mission_details.target_region = target_region
			m_region_marker_mission_details.mission_key = mission_key

			m_region_razed_marker = Interactive_Marker_Manager:get_marker(m_region_marker_id)
			m_region_razed_marker:spawn_at_region(target_region, false, false, true, 5, m_oxyotl_faction_key)	

			log_new_active_threat_mission(mission_key,target_region, mission_id, difficulty)
			trigger_threat_mission(mission_key, difficulty, m_mission_config.region_marker, target_region, coords, mission_id)
			log_region_marker_mission_consequence(mission_key, target_region)

			out.design("starting chaos region razed mission at: "..target_region)

			m_mission_wave_details.mission_type_limits.region_marker.current = m_mission_wave_details.mission_type_limits.region_marker.current + 1
			return true, mission_id, mission_key
		end
	end

	out.design("Failed to launch "..difficulty.." Region Marker mission")
	return false	
end



--------------------------------------------------------------
---------------- SPAWNED CHAOS ARMY MISSION ------------------
--------------------------------------------------------------

local function oxyotl_enable_raid_stance_listener()
	core:add_listener(
        "test_oxy_mission",
        "FactionTurnStart",
        function(context)
			local faction_name = context:faction():name()
			if(faction_name == m_oxyotl_faction_key and m_threat_map_missions_started == true) then
                return true
			end
			return false
        end,
		function(context)
			for k, v in ipairs(m_active_mission_details) do
				if(v.mission_type == "oxy_spawned_army_mission") then
					local general_cqi = cm:get_military_force_by_cqi(v.target_army):general_character():command_queue_index()
					cm:force_character_force_into_stance("character_cqi:"..general_cqi, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID")
				end
			end
        end,
        true
    )
end

local function spawn_threat_map_raiding_army(difficulty, region, no_upkeep)
	local no_upkeep = no_upkeep or false
	local faction_key = get_chaos_faction_force_details()
	local same_region, raiding = true, true
	local at_sea = false
	local spawn_distance = cm:random_number(m_spawn_distance.max, m_spawn_distance.min)
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region:name(), at_sea, same_region, spawn_distance)

	local invasion = spawn_army_for_faction(faction_key, x, y, difficulty, no_upkeep, raiding) 
	
	cm:force_declare_war(m_oxyotl_faction_key, faction_key, false, false)

	return invasion
end

local function start_scripted_roaming_chaos_army_mission(difficulty)
	if(m_mission_wave_details.mission_type_limits.spawned_army.current < m_mission_wave_details.mission_type_limits.spawned_army.max) then
		local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
		local region_list = oxyotl_faction:region_list()
		local trimmed_region_list = {}

		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i)
			local region_name = region:name()
			local region_blocked = is_region_blocked(region_name)

			if(region_blocked == false) then
				table.insert(trimmed_region_list, region)
			end
		end

		if(#trimmed_region_list > 0) then
			local mission_id = "oxy_spawned_army_mission"
			local random_index = cm:random_number(#trimmed_region_list, 1)
			local target_region = trimmed_region_list[random_index]
			local target_region_key = target_region:name()
			local no_upkeep = true
			local invasion = spawn_threat_map_raiding_army(difficulty, target_region, no_upkeep)
			local invasion_force = invasion:get_force()
			local invasion_force_cqi = invasion_force:command_queue_index()
			local mission_key = get_available_threat_mission_key(difficulty)

			log_new_active_threat_mission(mission_key, target_region_key, mission_id, difficulty, invasion_force_cqi)
			trigger_threat_mission(mission_key, difficulty, m_mission_config.spawned_army, invasion_force_cqi)

			out.design("spawning chaos army to raid at region: "..target_region_key)

			m_mission_wave_details.mission_type_limits.spawned_army.current = m_mission_wave_details.mission_type_limits.spawned_army.current + 1
			return true, mission_id, mission_key
		end
	end

	out.design("Failed to launch "..difficulty.." Raiding Army mission")
	-- No valid factions found
	return false
end



--------------------------------------------------------------
----------------- SANCTUM ATTACKED MISSION -------------------
--------------------------------------------------------------

local function setup_sanctum_defence_marker()
	m_sanctum_marker = Interactive_Marker_Manager:new_marker_type(m_sanctum_marker_id, "oxyotl_chaos_mission", nil, 1, m_oxyotl_faction_key, nil, true)
	m_sanctum_marker:add_dilemma(m_dilemma_sanctum_attack, true)
	m_sanctum_marker:despawn_on_interaction(true, 0)
	m_sanctum_marker:add_interaction_event("ScriptEventThreatMapDilemmaTriggered", nil, true)
end

local function log_sanctum_mission_consequence(mission_key, region_name)
	-- insert the failure function under the relevant mission key
	m_active_mission_consequences[mission_key].sanctum_attacked = region_name
end

local function start_scripted_defend_silent_sanctum_mission(difficulty)
	if(m_mission_wave_details.mission_type_limits.sanctum_defence.current < m_mission_wave_details.mission_type_limits.sanctum_defence.max) then
		local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
		local silent_sanctum_list = oxyotl_faction:foreign_slot_managers()
		local trimmed_region_list = {}
		local sanctum_count = silent_sanctum_list:num_items()

		if(sanctum_count >= m_mission_config.sanctum_defence.difficulty[difficulty]) then
			for i = 0, sanctum_count - 1 do
				local silent_sanctum = silent_sanctum_list:item_at(i)
				local sanctum_region = silent_sanctum:region()
				local region_name = sanctum_region:name()
				local region_blocked = is_region_blocked(region_name)

				if(region_blocked == false) then
					local settlement = sanctum_region:settlement()
					local x = settlement:logical_position_x()
					local y = settlement:logical_position_y()
					table.insert(trimmed_region_list, {region = region_name, x = x, y = y})
				end
			end

			if(#trimmed_region_list > 0) then
				local mission_id = m_sanctum_marker_id
				local random_index = cm:random_number(#trimmed_region_list, 1)
				local target_region = trimmed_region_list[random_index].region
				local coords = {x = trimmed_region_list[random_index].x, y = trimmed_region_list[random_index].y}
				local mission_key = get_available_threat_mission_key(difficulty)

				m_sanctum_marker_mission_details.target_region = target_region
				m_sanctum_marker_mission_details.mission_key = mission_key

				m_sanctum_marker = Interactive_Marker_Manager:get_marker(m_sanctum_marker_id)
				m_sanctum_marker:spawn_at_region(m_sanctum_marker_mission_details.target_region, false, false, true, 5, m_oxyotl_faction_key)	

				log_new_active_threat_mission(mission_key, target_region, mission_id, difficulty)
				trigger_threat_mission(mission_key, difficulty, m_mission_config.sanctum_defence, target_region, coords, mission_id)
				log_sanctum_mission_consequence(mission_key, target_region)

				out.design("start sanctum destruction mission at region: "..target_region)

				m_mission_wave_details.mission_type_limits.sanctum_defence.current = m_mission_wave_details.mission_type_limits.sanctum_defence.current + 1

				return true, mission_id, mission_key
			end
		end
	end

	out.design("Failed to launch "..difficulty.." Sanctum Defence mission")
	-- No valid sanctums found
	return false	
end



--------------------------------------------------------------
--------------------- MISSION MANAGER  -----------------------
--------------------------------------------------------------

local m_oxyotl_available_mission_difficulties = {
	-- this has to be below the mission function declarations to work.
	easy = {
		function(difficulty) return start_natural_herdstone_mission(difficulty) end,
		function(difficulty) return start_natural_norscan_region_mission(difficulty) end,
		function(difficulty) return start_natural_chaos_army_mission(difficulty) end,
		function(difficulty) return start_natural_corrupted_army_mission(difficulty) end,
		function(difficulty) return start_scripted_region_attack_mission(difficulty) end,
		function(difficulty) return start_scripted_roaming_chaos_army_mission(difficulty) end,
		function(difficulty) return start_scripted_defend_silent_sanctum_mission(difficulty) end
	},
	medium = {
		function(difficulty) return start_natural_herdstone_mission(difficulty) end,
		function(difficulty) return start_natural_norscan_region_mission(difficulty) end,
		function(difficulty) return start_natural_chaos_army_mission(difficulty) end,
		function(difficulty) return start_natural_corrupted_army_mission(difficulty) end,
		function(difficulty) return start_scripted_region_attack_mission(difficulty) end,
		function(difficulty) return start_scripted_roaming_chaos_army_mission(difficulty) end,
		function(difficulty) return start_scripted_defend_silent_sanctum_mission(difficulty) end
	},
	hard = {
		function(difficulty) return start_natural_herdstone_mission(difficulty) end,
		function(difficulty) return start_natural_norscan_region_mission(difficulty) end,
		function(difficulty) return start_natural_chaos_army_mission(difficulty) end,
		function(difficulty) return start_natural_corrupted_army_mission(difficulty) end,
		function(difficulty) return start_scripted_region_attack_mission(difficulty) end,
		function(difficulty) return start_scripted_roaming_chaos_army_mission(difficulty) end,
		function(difficulty) return start_scripted_defend_silent_sanctum_mission(difficulty) end
	}
}

local function reset_wave_mission_type_counts()
	m_mission_wave_details.mission_type_limits.herdstone.current = 0
	m_mission_wave_details.mission_type_limits.norsca_region.current = 0
	m_mission_wave_details.mission_type_limits.chaos_army.current = 0
	m_mission_wave_details.mission_type_limits.corrupted_army.current = 0
	m_mission_wave_details.mission_type_limits.region_marker.current = 0
	m_mission_wave_details.mission_type_limits.spawned_army.current = 0
	m_mission_wave_details.mission_type_limits.sanctum_defence.current = 0
end

local function oxyotl_threat_map_manager_listener()
	core:add_listener(
        "test_oxy_mission",
        "FactionTurnStart",
        function(context)
			local faction_name = context:faction():name()
			if(faction_name == m_oxyotl_faction_key and m_threat_map_missions_started == true) then
                return true
			end
			return false
        end,
		function(context)
			-- This function will control when new missions are issued and what difficulty they will be

			if(m_mission_wave_details.cooldown.current <= 0) then
				reset_wave_mission_type_counts()

				local wave_cooldown = cm:random_number(m_mission_wave_details.cooldown.max, m_mission_wave_details.cooldown.min)
				local mission_count = cm:random_number(m_mission_wave_details.mission_count.max, m_mission_wave_details.mission_count.min)
				m_mission_wave_details.cooldown.current = wave_cooldown

				out.design("Attempting to start "..mission_count.." Visions")

				for i = 1, mission_count do
					local mission_difficulty = select_mission_difficulty()
					local mission_roll_list = {}
					local mission_type, mission_key

					for i = 1, #m_oxyotl_available_mission_difficulties[mission_difficulty] do
						-- we create this table, so that if a chosen mission type returns false we can reroll after removing it's key number to avoid calling the same mission type again
						table.insert(mission_roll_list, i)
					end

					repeat
						local mission_choice_roll = cm:random_number(#mission_roll_list, 1)
						local mission_choice = m_oxyotl_available_mission_difficulties[mission_difficulty][mission_roll_list[mission_choice_roll]]
						
						table.remove(mission_roll_list, mission_choice_roll)

						mission_started, mission_type, mission_key = mission_choice(mission_difficulty)
					until mission_started == true or #mission_roll_list == 0

					if(mission_started) then
						out.design("----------------------------------------")
						out.design("starting new threat map mission")
						out.design("difficulty: "..mission_difficulty)
						out.design("mission type: "..mission_type)
						out.design("mission key: "..mission_key)
						out.design("----------------------------------------")
					else
						out.design("No valid missions launched")
					end
				end

				if(#m_active_mission_details <= 0) then
					-- no valid missions fired this wave, resetting cooldown to 0 so that it tries again next turn
					m_mission_wave_details.cooldown.current = 0
				end
			else
				out.design("Turns until next Visions wave: "..m_mission_wave_details.cooldown.current)
				m_mission_wave_details.incident_fired_this_turn = false

				if(#m_active_mission_details > 0 or m_mission_wave_details.cooldown.current <= 5) then
					m_mission_wave_details.cooldown.current = m_mission_wave_details.cooldown.current - 1
				else
					-- there are no active missions left and the cooldown is over 5 turns, reduce current cooldown to 5 turns.
					m_mission_wave_details.cooldown.current = 5
				end
			end
        end,
        true
    )
end



--------------------------------------------------------------
---------------------- DILEMMAS/MARKERS ----------------------
--------------------------------------------------------------

local function oxyotl_threat_dilemma_listeners()
	core:add_listener(
        "Oxy_ThreatMapArmyAttackDilemmaChoice",
        "DilemmaChoiceMadeEvent",
        function(context)
			local dilemma_key = context:dilemma()
            if(dilemma_key == m_dilemma_region_attack or dilemma_key == m_dilemma_sanctum_attack) then
                return true
			end
            return false
        end,
		function(context)
			local dilemma_key = context:dilemma()
			local choice = context:choice()
			local is_ambush, difficulty, mission_key, mission_id

			for k, v in ipairs(m_active_mission_details) do
				if(v.mission_type == m_region_marker_id and dilemma_key == m_dilemma_region_attack) then
					mission_key = v.mission_key
					mission_id = v.mission_type
					difficulty = v.difficulty
					is_ambush = true
					break
				end

				if(v.mission_type == m_sanctum_marker_id and dilemma_key == m_dilemma_sanctum_attack) then
					mission_key = v.mission_key
					mission_id = v.mission_type
					difficulty = v.difficulty
					is_ambush = true
					break
				end
			end

			if(choice == 0) then
				launch_scripted_battle(m_latest_marker_interaction_cqi, difficulty, is_ambush, mission_key, mission_id)
			end
        end,
        true
    )
end

local function oxyotl_threat_map_marker_interaction_listener()
	core:add_listener(
        "Oxy_ThreatMapMakerInteraction",
        "ScriptEventThreatMapDilemmaTriggered",
        true,
		function(context)
			m_latest_marker_interaction_cqi = context:character():military_force():command_queue_index()
        end,
        true
    )
end



--------------------------------------------------------------
--------------------- MISSION COMPLETION ---------------------
--------------------------------------------------------------

local function remove_threat_mission_from_active_list(mission_key)
	local table_index = false

	for k, v in ipairs(m_active_mission_details) do
		if(v.mission_key == mission_key) then

			-- remove any map markers from the map linked with this mission key
			if(v.mission_type == m_region_marker_id) then
				m_region_razed_marker = Interactive_Marker_Manager:get_marker(m_region_marker_id)
				m_region_razed_marker:despawn_all()
			end

			if(v.mission_type == m_sanctum_marker_id) then
				m_sanctum_marker = Interactive_Marker_Manager:get_marker(m_sanctum_marker_id)
				m_sanctum_marker:despawn_all()
			end

			m_active_mission_rewards[mission_key] = nil
			m_active_mission_consequences[mission_key] = nil

			table_index = k
			
			toggle_settlement_ai_targeting(v.region, false)
			update_blocked_region_list()
			break
		end
	end

	if(table_index ~= false) then
		table.remove(m_active_mission_details, table_index)
	end
end

local function oxyotl_threat_map_mission_success_listener()
	core:add_listener(
        "Oxy_ThreatMapMissionSuccess",
        "MissionSucceeded",
		function(context)
			return is_active_threat_map_mission(context:mission():mission_record_key())
		end,
		function(context)
			-- this event is used in other systems, such as standard missions
			local mission_key = context:mission():mission_record_key()
			local delay = 0.1
			
			if(mission_key == m_oxyotl_mission_keys.starting) then
				m_threat_map_missions_started = true
			end

			grant_mission_rewards(mission_key)

			cm:callback(function()
				-- we delay this so that follow up missions don't complete within the same tick which can cause a crash.
				core:trigger_event("ScriptEventOxyThreatMapSuccess")
			end, delay)
			
			remove_threat_mission_from_active_list(mission_key)
        end,
        true
    )
end

local function oxyotl_threat_map_mission_cancelled_listener()
	core:add_listener(
        "Oxy_ThreatMapMissionCancelled",
        "MissionCancelled",
		function(context)
			return is_active_threat_map_mission(context:mission():mission_record_key())
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()

			if(mission_key == m_oxyotl_mission_keys.starting) then
				m_threat_map_missions_started = true
			end

			remove_threat_mission_from_active_list(mission_key)
        end,
        true
    )
end

local function oxyotl_threat_map_mission_failed_listener()
	core:add_listener(
        "Oxy_ThreatMapMissionFailed",
        "MissionFailed",
		function(context)
			return is_active_threat_map_mission(context:mission():mission_record_key())
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()

			if(mission_key == m_oxyotl_mission_keys.starting) then
				m_threat_map_missions_started = true
			end

			perform_mission_consequences(mission_key)

			remove_threat_mission_from_active_list(mission_key)
        end,
        true
    )
end

local function oxyotl_narrative_movie_listeners()
	core:add_listener(
		"OxyotlMissionIssued",
		"MissionIssued",
		function(context)
			return context:mission():mission_record_key() == m_oxyotl_final_battle_key;
		end,
		function(context)
			core:svr_save_registry_bool("oxyotl_call_to_arms", true);
			cm:register_instant_movie(m_oxyotl_movie_path.."oxyotl_call_to_arms");
		end,
		false
	);
	
	core:add_listener(
		"OxyotlMissionSucceeded",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == m_oxyotl_final_battle_key;
		end,
		function(context)
			core:svr_save_registry_bool("oxyotl_win", true);
			cm:register_instant_movie(m_oxyotl_movie_path.."oxyotl_win");
		end,
		false
	);
end


--------------------------------------------------------------
--------------------------- SETUP ----------------------------
--------------------------------------------------------------

local function oxyotl_start_threat_map_feature_listener()
	core:add_listener(
		"Oxy_ThreatMapActivate",
		"FactionTurnStart",
		function(context)
			local faction = context:faction():name()

			if(faction == m_oxyotl_faction_key and cm:turn_number() == 1) then
				return true
			end

			return false
		end,
		function(context)
			start_starting_mission()
		end,
		false
	)
end

local function oxyotl_update_home_region_listener()
	core:add_listener(
		"Oxy_HomeRegionUpdate",
		"FactionTurnStart",
		function(context)
			local faction = context:faction():name()
			if(faction == m_oxyotl_faction_key) then
				return true
			end
			return false
		end,
		function(context)
			update_blocked_region_list()
		end,
		true
	)
end

local function oxyotl_remove_tresspass_listener()
	core:add_listener(
		"Oxy_RemoveTresspassPenalty",
		"FactionTurnStart",
		function(context)
			local faction = context:faction():name()
			if(faction == m_oxyotl_faction_key and cm:turn_number() == 1) then
				return true
			end
			return false
		end,
		function(context)
			local oxyotl = cm:get_faction(m_oxyotl_faction_key):faction_leader()
			cm:set_character_excluded_from_trespassing(oxyotl, true)
		end,
		true
	)
end

local function oxyotl_setup_mission_markers_listener()
	core:add_listener(
		"Oxy_RemoveTresspassPenalty",
		"FactionTurnStart",
		function(context)
			local faction = context:faction():name()
			if(faction == m_oxyotl_faction_key and cm:turn_number() == 1) then
				return true
			end
			return false
		end,
		function(context)
			setup_sanctum_defence_marker()
			setup_region_defence_marker()
		end,
		true
	)
end

function add_oxyotl_threat_map_listeners()
	local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
	
	if(oxyotl_faction) then
		local oxyotl_human = oxyotl_faction:is_human()

		if(oxyotl_human == true) then
			-- Player behaviour
			oxyotl_setup_mission_markers_listener()
			oxyotl_remove_tresspass_listener()
			oxyotl_update_home_region_listener()
			oxyotl_start_threat_map_feature_listener()
			oxyotl_reapply_mission_vision_listener()
			oxyotl_enable_raid_stance_listener()
			oxyotl_threat_map_manager_listener()
			oxyotl_threat_dilemma_listeners()
			oxyotl_threat_map_marker_interaction_listener()
			oxyotl_pre_battle_retreat_listener()
			oxyotl_post_battle_mission_completion_listener()
			oxyotl_threat_map_mission_success_listener()
			oxyotl_threat_map_mission_cancelled_listener()
			oxyotl_threat_map_mission_failed_listener()
			oxyotl_narrative_movie_listeners()
		else
			-- AI behaviour
			oxyotl_remove_tresspass_listener()
		end
	end
end



--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------


cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("oxy_map_missions_started", m_threat_map_missions_started, context)
		cm:save_named_value("oxy_map_region_marker", m_region_razed_marker, context)
		cm:save_named_value("oxy_map_sanctum_marker", m_sanctum_marker, context)
		cm:save_named_value("oxy_map_last_interaction_cqi", m_latest_marker_interaction_cqi, context)
		cm:save_named_value("oxy_map_invasion_count", m_invasion_count, context)
		cm:save_named_value("oxy_map_active_missions", m_active_mission_details, context)
		cm:save_named_value("oxy_map_active_consequences", m_active_mission_consequences, context)
		cm:save_named_value("oxy_map_active_rewards", m_active_mission_rewards, context)
		cm:save_named_value("oxy_map_blocked_regions", m_blocked_region_list, context)
		cm:save_named_value("oxy_map_region_marker_details", m_region_marker_mission_details, context)
		cm:save_named_value("oxy_map_sanctum_marker_details", m_sanctum_marker_mission_details, context)
		cm:save_named_value("oxy_map_wave_details", m_mission_wave_details, context)
		cm:save_named_value("oxy_scripted_battle_details", m_scripted_battle_active, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			m_threat_map_missions_started = cm:load_named_value("oxy_map_missions_started", m_threat_map_missions_started, context)
			m_region_razed_marker = cm:load_named_value("oxy_map_region_marker", m_region_razed_marker, context)
			m_sanctum_marker = cm:load_named_value("oxy_map_sanctum_marker", m_sanctum_marker, context)
			m_latest_marker_interaction_cqi = cm:load_named_value("oxy_map_last_interaction_cqi", m_latest_marker_interaction_cqi, context)
			m_invasion_count = cm:load_named_value("oxy_map_invasion_count", m_invasion_count, context)
			m_active_mission_details = cm:load_named_value("oxy_map_active_missions", m_active_mission_details, context)
			m_active_mission_consequences = cm:load_named_value("oxy_map_active_consequences", m_active_mission_consequences, context)
			m_active_mission_rewards = cm:load_named_value("oxy_map_active_rewards", m_active_mission_rewards, context)
			m_blocked_region_list = cm:load_named_value("oxy_map_blocked_regions", m_blocked_region_list, context)
			m_region_marker_mission_details = cm:load_named_value("oxy_map_region_marker_details", m_region_marker_mission_details, context)
			m_sanctum_marker_mission_details = cm:load_named_value("oxy_map_sanctum_marker_details", m_sanctum_marker_mission_details, context)
			m_mission_wave_details = cm:load_named_value("oxy_map_wave_details", m_mission_wave_details, context)
			m_scripted_battle_active = cm:load_named_value("oxy_scripted_battle_details", m_scripted_battle_active, context)
		end
	end
)