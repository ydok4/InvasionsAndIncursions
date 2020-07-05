local er_public_order_expanded = mct:register_mod("er_public_order_expanded");

-- Set main localisation
er_public_order_expanded:set_title("Public Order Expanded");
er_public_order_expanded:set_author("PrussianWarfare and Ydok4");
er_public_order_expanded:set_description("Controls spawn options for incursion armies.");

local enable_corruption_armies = er_public_order_expanded:add_new_option("enable_corruption_armies", "checkbox");
enable_corruption_armies:set_default_value(true);
enable_corruption_armies:set_text("Enable corruption armies");
enable_corruption_armies:set_tooltip_text("When this is selected, more powerful armies can spawn when corruption is higher. This option is only for the player.");

local enable_incursions = er_public_order_expanded:add_new_option("enable_rebellions", "checkbox");
enable_incursions:set_default_value(true);
enable_incursions:set_text("Enable incursions");
enable_incursions:set_tooltip_text("When this is selected, incursion armies can spawn at low public order");