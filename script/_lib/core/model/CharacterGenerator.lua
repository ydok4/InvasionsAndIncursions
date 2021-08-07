require 'script/_lib/core/model/Logger';

CharacterGenerator = {
    Logger = {},
};

function CharacterGenerator:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function CharacterGenerator:Initialise(enableLogging)
    self.Logger = Logger:new({});
    self.Logger:Initialise("CharacterGenerator.txt", enableLogging);
    self.Logger:Log_Start();
    require 'script/_lib/dbexports/AgentDataResources'
    require 'script/_lib/dbexports/NameGenerator/SubCultureNameGroupResources'
    require 'script/_lib/dbexports/NameGenerator/NameGroupResources'
    require 'script/_lib/dbexports/NameGenerator/NameResources'
    -- Load the name resources
    -- This is separate so I can use this in other mods
    if not _G.CG_NameResources then
        _G.CG_NameResources = {
            ConcatTableWithKeys = function(self, destinationTable, sourceTable)
                for key, value in pairs(sourceTable) do
                    destinationTable[key] = value;
                end
            end,
            subculture_to_name_groups = GetSubCultureNameGroupResources(),
            faction_to_name_groups = GetNameGroupResources(),
            name_groups_to_names = GetNameResources(),
            campaign_character_data = GetAgentDataResources(),
        };
    end
    -- Load add ons
    -- Load Gunking's elf names (deprecated)
    --[[local newElfNameKey = effect.get_localised_string("names_name_1550000001");
    if newElfNameKey ~= nil
    and newElfNameKey ~= "" then
        require 'script/_lib/dbexports/NameGenerator/GunkingElfNameGroupResources'
        require 'script/_lib/dbexports/NameGenerator/GunkingElfNameResources'
        --self.Logger:Log("NameGenerator: Loading Gunking Elf Names");
        _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.name_groups_to_names, GetGunkingElfNameResources());
        _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.faction_to_name_groups, GetGunkingElfNameGroupResources());
    end
    -- Load Gunking's skaven/lizardmen names (deprecated)
    local newSkavenLizardmenNameKey = effect.get_localised_string("names_name_1313000111");
    if newSkavenLizardmenNameKey ~= nil
    and newSkavenLizardmenNameKey ~= "" then
        require 'script/_lib/dbexports/NameGenerator/GunkingSkavenLizardmenNameGroupResources'
        require 'script/_lib/dbexports/NameGenerator/GunkingSkavenLizardmenNameResources'
        --self.Logger:Log("NameGenerator: Loading Gunking Skaven/Lizardmen Names");
        _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.name_groups_to_names, GetGunkingSkavenLizardmenNameResources());
        _G.CG_NameResources:ConcatTableWithKeys(_G.CG_NameResources.faction_to_name_groups, GetGunkingSkavenLizardmenNameGroupResources());
    end--]]
end

function CharacterGenerator:GetArtSetForSubType(subType)
    if not _G.CG_NameResources then
        self.Logger:Log("ERROR: Missing Name resources");
        return;
    end
    self.Logger:Log("Getting art set for sub type: "..subType);
    local subTypeData = _G.CG_NameResources.campaign_character_data[subType];
    if subTypeData == nil then
        self.Logger:Log("ERROR: Missing SubTypeData");
        return nil;
    end
    if subTypeData.ArtSetIds == nil then
        self.Logger:Log("ERROR: Missing subtype ArtSetIds");
        return nil;
    end
    local artSetId = GetRandomObjectFromList(subTypeData.ArtSetIds);
    self.Logger:Log_Finished();
    return artSetId;
end

function CharacterGenerator:GetSubtypeData(subType)
    if not _G.CG_NameResources then
        self.Logger:Log("ERROR: Missing Name resources");
        return;
    end
    return _G.CG_NameResources.campaign_character_data[subType];
end

function CharacterGenerator:GetAgentTypeForSubtype(subType)
    if not _G.CG_NameResources then
        self.Logger:Log("ERROR: Missing Name resources");
        return;
    end
    self.Logger:Log("Getting agent type for sub type: "..subType);
    local subTypeData = _G.CG_NameResources.campaign_character_data[subType];
    if subTypeData == nil then
        self.Logger:Log("ERROR: Missing SubTypeData");
        return nil;
    end
    if subTypeData.AgentType == nil then
        self.Logger:Log("ERROR: Missing subtype AgentType");
        return nil;
    end
    return subTypeData.AgentType;
end

