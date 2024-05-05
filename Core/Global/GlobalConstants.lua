--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local GetAddOnMetadata = GetAddOnMetadata
local date = date

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
--- @type string
local addon = ns.addon

local kch = ns.Kapresoft_LibUtil.CH

local addonShortName             = 'ADT'
local consoleCommand             = "addon-template"
local consoleCommandShort        = "adt"
local consoleCommandOptions      = consoleCommand .. '-options'
local consoleCommandOptionsShort = consoleCommandShort .. '-options'
local globalVarName              = "ADT"
local useShortName               = false

local globalVarPrefix            = globalVarName .. "_"
local dbName                     = globalVarPrefix .. 'DB'
local logLevel                   = globalVarPrefix .. 'LOG_LEVEL'
local debugMode                  = globalVarPrefix .. 'DEBUG_MODE'

local ADDON_INFO_FMT = '%s|cfdeab676: %s|r'
local TOSTRING_ADDON_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe}}|r'
local TOSTRING_SUBMODULE_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe::|r|cfdfbeb2d%s|r|cfdfefefe}}|r'

--[[-----------------------------------------------------------------------------
Console Colors
-------------------------------------------------------------------------------]]
--- @type Kapresoft_LibUtil_ColorDefinition
local consoleColors = {
    primary   = 'A4A49C',
    secondary = 'fbeb2d',
    tertiary = 'ffffff',
}
local command = kch:FormatColor(consoleColors.primary, '/' .. consoleCommand)
local commandShort = kch:FormatColor(consoleColors.primary, '/' .. consoleCommandShort)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param moduleName string
--- @param optionalMajorVersion number|string
local function LibName(moduleName, optionalMajorVersion)
    assert(moduleName, "Module name is required for LibName(moduleName)")
    local majorVersion = optionalMajorVersion or '1.0'
    local v = sformat("%s-%s-%s", addon, moduleName, majorVersion)
    return v
end
--- @param moduleName string
local function ToStringFunction(moduleName)
    local name = addon
    if useShortName then name = addonShortName end
    if moduleName then return function() return string.format(TOSTRING_SUBMODULE_FMT, name, moduleName) end end
    return function() return string.format(TOSTRING_ADDON_FMT, name) end
end

local function InitGlobalVars(varPrefix)
    if 'table' ~= type(_G[dbName]) then _G[dbName] = {} end
    if 'number' ~= type(_G[logLevel]) then _G[logLevel] = 1 end
    if 'boolean' ~= type(_G[debugMode]) then _G[debugMode] = false end
end
InitGlobalVars(globalVarPrefix)

--[[-----------------------------------------------------------------------------
GlobalConstants
-------------------------------------------------------------------------------]]
--- @class GlobalConstants
local L = {}

--- @param o GlobalConstants
local function GlobalConstantProperties(o)
    --- @class GlobalAttributes
    local C = {
        VAR_NAME = globalVarName,
        CONSOLE_COMMAND_NAME = consoleCommand,
        CONSOLE_COMMAND_SHORT = consoleCommandShort,
        CONSOLE_COMMAND_OPTIONS = consoleCommandOptions,
        CONSOLE_COMMAND_OPTIONS_SHORT = consoleCommandOptionsShort,
        CONSOLE_COLORS = consoleColors,
        DB_NAME = dbName,
        CONSOLE_HEADER_FORMAT = '|cfdeab676### %s ###|r',
        CONSOLE_OPTIONS_FORMAT = '  - %-8s|cfdeab676:: %s|r',
        CONSOLE_PLAIN = command,
        CONSOLE_SHORT_COMMAND_PLAIN = commandShort,
    }

    --- @class EventNames
    local E = {
        OnEnter                = '',
        OnEvent                = '',
        OnLeave                = '',
        OnModifierStateChanged = '',
        OnDragStart            = '',
        OnDragStop             = '',
        OnMouseUp              = '',
        OnMouseDown            = '',
        OnReceiveDrag          = '',
        PLAYER_ENTERING_WORLD  = '',
    }; for name in pairs(E) do E[name] = name end

    local function newMessage(name) return sformat('%s::' .. name, addonShortName)  end
    --- @class MessageNames
    local M = {
        OnAfterInitialize = '',
        OnAddonReady = '',
        --- Enable/Disable of the DebugConsole settings
        OnDebugConsoleToggle = '',
    }; for name in pairs(M) do M[name] = newMessage(name) end

    o.C = C
    o.E = E
    o.M = M

end

--- @param o GlobalConstants
local function Methods(o)
    --  TODO

    function o:GetLogName()
        local logName = addon
        if useShortName then logName = addonShortName end
        return logName
    end

    ---#### Example
    ---```
    ---local version, curseForge, issues, repo, lastUpdate, wowInterfaceVersion = GC:GetAddonInfo()
    ---```
    --- @return string, string, string, string, string, string
    function o:GetAddonInfo()
        local versionText = GetAddOnMetadata(ns.name, 'Version')
        local lastUpdate = GetAddOnMetadata(ns.name, 'X-Github-Project-Last-Changed-Date')
        --@do-not-package@
        versionText = '1.0.x.dev'
        lastUpdate  = date("%m/%d/%y %H:%M:%S")
        --@end-do-not-package@
        local wowInterfaceVersion = select(4, GetBuildInfo())

        return versionText, GetAddOnMetadata(ns.name, 'X-CurseForge'),
            GetAddOnMetadata(ns.name, 'X-Github-Issues'),
            GetAddOnMetadata(ns.name, 'X-Github-Repo'),
            lastUpdate, wowInterfaceVersion
    end

    function o:GetAddonInfoFormatted()
        local version, curseForge, issues, repo, lastUpdate, wowInterfaceVersion = self:GetAddonInfo()
        --p:log("Addon Info:\n  Version: %s\n  Curse-Forge: %s\n  File-Bugs-At: %s\n  Last-Changed-Date: %s\n  WoW-Interface-Version: %s\n",
        --        version, curseForge, issues, lastChanged, wowInterfaceVersion)
        return sformat("Addon Info:\n%s\n%s\n%s\n%s\n%s\n%s",
                sformat(ADDON_INFO_FMT, 'Version', version),
                sformat(ADDON_INFO_FMT, 'Curse-Forge', curseForge),
                sformat(ADDON_INFO_FMT, 'Bugs', issues),
                sformat(ADDON_INFO_FMT, 'Repo', repo),
                sformat(ADDON_INFO_FMT, 'Last-Update', lastUpdate),
                sformat(ADDON_INFO_FMT, 'Interface-Version', wowInterfaceVersion)
        )
    end

    function o:GetMessageLoadedText()
        local consoleCommandMessageFormat = sformat('Type %s or %s for available commands.',
                command, commandShort)
        return sformat("%s version %s by %s is loaded. %s",
                kch:P(addon) , self:GetAddonInfo(), kch:FormatColor(consoleColors.primary, 'kapresoft'),
                consoleCommandMessageFormat)
    end

    o.LibName = LibName
    o.ToStringFunction = ToStringFunction
end

GlobalConstantProperties(L)
Methods(L)
ns.GC = function() return L end
