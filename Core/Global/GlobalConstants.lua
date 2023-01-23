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
local LibStub = LibStub

--- @type string
local addon
--- @type Namespace
local ns
addon, ns = ...

local addonShortName = 'ADT'
local consoleCommand = "adt"
local globalVarName = "ADT"
local useShortName = false

local globalVarPrefix = globalVarName .. "_"
local dbName = globalVarPrefix .. 'DB'
local logLevel = globalVarPrefix .. 'LOG_LEVEL'
local debugMode = globalVarPrefix .. 'DEBUG_MODE'

local ADDON_INFO_FMT = '%s|cfdeab676: %s|r'
local TOSTRING_ADDON_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe}}|r'
local TOSTRING_SUBMODULE_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe::|r|cfdfbeb2d%s|r|cfdfefefe}}|r'

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
local L = LibStub:NewLibrary(LibName('GlobalConstants'), 1)

--- @param o GlobalConstants
local function GlobalConstantProperties(o)

    local consoleCommandTextFormat = '|cfd2db9fb%s|r'
    local consoleKeyValueTextFormat = '|cfdfbeb2d%s|r: %s'
    local command = sformat("/%s", consoleCommand)

    --- @class GlobalAttributes
    local C = {
        VAR_NAME = globalVarName,
        CONSOLE_COMMAND_NAME = consoleCommand,
        DB_NAME = dbName,
        CHECK_VAR_SYNTAX_FORMAT = '|cfdeab676%s ::|r %s',
        CONSOLE_HEADER_FORMAT = '|cfdeab676### %s ###|r',
        CONSOLE_OPTIONS_FORMAT = '  - %-8s|cfdeab676:: %s|r',

        CONSOLE_COMMAND_TEXT_FORMAT = consoleCommandTextFormat,
        CONSOLE_KEY_VALUE_TEXT_FORMAT = consoleKeyValueTextFormat,

        CONSOLE_PLAIN = command,
        COMMAND      = sformat(consoleCommandTextFormat, command),
        HELP_COMMAND = sformat(consoleCommandTextFormat, command .. ' help'),
    }

    --- @class EventNames
    local E = {
        OnEnter = 'OnEnter',
        OnEvent = 'OnEvent',
        OnLeave = 'OnLeave',
        OnModifierStateChanged = 'OnModifierStateChanged',
        OnDragStart = 'OnDragStart',
        OnDragStop = 'OnDragStop',
        OnMouseUp = 'OnMouseUp',
        OnMouseDown = 'OnMouseDown',
        OnReceiveDrag = 'OnReceiveDrag',

        PLAYER_ENTERING_WORLD = 'PLAYER_ENTERING_WORLD',
    }
    local function newMessage(name) return sformat('%s::' .. name, addonShortName)  end
    --- @class MessageNames
    local M = {
        OnAfterInitialize = newMessage('OnAfterInitialize'),
        OnAddonReady = newMessage('OnAddonReady'),
    }

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
        local versionText, lastUpdate
        --@non-debug@
        versionText = GetAddOnMetadata(ns.name, 'Version')
        lastUpdate = GetAddOnMetadata(ns.name, 'X-Github-Project-Last-Changed-Date')
        --@end-non-debug@
        --@debug@
        versionText = '1.0.x.dev'
        lastUpdate = date("%m/%d/%y %H:%M:%S")
        --@end-debug@
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

    o.LibName = LibName
    o.ToStringFunction = ToStringFunction
end

GlobalConstantProperties(L)
Methods(L)
