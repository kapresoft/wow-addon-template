--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
--- @see BlizzardInterfaceCode:Interface/SharedXML/Mixin.lua
--- @class _Mixin
local Mixin = Mixin

--- @type LibStub
local LibStub = LibStub
--[[-----------------------------------------------------------------------------
Base Namespace
-------------------------------------------------------------------------------]]
--- @type string
local addonName
--- @type CoreNamespace
local kns
addonName, kns = ...

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type GlobalConstants
local GC = kns.GC()
local K = kns.Kapresoft_LibUtil
local KO = K.Objects
local c1 = K:cf(LIGHTBLUE_FONT_COLOR)

--[[-----------------------------------------------------------------------------
Global Variables: Replace with Addon-specific global vars
-------------------------------------------------------------------------------]]
--- @param val EnabledInt|boolean|nil
--- @param key string|nil Category name
--- @return table<string, string>
local function __GetCategories(key, val)
    if key then ADT_DEBUG_ENABLED_CATEGORIES[key] = val end
    return ADT_DEBUG_ENABLED_CATEGORIES or {}
end

--- Get Enabled Category
--- @param key string The category key
local function __category(key)
    ADT_DEBUG_ENABLED_CATEGORIES = ADT_DEBUG_ENABLED_CATEGORIES or {}
    return ADT_DEBUG_ENABLED_CATEGORIES[key]
end
--- @param val number|nil Optional log level to set
--- @return number The new log level passed back
local function __GetLogLevel(val)
    if val then ADT_LOG_LEVEL = val end
    return ADT_LOG_LEVEL or 0
end

--[[-----------------------------------------------------------------------------
Log Categories
-------------------------------------------------------------------------------]]
--- @class LogCategories
local LogCategories = {
    --- @type Kapresoft_LogCategory
    DEFAULT = 'DEFAULT',
    --- @type Kapresoft_LogCategory
    API = "AP",
    --- @type Kapresoft_LogCategory
    OPTIONS = "OP",
    --- @type Kapresoft_LogCategory
    EVENT = "EV",
    --- @type Kapresoft_LogCategory
    FRAME = "FR",
    --- @type Kapresoft_LogCategory
    MESSAGE = "MS",
    --- @type Kapresoft_LogCategory
    PROFILE = "PR",
    --- @type Kapresoft_LogCategory
    DB = "DB",
    --- @type Kapresoft_LogCategory
    DEV = "DV",
}

--[[-----------------------------------------------------------------------------
Type: Module
-------------------------------------------------------------------------------]]
--- @class Module
--- @field _name Name

--[[-----------------------------------------------------------------------------
Modules
-------------------------------------------------------------------------------]]
--- @class Modules
local M = {
    --- @type GlobalConstants
    GlobalConstants = {},

    --- @type AceDbInitializerMixin
    AceDbInitializerMixin = {},
    --- @type API
    API = {},
    --- @type DebuggingSettingsGroup
    DebuggingSettingsGroup = {},
    --- @type MainController
    MainController = {},
    --- @type OptionsUtil
    OptionsUtil = {},
    --- @type OptionsMixin
    OptionsMixin = {},
}; KO.LibModule.EnrichModules(M)

---@param o __Namespace | Namespace
local function InitLocalLibStub(o)
    --- @class LocalLibStub : Kapresoft_LibUtil_LibStubMixin
    local LocalLibStub = o:K().Objects.LibStubMixin:New(o.name, 1.0,
            function(name, newLibInstance)
                -- local p = LogCategories.DEFAULT:NewLogger("Namespace::InitLocalLibStub")
                -- can only use verbose here because global vars are not yet loaded
                -- p:vv( function() return 'New Lib: %s', newLibInstance.major end)
                o:Register(name, newLibInstance)
            end)
    o.LibStubAce = function() return LibStub end
    o.LibStub = function() return LocalLibStub end
end

