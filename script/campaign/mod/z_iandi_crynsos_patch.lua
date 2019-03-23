require 'script/_lib/pooldata/CrynsosDelayedStartPoolData'

out("I&I: Loading Crynsos Data");
IandI_Log("Loading Crynsos Data");
IandI_Log_Finished();

if _G.I_I_Data ~= nil then
    _G.I_I_Data.AddAdditionalDBResources("DelayedStart", DelayedStartPoolData);
else
    IandI_Log("Global I_I_Data is not defined");
end

IandI_Log_Finished();