function CharacterGenerator:GetValidAgentArtSetForFaction(faction)
    local currentFactionPools = self:GetCurrentPoolForFaction(faction);
    currentFactionPools["total"] = nil;
    local agentSubType = GetRandomObjectKeyFromList(currentFactionPools);
    self.Logger:Log("Selected random agent sub type "..agentSubType);

    if agentSubType == "vmp_lord_replacement" then
        self.Logger:Log("Current faction pools is null, try and get an art set from the faction pool resources");
        local factionPoolResources = GetFactionPoolResources(faction);
        --self.Logger:Log("Got faction pools resources for faction");
        local poolData = GetRandomObjectFromList(factionPoolResources.FactionPools);
        --self.Logger:Log("Got poolkey");
        local agentSubTypeKey = GetRandomObjectKeyFromList(poolData.AgentSubTypes);
        --self.Logger:Log("Selected "..agentSubTypeKey);
        local artSetId = self:GetArtSetForSubType(agentSubTypeKey);
        --self.Logger:Log("Got artset "..artSetId);
        return artSetId;
    end

    local artSetId = self:GetArtSetForSubType(agentSubType);
    --self.Logger:Log("Selected random art set for sub type: "..artSetId);
    return artSetId;
end

function CharacterGenerator:GetRegionForFaction(faction)
    if faction:home_region() and faction:home_region():is_null_interface() == false then
        return faction:home_region():name();
    else
        return "";
    end
end

function CharacterGenerator:GetCharacterNameForSubculture(faction, agentSubType)
    local factionName = faction:name();
    if factionName == "wh_main_grn_skull-takerz" then
        factionName = "wh_main_grn_skull_takerz";
    end
    local factionSubculture = faction:subculture();

    local nameGroup = -1;
    local dbFactionNameGroup = _G.CG_NameResources.faction_to_name_groups[factionName];
    if dbFactionNameGroup ~= nil then
        nameGroup = dbFactionNameGroup.NameGroup;
    else
        local factionSubCulture = faction:subculture();
        local dbSubcultureNameGroup = _G.CG_NameResources.subculture_to_name_groups[factionSubCulture];
        if dbSubcultureNameGroup ~= nil then
            nameGroup = dbSubcultureNameGroup.NameGroup;
        end
    end

    nameGroup = "name_group_"..nameGroup;
    self.Logger:Log("Getting name for "..nameGroup);
    local namePool = _G.CG_NameResources.name_groups_to_names[nameGroup];
    local canUseFemaleNames = self:GetGenderForAgentSubType(agentSubType);
    --self.Logger:Log("Got agent subtype gender for: "..agentSubType);
    local doOnce = false;
    local nameKey = "";
    local forename_object = "";
    local family_name_object = "";
    local family_name_chance = self:GetFamilyNameChance(factionSubculture);
    --self.Logger:Log("Family name chance: "..family_name_chance);
    local factionLords = {};
    local failSafe = 0;
    if namePool == nil then
        self.Logger:Log("ERROR: Missing name pool");
        return nil;
    end
    while doOnce == false or factionLords == nil or factionLords[nameKey] ~= nil or nameKey == "" do
        --self.Logger:Log("Before get forename");
        forename_object = self:GetValidNameForType(namePool, canUseFemaleNames, "forename");
        if Roll100(family_name_chance) then
            --self.Logger:Log("Before get family_name");
            family_name_object = self:GetValidNameForType(namePool, canUseFemaleNames, "family_name");
        else
            family_name_object = {};
            family_name_object.Text = "";
            family_name_object.Id = "";
        end
        --self.Logger:Log("Before get namekey");
        nameKey = forename_object.Text..family_name_object.Text;
        nameKey = CreateValidLuaTableKey(nameKey);
        self.Logger:Log("Generated name key is "..nameKey);
        doOnce = true;
        if factionLords == nil and nameKey ~= "" then
            self.Logger:Log("No tracked lords. Using first generated name.");
            break;
        elseif failSafe == 5 then
            self.Logger:Log("ERROR: Not able to generate name");
            return nil;
        else
            failSafe = failSafe + 1;
        end
    end
    -- Yeah...these swapped.
    local generatedName = {
        clan_name = forename_object.Id,
        forename = family_name_object.Id,
    };
    self.Logger:Log_Finished();
    --self.Logger:Log("Got generated name");
    return generatedName;
end

function CharacterGenerator:GetFamilyNameChance(factionSubculture)
    if factionSubculture == "wh_main_sc_chs_chaos" then
        return 100 - 60;
    elseif factionSubculture == "wh2_main_sc_skv_skaven" then
        return 100 - 75;
    elseif factionSubculture == "wh_main_sc_nor_norsca" then
        return 100 - 30;
    elseif factionSubculture == "wh_dlc03_sc_bst_beastmen" then
        return 100 - 75;
    elseif factionSubculture == "wh_main_sc_grn_greenskins" or factionSubculture == "wh_main_sc_grn_savage_orcs" then
        return 100 - 40;
    end
    return 100;
end

