--[[function a_er_deco_patch()
    local anyLoaded = false;
    if effect.get_localised_string("agent_subtypes_description_text_override_bst_bray_shaman_wild") ~= "" then
        out("EnR: Loading Deco Beastmen data");
        require 'script/_lib/pooldata/RebelArmyArchetypesPoolData/DecoBeastmenRebelArmyArchetypesPoolDataResources'
        _G.ERResources.AddAdditionalRebelArmyArchetypesResources("wh_dlc03_sc_bst_beastmen", GetDecoBeastmenRebelArmyArchetypesPoolDataResources(), false);
        anyLoaded = true;
    end

    if anyLoaded == true then
        require 'script/_lib/dbexports/DecoDataResources'
        out("EnR: Loading Deco agent data");
        -- Load the name resources
        -- This is separate so I can use this in other mods
        if _G.CG_NameResources then
            _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.campaign_character_data, GetDecoAgentDataResources());
        end
    end
end--]]
