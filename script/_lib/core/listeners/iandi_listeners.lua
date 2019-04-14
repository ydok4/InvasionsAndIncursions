core = nil;
find_uicomponent = nil
UIComponent = nil;

IandI_Log("Loading Listeners");
out("I&I: Loading listeners");
function InitialiseIandIListenerData(coreObject, find_uicomponent_object, UIComponentObject)
    out("I&I: SetupListeners");
    IandI_Log("InitialiseIandIListenerData");
    core = coreObject;
    find_uicomponent = find_uicomponent_object;
    UIComponent = UIComponentObject;
    IandI_Log_Finished();
end

function SetupIandIPostUIListeners(IandI)
    IandI_Log("Initialising post UI listeners");
    if not core then
        IandI_Log("Error: core is not defined");
        return;
    end

    IandI_Log("IandI_FactionTurnEnd Setup");
    core:add_listener(
        "IandI_FactionTurnEnd",
        "FactionTurnEnd",
        function(context)
            return context:faction():name() == IandI.HumanFaction:name();
        end,
        function(context)
            StartEventsForTurn(IandI);
        end,
        true
    );
    IandI_Log("Finished IandI Post UI Listener Setup");
    IandI_Log_Finished();
end

function StartEventsForTurn(IandI)
    local turnNumber = cm:model():turn_number();
    IandI_Log("Checking upcoming events for turn "..turnNumber);
    if not IandI then
        IandI_Log("IandI is not defined");
        return;
    end

    local nextEvent = IandI:GetNextEvent();
    if not nextEvent then
        IandI_Log("There is no upcoming event");
    else
        if nextEvent.TurnNumber ~= turnNumber then
            IandI_Log("There is no event for this turn. Next event is: "..nextEvent.TurnNumber);
        else
            -- First we start any delayed start events on this turn
            IandI:StartEventTypeOnTurn(turnNumber, "DelayedStart");
            -- Then we start any invasions due on this turn
            IandI:StartEventTypeOnTurn(turnNumber, "Invasions");
            -- Then we start any incursions on this turn
            IandI:StartEventTypeOnTurn(turnNumber, "Incursions");
            -- NOTE: The above orders are important because if an Incursion triggers in an
            -- area which already has an invasion it will trigger reinforcements.
            -- Similarly, delayed start events can be flagged as an Invasion or Incursion and
            -- we want to prioritse those over generic Invasion and Incursions
        end
    end
    IandI:CleanUpActiveEventForces();
    IandI_Log_Finished();
end

function SetupEventCompleteListers(IandI, event, factionKey, eventData)
    IandI_Log("SetupEventCompleteListeners");
    if not core then
        IandI_Log("Error: core is not defined");
        return;
    end
    local eventKey = GetListenerEventTypeFromInvasionObjective(eventData.IMData.TargetData.Type);
    core:add_listener(
        "IandI_EventCompleteListener"..event.ForceKey,
        eventKey,
        function(context)
            return context:character():faction():name() == factionKey;
        end,
        function(context)
            IandI_Log("Getting invasion by forceKey: "..event.ForceKey);
            if not IandI then
                IandI_Log("IandI is not defined");
            end
            if not IandI.invasion_manager then
                IandI_Log("Invasion manager is not defined");
            end
            local eventInvasion = IandI.invasion_manager:get_invasion(event.ForceKey);
            if not eventInvasion then
                IandI_Log("Missing event invasion, not releasing AI because it can't be found");
            end

            -- Release the ai, be free!
            IandI_Log("Releasing invasion for faction "..factionKey);
            eventInvasion:release();
            IandI_Log("Released faction");
            IandI:CleanUpActiveForce(event);
            IandI_Log_Finished();
        end,
        false
    );
    IandI_Log_Finished();
end

function GetListenerEventTypeFromInvasionObjective(targetType)
    if targetType == "REGION" then
        IandI_Log("Creating listener for GarrisonOccupiedEvent");
        return "GarrisonOccupiedEvent";
    end
end