require 'script/_lib/core/model/ERUIObject';

function ER_SetupPostUIInterfaceListeners(er, core, enableLogging)
    local uiObject = ERUIObject:new({

    });
    ERUIObject:Initialise(core, er, enableLogging);

    core:add_listener(
        "ER_SettlementPanelOpened",
        "PanelOpenedCampaign",
        function(context)
            return context.string == "settlement_panel";
        end,
        function(context)
            er.Logger:Log("Settlement panel opened");
            uiObject:CreateButton("er_military_crackdown");
            uiObject:CreateButton("er_deploy_agents");
            uiObject:UpdateButtons();
            er.Logger:Log("Settlement panel buttons initialised");
            er.Logger:Log_Finished();
        end,
        true
    );

    core:add_listener(
        "ER_SettlementPanelClosed",
        "PanelClosedCampaign",
        function(context)
            return context.string == "settlement_panel";
        end,
        function(context)
            er.Logger:Log("Settlement panel closed");
            uiObject:DeleteButton("er_military_crackdown");
            uiObject:DeleteButton("er_deploy_agents");
            er.Logger:Log_Finished();
        end,
        true
    );

    core:add_listener(
        "ER_SettlementSelected",
        "SettlementSelected",
        function(context)
            return true;
        end,
        function(context)
            --er.Logger:Log("Settlement selected");
            er.Logger:Log_Finished();
            uiObject:SetSelectedRegionData(context);
            cm:callback(function(context)
                uiObject:CreateButton("er_military_crackdown");
                uiObject:CreateButton("er_deploy_agents");
                uiObject:UpdateButtons();
                er.Logger:Log_Finished();
            end,
            0);
            --er.Logger:Log("Settlement selected completed");
            --er.Logger:Log_Finished();
        end,
        true
    );
end