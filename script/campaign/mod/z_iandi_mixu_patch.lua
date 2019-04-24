require 'script/_lib/pooldata/MixuAreaPoolData'
require 'script/_lib/pooldata/MixuIncursionPoolData'
require 'script/_lib/pooldata/MixuInvasionPoolData'

require 'script/_lib/dbexports/MixuDataResources'

out("I&I: Loading Mixu Data");
IandI_Log("Loading Mixu Data");
IandI_Log_Finished();

if _G.I_I_Data ~= nil then
    _G.I_I_Data.AddAdditionalDBResources("Incursions", MixuIncursionPoolData);
    _G.I_I_Data.AddAdditionalDBResources("Invasions", MixuInvasionPoolData);
    _G.I_I_Data.AddAdditionalDBResources("Areas", MixuAreaPoolData);
else
    IandI_Log("Global I_I_Data is not defined");
end

-- Load the name resources
-- This is separate so I can use this in other mods
if _G.CG_NameResources then
    ConcatTableWithKeys(_G.CG_NameResources.campaign_character_data, MixuDataResources);
end

IandI_Log_Finished();