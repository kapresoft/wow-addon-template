--- @type CoreNamespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
AddOn_DB
-------------------------------------------------------------------------------]]
--- @class Profile_DB_ProfileKeys : table<string, string>

--- @class DebugSettingsFlag_Config
local DebugSettingsFlag = {
    enableLogConsole = false,
    selectLogConsoleTab = true,
    maxLogConsoleLines = 1000,
}

--[[-----------------------------------------------------------------------------
Type: Profile_Global_Config
-------------------------------------------------------------------------------]]

--- @class Profile_Global_Config : AceDB_Global
local DefaultGlobal = {
    debug = DebugSettingsFlag
}

--[[-----------------------------------------------------------------------------
Type: Profile_Character_Config
-------------------------------------------------------------------------------]]
--- @class Profile_Character_Config
local DefaultCharacterSettings = {
    nickName = 'Uber Player'
}

--[[-----------------------------------------------------------------------------
Type: Profile_Config
-------------------------------------------------------------------------------]]
--- @class Profile_Config : AceDB_Profile
local DefaultProfileSettings = {
    enable = true,
    --- example config field
    enableSomething = true,
};

--- @class AddOn_DB : AceDB
local DefaultAddOnDatabase = {
    global = DefaultGlobal,
    char = DefaultCharacterSettings,
    profile = DefaultProfileSettings,
}

--[[-----------------------------------------------------------------------------
Namespace Var
-------------------------------------------------------------------------------]]
function ns.DefaultAddOnDatabase() return DefaultAddOnDatabase end
