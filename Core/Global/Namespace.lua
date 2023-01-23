--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local addonName, _ns = ...
local K = _ns.Kapresoft_LibUtil
local LibName = _ns.LibName

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
    GlobalConstants = LibStub(LibName(M.GlobalConstants)),
    sformat = string.format,
    pformat = K.pformat,
}

--- Some Utility Methods to make things easier to access the Library
--- @class Kapresoft_LibUtil_Mixins
local Kapresoft_LibUtil_Mixins = {
    K = function(self) return self.Kapresoft_LibUtil end,
    KO = function(self) return self.Kapresoft_LibUtil.Objects  end,
}

--- @type GlobalConstants
local GC = LibStub(LibName(M.GlobalConstants))

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

    --- @see BlizzardInterfaceCode:Interface/SharedXML/Mixin.lua
    Mixin(ns, Kapresoft_LibUtil_Mixins)

    --- @type GlobalObjects
    ns.O = ns.O or {}
    --- @type string
    ns.name = addon
    --- @type string
    ns.nameShort = GC:GetLogName()

    if 'table' ~= type(ns.O) then ns.O = {} end

    for key, _ in pairs(M) do
        local lib = InitialModuleInstances[key]
        if lib then ns.O[key] = lib end
    end

    ns.pformat = ns.O.pformat
    ns.sformat = ns.O.sformat
    ns.M = M

    local getSortedKeys = ns:KO().Table.getSortedKeys

    --- @param libName string The library name. Ex: 'GlobalConstants'
    --- @param o table The library object instance
    function ns:Register(libName, o)
        if not (libName or o) then return end
        self.O[libName] = o
    end

    --- @param libName string The library name. Ex: 'GlobalConstants'
    function ns:NewLogger(libName) return self.O.Logger:NewLogger(libName) end
    function ns:ToStringNamespaceKeys() return self.pformat(getSortedKeys(ns)) end
    function ns:ToStringObjectKeys() return self.pformat(getSortedKeys(ns.O)) end

    return ns
end

if _ns.name then return end; CreateNamespace(addonName, _ns)

