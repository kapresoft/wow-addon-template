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
--- @type Kapresoft_Base_Namespace
local kns
addonName, kns = ...

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type GlobalConstants
local GC = LibStub(addonName .. '-GlobalConstants-1.0')
local K = kns.Kapresoft_LibUtil
local KO = K.Objects

--[[-----------------------------------------------------------------------------
Global Variables: Replace with Addon-specific global vars
-------------------------------------------------------------------------------]]
---@param val EnabledInt|boolean|nil
---@param key string|nil Category name
---@return table<string, string>
local function __categories(key, val)
    if key then ADT_DEBUG_ENABLED_CATEGORIES[key] = val end
    return ADT_DEBUG_ENABLED_CATEGORIES or {}
end
local function __category(key)
    ADT_DEBUG_ENABLED_CATEGORIES = ADT_DEBUG_ENABLED_CATEGORIES or {}
    return ADT_DEBUG_ENABLED_CATEGORIES[key]
end
--- @param val number|nil Optional log level to set
--- @return number The new log level passed back
local function __logLevel(val)
    if val then ADT_LOG_LEVEL = val end
    return ADT_LOG_LEVEL or 0
end

--[[-----------------------------------------------------------------------------
Log Categories
-------------------------------------------------------------------------------]]
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
GlobalObjects
-------------------------------------------------------------------------------]]
--- @class GlobalObjects
--- @field AceLibrary Kapresoft_LibUtil_AceLibraryObjects
--- @field pformat fun(fmt:string, ...)|fun(val:string)
--- @field AceDbInitializerMixin AceDbInitializerMixin
--- @field GlobalConstants GlobalConstants
--- @field MainController MainController
--- @field OptionsUtil OptionsUtil
--- @field OptionsMixin OptionsMixin
--- @field DebuggingSettingsGroup DebuggingSettingsGroup
--[[-----------------------------------------------------------------------------
Modules
-------------------------------------------------------------------------------]]
--- @class Modules
local M = {
    pformat = '',
    sformat = '',
    AceLibrary = '',

    AceDbInitializerMixin = '',
    DebuggingSettingsGroup = '',
    GlobalConstants = '',
    MainController = '',
    OptionsUtil = '',
    OptionsMixin = '',
}; for moduleName in pairs(M) do M[moduleName] = moduleName end

local InitialModuleInstances = {
    -- External Libs --
    AceLibrary = K.Objects.AceLibrary.O,
    AceLibStub = LibStub,
    -- Internal Libs --
    GlobalConstants = LibStub(GC.LibName(M.GlobalConstants)),
    sformat = string.format,
    pformat = K.pformat,
}
--[[
--- Some Utility Methods to make things easier to access the Library
--- @class Kapresoft_LibUtil_Mixins
local Kapresoft_LibUtil_Mixins = {
    K = function(self) return self.Kapresoft_LibUtil end,
    KO = function(self) return self.Kapresoft_LibUtil.Objects  end,
}]]

--- @class __NamespaceLoggerMixin
--- @field O GlobalObjects
local NamespaceLoggerMixin = {}
---@param o __NamespaceLoggerMixin
local function NamespaceLoggerMethods(o)
    --categories = categories or {}

    local CategoryLogger = KO.CategoryMixin:New()
    CategoryLogger:Configure(addonName, LogCategories, {
        consoleColors = GC.C.CONSOLE_COLORS,
        levelSupplierFn = function() return __logLevel() end,
        enabledCategoriesSupplierFn = function() return __categories() end,
    })
    --- @private
    o.LogCategory = CategoryLogger
    --- @return number
    function o:GetLogLevel() return __logLevel() end
    --- @param level number
    function o:SetLogLevel(level) __logLevel(level) end

    --- @param name string | "'ADDON'" | "'BAG'" | "'BUTTON'" | "'DRAG_AND_DROP'" | "'EVENT'" | "'FRAME'" | "'ITEM'" | "'MESSAGE'" | "'MOUNT'" | "'PET'" | "'PROFILE'" | "'SPELL'"
    --- @param v boolean|number | "1" | "0" | "true" | "false"
    function o:SetLogCategory(name, val)
        assert(name, 'Debug category name is missing.')
        ---@param v boolean|nil
        local function normalizeVal(v) if v == 1 or v == true then return 1 end; return 0 end
        __categories(name, normalizeVal(val))
    end
    --- @return boolean
    function o:IsLogCategoryEnabled(name)
        assert(name, 'Debug category name is missing.')
        local val = __category(name)
        return val == 1 or val == true
    end
    function o:LC() return LogCategories end
    function o:CreateDefaultLogger(moduleName) return LogCategories.DEFAULT:NewLogger(moduleName) end

end; NamespaceLoggerMethods(NamespaceLoggerMixin)


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
    o.LibStubAce = LibStub
    o.LibStub = LocalLibStub
    o.O.LibStub = LocalLibStub
end

---@param o __Namespace | Namespace
local function NameSpacePropertiesAndMethods(o)
    local getSortedKeys = o:KO().Table.getSortedKeys

    --- @type string
    o.nameShort = GC:GetLogName()

    if 'table' ~= type(o.O) then o.O = {} end

    for key, _ in pairs(M) do
        local lib = InitialModuleInstances[key]
        if lib then o.O[key] = lib end
    end

    o.pformat = o.O.pformat
    o.sformat = o.O.sformat
    o.M = M
    o.ch = o:NewConsoleHelper(GC.C.CONSOLE_COLORS)

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

    --- @param db AddOn_DB
    function o:SetAddOnDB(db) addonDb = db end

    --- @return AddOn_DB
    function o:db() return addonDb end

    --- @return Profile_Config
    function o:profile() return addonDb and addonDb.profile end

    function o:ToStringNamespaceKeys() return self.pformat(getSortedKeys(self)) end
    function o:ToStringObjectKeys() return self.pformat(getSortedKeys(self.O)) end

    InitLocalLibStub(o)
end

--- @alias Namespace __Namespace | __NamespaceLoggerMixin | Kapresoft_LibUtil_NamespaceAceLibraryMixin | Kapresoft_LibUtil_NamespaceKapresoftLibMixin

--- @return Namespace
local function CreateNamespace(...)
    --- @type string
    local addon
    --- @class __Namespace
    local ns; addon, ns = ...

    --- Place this here before ns.name because it overrides the name field
    --- @see BlizzardInterfaceCode:Interface/SharedXML/Mixin.lua
    Mixin(ns, KO.NamespaceAceLibraryMixin, KO.NamespaceKapresoftLibMixin, NamespaceLoggerMixin)

    --- @type GlobalObjects
    ns.O = ns.O or {}
    --- @type string
    ns.name = addon
    ns.addon = addon

    NameSpacePropertiesAndMethods(ns)

    ns.GC = ns.O.GlobalConstants
    ns.mt = { __tostring = function() return addon .. '::Namespace'  end }
    setmetatable(ns, ns.mt)

    --- print(ns.name .. '::Namespace:: pformat:', pformat)
    --- Global Function
    pformat = pformat or ns.pformat

    return ns
end; if kns.name then return end;

--- @type Namespace
ADT_NS = CreateNamespace(...)
--- @return Namespace
function adt_ns(...) return select(2, ...) end
