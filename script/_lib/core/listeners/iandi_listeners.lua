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
            local turnNumber = cm:model():turn_number();
            IandI_Log("Checking upcoming events for turn "..turnNumber);
            if not IandI then
                IandI_Log("IandI is not defined");
                return;
            end

            if not IandI.UpcomingEventsStack[1] then
                IandI_Log("There is no upcoming event");
            else
                local nextEvent = IandI.UpcomingEventsStack[1];
                if nextEvent ~= nil and nextEvent.TurnNumber ~= turnNumber then
                    IandI_Log("There is no event for this turn. Next event is: "..nextEvent.TurnNumber);
                end
                while nextEvent ~= nil and nextEvent.TurnNumber == turnNumber do
                    IandI_Log("Spawning event for "..nextEvent.Type.." Key: "..nextEvent.Key);
                    IandI:StartEvent(nextEvent);
                    nextEvent = IandI.UpcomingEventsStack[1];
                end
            end
            IandI_Log_Finished();
        end,
        true
    );
    IandI_Log("Finished IandI Post UI Listener Setup");
    IandI_Log_Finished();
end

function SetupEventCompleteListers(IandI, forceKey, event, eventData)
    IandI_Log("SetupEventCompleteListers");
    if not core then
        IandI_Log("Error: core is not defined");
        return;
    end
    local eventKey = GetEventTypeFromInvasionObjective(eventData.EmergeData.IMData.Target[event.SubcultureTarget]);
    local imData = eventData.EmergeData.IMData.Target[event.SubcultureTarget];
    core:add_listener(
        "IandI_EventCompleteListener"..forceKey,
        eventKey,
        function(context)
            return context:character():faction():name() == imData.FactionKey;
        end,
        function(context)
            IandI_Log("Getting invasion by forceKey: "..forceKey);
            if not IandI then
                IandI_Log("IandI is not defined");
            end
            if not IandI.invasion_manager then
                IandI_Log("Invasion manager is not defined");
            end
            local eventInvasion = IandI.invasion_manager:get_invasion(forceKey);
            IandI_Log("Got invasion");
            -- Release the ai, be free!
            eventInvasion:release();
            IandI.ActiveEventsStack[forceKey] = nil;
            IandI_Log("Released Faction");
            IandI_Log_Finished();
        end,
        false
    );
    IandI_Log_Finished();
end

function GetEventTypeFromInvasionObjective(target)
    if target.Type == "REGION" then
        IandI_Log("Creating listener for GarrisonOccupiedEvent");
        return "GarrisonOccupiedEvent";
    end
end