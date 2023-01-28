--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
--- @see BlizzardInterfaceCode:Interface/SharedXML/Mixin.lua
--- @class _Mixin
local Mixin = Mixin

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local addonName, _ns = ...
local K = _ns.Kapresoft_LibUtil
--- @type GlobalConstants
local GC = LibStub(addonName .. '-GlobalConstants-1.0')

--- @type LibStub
local LibStub = LibStub

--[[-----------------------------------------------------------------------------
Modules
-------------------------------------------------------------------------------]]

--- @class Modules
local M = {
    AceLibStub = 'AceLibStub',
    pformat = 'pformat',
    sformat = 'sformat',
    AceLibrary = 'AceLibrary',

    AceDbInitializerMixin = 'AceDbInitializerMixin',
    Core = 'Core',
    GlobalConstants = 'GlobalConstants',
    Logger = 'Logger',
    MainEventHandler = 'MainEventHandler',
    OptionsMixin = 'OptionsMixin',
}

local InitialModuleInstances = {
    -- External Libs --
    AceLibrary = K.Objects.AceLibrary.O,
    AceLibStub = LibStub,
    -- Internal Libs --
    GlobalConstants = LibStub(GC.LibName(M.GlobalConstants)),
    sformat = string.format,
    pformat = K.pformat,
}

--- Some Utility Methods to make things easier to access the Library
--- @class Kapresoft_LibUtil_Mixins
local Kapresoft_LibUtil_Mixins = {
    K = function(self) return self.Kapresoft_LibUtil end,
    KO = function(self) return self.Kapresoft_LibUtil.Objects  end,
}

---@param o Namespace
local function InitLocalLibStub(o)
    --- @class LocalLibStub : Kapresoft_LibUtil_LibStubMixin
    local LocalLibStub = o:K().Objects.LibStubMixin:New(o.name, 1.0,
            function(name, newLibInstance)
                --- @type Logger
                local loggerLib = LibStub(o:LibName(o.M.Logger))
                if loggerLib then
                    newLibInstance.logger = loggerLib:NewLogger(name)
                    newLibInstance.logger:log( 'New Lib: %s', newLibInstance.major)
                    function newLibInstance:GetLogger() return self.logger end
                end
                o:Register(name, newLibInstance)
            end)
    o.LibStub = LocalLibStub
    o.O.LibStub = LocalLibStub
end

---@param o Namespace
local function NameSpacePropertiesAndMethods(o)
    Mixin(o, Kapresoft_LibUtil_Mixins)

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

    --- @param moduleName string The module name, i.e. Logger
    --- @param optionalMajorVersion number|string
    --- @return string The complete module name, i.e. 'ActionbarPlus-Logger-1.0'
    function o:LibName(moduleName, optionalMajorVersion) return GC.LibName(moduleName, optionalMajorVersion) end
    --- @param moduleName string The module name, i.e. Logger
    function o:ToStringFunction(moduleName) return GC.ToStringFunction(moduleName) end

    --- @param obj table The library object instance
    function o:Register(libName, obj)
        if not (libName or obj) then return end
        self.O[libName] = obj
    end

    --- @param libName string The library name. Ex: 'GlobalConstants'
    function o:NewLogger(libName) return self.O.Logger:NewLogger(libName) end
    function o:ToStringNamespaceKeys() return self.pformat(getSortedKeys(self)) end
    function o:ToStringObjectKeys() return self.pformat(getSortedKeys(self.O)) end

    InitLocalLibStub(o)
end

---Usage:
---```
---local O, LibStub = ADT_Namespace(...)
---local AceConsole = O.AceConsole
---```
--- @return Namespace
local function CreateNamespace(_addonName, _namespace)
    --- @type string
    local addon = _addonName
    --- @type Namespace
    local ns = _namespace

    --- @type GlobalObjects
    ns.O = ns.O or {}
    --- @type string
    ns.name = addon

    NameSpacePropertiesAndMethods(ns)

    ns.mt = { __tostring = function() return addon .. '::Namespace'  end }
    setmetatable(ns, ns.mt)

    return ns
end

if _ns.name then return end; CreateNamespace(addonName, _ns)