---@param o __Namespace | Namespace
local function NameSpacePropertiesAndMethods(o)
    local getSortedKeys = o:KO().Table.getSortedKeys

    --- @type string
    o.nameShort = GC:GetLogName()

    o.ch = o:NewConsoleHelper(GC.C.CONSOLE_COLORS)

    o.dump = K.dump
    o.dumpv = K.dumpv

    --- @param moduleName string The module name, i.e. Logger
    --- @param optionalMajorVersion number|string
    --- @return string The complete module name, i.e. 'ActionbarPlus-MainController-1.0'
    function o:LibName(moduleName, optionalMajorVersion) return GC.LibName(moduleName, optionalMajorVersion) end
    --- @param moduleName string The module name, i.e. MainController
    function o:ToStringFunction(moduleName) return GC.ToStringFunction(moduleName) end

    --- @param obj table The library object instance
    function o:Register(libName, obj)
        if not (libName or obj) then return end
        self.O[libName] = obj
    end

    --- @param libName Name | "libName" | "'The name of the library'"
    function o:NewLib(libName, ...)
        assert(libName, "LibName is required")
        local newLib = {}
        local len = select("#", ...)
        if len > 0 then newLib = self:K():Mixin({}, ...) end
        newLib.mt = { __tostring = function() return 'Lib:' .. libName end}
        setmetatable(newLib, newLib.mt)
        self.O[libName] = newLib
        --@do-not-package@
        if kns.debug:IsDeveloper() then
            local p  = self:LC().DEFAULT:NewLogger('Ns')
            p:vv(function() return "Lib: %s", kns.f().val(libName) end)
        end
        --@end-do-not-package@
        return newLib
    end
    function o:NewLibWithEvent(libName, ...)
        assert(libName, "LibName is required")
        local newLib = self:AceLibrary().AceEvent:Embed({})
        local len = select("#", ...)
        if len > 0 then newLib = self:K():Mixin(newLib, ...) end
        newLib.mt = { __tostring = GC.ToStringFunction(libName)}
        setmetatable(newLib, newLib.mt)
        self.O[libName] = newLib
        --@do-not-package@
        if kns.debug:IsDeveloper() then
            local p  = self:LC().DEFAULT:NewLogger('Ns')
            local n =  kns.f().val(kns.sformat('%s (with AceEvent)', libName))
            p:vv(function() return "Lib: %s", n end)
        end
        --@end-do-not-package@
        return newLib
    end

    --- @param dbfn fun() : AddOn_DB | "function() return addon.db end"
    function o:SetAddOnFn(dbfn) self.addonDbFn = dbfn end
    --- @return AddOn_DB
    function o:db() return self.addonDbFn() end
    --- @return DebugSettingsFlag_Config
    function o:dbg() return self:db().global.debug end
    --- @return Profile_Global_Config
    function o:global() return self:db().global end
    --- @return Profile_Character_Config
    function o:char() return self:db().char end
    --- @return Profile_Config
    function o:profile() return self:db().profile end

    function o:ToStringNamespaceKeys() return self.pformat(getSortedKeys(self)) end
    function o:ToStringObjectKeys() return self.pformat(getSortedKeys(self.O)) end

    InitLocalLibStub(o)
end

--- @alias Namespace __Namespace | CategoryLoggerMixin | Kapresoft_LibUtil_NamespaceAceLibraryMixin

--- @return Namespace
local function CreateNamespace(...)
    --- @type string
    local addon

    --- @class __Namespace : CoreNamespace
    --- @field GC fun() : GlobalConstants
    --- @field LogCategories LogCategories
    --- @field CategoryLoggerMixin CategoryLoggerMixin
    --- @field LocaleUtil LocaleUtil
    local ns; addon, ns = ...

    --- @type Modules
    ns.M = M
    --- @type Modules
    ns.O = ns.O or {}

    --- @type string
    --- @deprecated Deprecated. Replace with ns.addon
    ns.name = addon

    ns.CategoryLoggerMixin:Configure(ns, LogCategories)

    NameSpacePropertiesAndMethods(ns)

    ns.mt = { __tostring = function() return addon .. '::Namespace'  end }
    setmetatable(ns, ns.mt)

    return ns
end

--- @type Namespace
ADT_NS = CreateNamespace(...)

--@do-not-package@
if kns.debug:IsDeveloper() then
    local p = ADT_NS:CreateDefaultLogger('Ns')
    p:a(function() return '%s Namespace is: %s', kns.addon,
            c1(kns.sformat('ADT_NS (%s)', type(ADT_NS))) end)
end
--@end-do-not-package@