function CharacterGenerator:GetValidNameForType(namePool, canUseFemaleNames, nameType)
    local nameTypes = nil;
    if canUseFemaleNames and nameType == "clan_name" then
        nameTypes = namePool.Gender["f"][nameType];
    else
        if namePool.Gender["m"] ~= nil and namePool.Gender["b"]  ~= nil then
            if namePool.Gender["m"][nameType] ~= nil then
                nameTypes = {};
                ConcatTableWithKeys(nameTypes, namePool.Gender["m"][nameType]);
            end
            if namePool.Gender["b"][nameType] ~= nil then
                if nameTypes == nil then
                    nameTypes = {};
                end
                ConcatTableWithKeys(nameTypes, namePool.Gender["b"][nameType]);
            end
        elseif namePool.Gender["m"] ~= nil then
            nameTypes = namePool.Gender["m"][nameType];
        elseif namePool.Gender["b"]  ~= nil then
            nameTypes = namePool.Gender["b"][nameType];
        end
    end

    if nameTypes ~= nil then
        --self.Logger:Log("Before");
        local randomName = GetRandomObjectKeyFromList(nameTypes);
        --self.Logger:Log("Generating name "..randomName);
        local nameId = nameTypes[randomName];
        --self.Logger:Log("Name id "..nameId);
        local nameObject = {
            Id = "names_name_"..tostring(nameId),
            Text = randomName,
        };
        return nameObject;
    end
    local nameObject = {
        Id = "",
        Text = "",
    };
    return nameObject;
end

function CharacterGenerator:GetGenderForAgentSubType(agentSubType)
    local agentResources = _G.CG_NameResources.campaign_character_data[agentSubType];
    if agentResources ~= nil then
        return agentResources.IsFemale == "true";
    end
    self.Logger:Log("Error: Could not find agent resources for subtype: "..agentSubType);
end

function CharacterGenerator:GetRandomCharacterTrait(faction, generalSubType)
    local subculture = faction:subculture();
    local factionName = faction:name();
    if factionName == "wh_main_grn_skull-takerz" then
        factionName = "wh_main_grn_skull_takerz";
    end

    local cultureData = _G.CRPResources.RecruitmentPoolResources[subculture];
    if cultureData == nil then
        cultureData = _G.CRPResources.RecruitmentPoolResources["wh_rogue_armies"];
    end

    local defaultSubCultureData = cultureData[subculture];

    local cultureTraits = {};
    local foundCultureTraits = false;
    -- Get traits for the subculture
    if defaultSubCultureData ~= nil and defaultSubCultureData.Traits ~= nil then
        ConcatTableWithKeys(cultureTraits, defaultSubCultureData.Traits);
        foundCultureTraits = true;
    end

    local defaultFactionData = cultureData[factionName];
    -- Then get the traits for the factions
    if defaultFactionData ~= nil and defaultFactionData.Traits ~= nil then
        ConcatTableWithKeys(cultureTraits, defaultFactionData.Traits);
        foundCultureTraits = true;
    end

    if defaultFactionData ~= nil and defaultFactionData.ExcludedTraits ~= nil then
        -- Then remove any excluded traits
        for index, traitKey in pairs(defaultFactionData.ExcludedTraits) do
            if cultureTraits[traitKey] ~= nil then
                cultureTraits[traitKey] = nil;
            end
        end
    end

    -- There is a flat 50% chance to get a culture / faction trait
    if foundCultureTraits == true and Roll100(50) then
        return GetRandomObjectKeyFromList(cultureTraits);
    end

    -- Otherwise get a random trait from the shared traits
    local sharedTraits = _G.CRPResources.RecruitmentPoolResources["shared"]["shared"].Traits;

    if defaultFactionData ~= nil and defaultFactionData.ExcludedTraits ~= nil then
        -- Then remove any excluded traits
        for index, traitKey in pairs(defaultFactionData.ExcludedTraits) do
            if sharedTraits[traitKey] ~= nil then
                sharedTraits[traitKey] = nil;
            end
        end
    end

    if defaultSubCultureData ~= nil and defaultSubCultureData.ExcludedTraits ~= nil then
        -- Then remove any excluded traits
        for index, traitKey in pairs(defaultSubCultureData.ExcludedTraits) do
            if sharedTraits[traitKey] ~= nil then
                sharedTraits[traitKey] = nil;
            end
        end
    end

    return GetRandomObjectKeyFromList(sharedTraits)
end

function CharacterGenerator:GetRandomTraitForLord(factionPoolResources, originalSubType)
    --self.Logger:Log("Getting random trait for originalSubType "..originalSubType);
    if factionPoolResources.LordsToReplace == nil then
        --self.Logger:Log("No lords to replace");
        return "";
    end
    local traitPool = factionPoolResources.LordsToReplace[originalSubType].traitKeyPool;
    if traitPool == nil then
        --self.Logger:Log("Trait pool is null");
        return "";
    end
    local selectedTrait = GetRandomObjectFromList(traitPool);
    --self.Logger:Log("Trait selected: "..selectedTrait)
    return selectedTrait;
end