ERUIObject = {
    -- Enhanced rebellion reference
    ER = {},
    -- Compatibility bools
    AbandonRegionEnabled = false,
    -- Vanilla object references
    core = {},
    rename_button = nil,
    -- Frames

    -- UI Paths
    Icons = {},
    -- New button references
    Buttons = {},
    -- Tracked data
    TrackedData = {},
    -- Logger
    Logger = {},
}

function ERUIObject:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function ERUIObject:Initialise(core, er, enableLogging)
    self.core = core;
    self.ER = er;
    -- Check compatbility options
    if core:is_mod_loaded("sm0_abandon") then
        self.AbandonRegionEnabled = true;
    else
        self.AbandonRegionEnabled = false;
    end
    -- Initialise Icon resources
    self.Icons = {
        er_military_crackdown = "ui/campaign ui/edicts/wh_main_edict_give_it_ere.png",
        er_deploy_agents = "ui/campaign ui/edicts/wh_main_edict_state_troop_levy.png",
    };
    -- Initialise with ER main data
    self.TrackedData["player_faction_key"] = er.HumanFaction:name();
    -- Initialise logging
    self.Logger = Logger:new({});
    self.Logger:Initialise("ERUIObject.txt", enableLogging);
    self.Logger:Log_Start();
end

function ERUIObject:CreateButton(buttonId)
    local button = self.Buttons[buttonId];
    local buttonResources = self.Icons[buttonId];
    if buttonResources ~= nil then
        if Button == nil then
            self.Logger:Log("ERROR: Missing UIMF");
            self.Logger:Log_Finished();
            return;
        elseif button == nil then
            --self.Logger:Log("Creating button reference: "..buttonId);
            button = Button.new(buttonId, find_uicomponent(core:get_ui_root(), "settlement_panel"), "SQUARE", buttonResources);
            -- Setup click events
            button:RegisterForClick(
                function(context)
                    local selectedRegionKey = self.TrackedData["selected_region_key"];
                    if buttonId == "er_military_crackdown" then
                        self.Logger:Log("Triggering military crackdown dilemma for region: "..selectedRegionKey);
                        self.ER:TriggerCrackDownDilemma(selectedRegionKey);
                    else
                        self.Logger:Log("Triggering agent deploy dilemma for region: "..selectedRegionKey);
                        self.ER:TriggerAgentDeployDilemma(selectedRegionKey);
                    end
                end
            );
        end
        self.rename_button = find_uicomponent(core:get_ui_root(), "settlement_panel", "button_rename");
        button:Resize(self.rename_button:Width(), self.rename_button:Height());
        local xPos = self.rename_button:Width();
        local numberOfExtraIcons = 1;
        if self.AbandonRegionEnabled == true then
            numberOfExtraIcons = numberOfExtraIcons + 1;
        end
        if buttonId == "er_deploy_agents" then
            numberOfExtraIcons = numberOfExtraIcons + 1;
        end
        xPos = xPos * numberOfExtraIcons + numberOfExtraIcons;
        --self.Logger:Log("xPos is: "..xPos);
        button:PositionRelativeTo(self.rename_button, xPos, 0);
        -- Setup tooltips
        button:SetState("hover");
        local localisedTooltip = effect.get_localised_string(buttonId.."_tooltip");
        --self.Logger:Log("Tooltip is: "..localisedTooltip);
        button.uic:SetTooltipText(localisedTooltip);
        -- Reset to default state
        button:SetState("active");
        self.Buttons[buttonId] = button;
        --self.Logger:Log("Created button reference: "..buttonId);
        --self.Logger:Log_Finished();
    end
end

function ERUIObject:DeleteButton(buttonId)
    local button = self.Buttons[buttonId];
    if button ~= nil then
        button:Delete();
        self.Buttons[buttonId] = nil;
    end
end

function ERUIObject:SetSelectedRegionData(context)
    local trackedData = self.TrackedData;
    trackedData["selected_region_key"] = context:garrison_residence():region():name();
    trackedData["selected_faction_key"] = context:garrison_residence():faction():name();
end

function ERUIObject:UpdateButtons()
    self.Logger:Log("UpdateButtons");
    local selectedFaction = self.TrackedData["selected_faction_key"];
    local humanFactionKey = self.TrackedData["player_faction_key"];
    self.Logger:Log("Selected faction is: "..selectedFaction);
    self.Logger:Log("Human faction is: "..humanFactionKey);
    if selectedFaction ~= nil then
        -- First check if the settlement selected is actualy our settlement
        local buttonState = selectedFaction ~= humanFactionKey;
        -- Then check if we are in a cooldown period for military crackdowns
        if buttonState == false then
            buttonState = self.ER:IsActiveMilitaryCrackDown(humanFactionKey, true);
        end
        --self.Logger:Log("buttonState is: "..tostring(buttonState));
        local militaryCrackDownButton = self.Buttons["er_military_crackdown"];
        if militaryCrackDownButton ~= nil then
            militaryCrackDownButton:SetDisabled(buttonState);
        end
        local deployAgentsButton = self.Buttons["er_deploy_agents"];
        if deployAgentsButton ~= nil then
            local selectedRegionKey = self.TrackedData["selected_region_key"];
            if selectedRegionKey ~= nil then
                buttonState = not self.ER:IsAvailableAgentDeployDilemma(selectedRegionKey);
                deployAgentsButton:SetDisabled(buttonState);
            end
        end
    end
    self.Logger:Log_Finished();
end
