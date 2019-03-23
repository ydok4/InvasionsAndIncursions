require 'script/_lib/pooldata/DelayedStartPoolData'
require 'script/_lib/pooldata/IncursionPoolData'
require 'script/_lib/pooldata/InvasionPoolData'
require 'script/_lib/pooldata/SubCultureArmyPoolData'

require 'script/_lib/dbexports/NameGroupResources'
require 'script/_lib/dbexports/SubCultureNameGroupResources'
require 'script/_lib/dbexports/NameResources'

IandI_Log("Loading Core Data");
out("I&I: Loading Core Data");

_G.I_I_Data = {
    DelayedStart = DelayedStartPoolData,
    Incursion = IncursionPoolData,
    Invasion = InvasionPoolData,

    SubCultureArmyPoolData = SubCultureArmyPoolData,
    AddAdditionalDBResources = function(dbResourceKey, resourceData)
        ConcatTableWithKeys(_G.I_I_Data[dbResourceKey], resourceData);
    end,
}

-- Load the name resources
-- This is separate so I can use this in other mods
if not _G.CG_NameResources then
    _G.CG_NameResources = {
        subculture_to_name_groups = SubCultureNameGroupResources,
        faction_to_name_groups = NameGroupResources,
        name_groups_to_names = NameResources,
    }
end