--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
---@type LibStub
local LibStub = LibStub

---@type Kapresoft_LibUtil_Objects
local LibUtil = Kapresoft_LibUtil

---@type Kapresoft_LibUtil_PrettyPrint
local PrettyPrint = Kapresoft_LibUtil.PrettyPrint
PrettyPrint.setup({ show_function = true, show_metatable = true, indent_size = 2, depth_limit = 3 })

---@class Namespace
local NamespaceObject = {
    ---Usage:
    ---```
    ---local GC = LibStub(LibName('GlobalConstants'), 1)
    ---```
    ---@type fun(moduleName:string, optionalMajorVersion:string)
    ---@return string The full LibStub library name. Example:  '[AddonName]-GlobalConstants-1.0.1'
    LibName = {},
    ---Usage:
    ---```
    ---local L = {}
    ---local mt = { __tostring = ns.ToStringFunction() }
    ---setmetatable(mt, L)
    ---```
    ---@type fun(moduleName:string)
    ToStringFunction = {}
}

---@type string
local addonName
---@type Namespace
local ns
addonName, ns = ...

local LibName = ns.LibName

--[[-----------------------------------------------------------------------------
GlobalObjects
-------------------------------------------------------------------------------]]
---@class GlobalObjects
local GlobalObjects = {
    ---@type Kapresoft_LibUtil_AceLibraryObjects
    AceLibrary = {},
    ---@type LibStub
    AceLibStub = {},

    ---@type fun(fmt:string, ...)|fun(val:string)
    pformat = {},
    ---@type fun(fmt:string, ...)|fun(val:string)
    sformat = {},

    ---@type Kapresoft_LibUtil_Objects
    LU = {},

    ---@type AceDbInitializerMixin
    AceDbInitializerMixin = {},
    ---@type Core
    Core = {},
    ---@type GlobalConstants
    GlobalConstants = {},
    ---@type Logger
    Logger = {},
    ---@type MainEventHandler
    MainEventHandler = {},
    ---@type OptionsMixin
    OptionsMixin = {},
}
--[[-----------------------------------------------------------------------------
Modules
-------------------------------------------------------------------------------]]

---@class Modules
local M = {
    AceLibStub = 'AceLibStub',
    LU = 'LU',
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
    LU = LibUtil,
    AceLibrary = LibUtil.AceLibrary.O,
    AceLibStub = LibStub,
    -- Internal Libs --
    GlobalConstants = LibStub(LibName(M.GlobalConstants)),
    pformat = PrettyPrint.pformat,
}

---@type GlobalConstants
local GC = LibStub(LibName(M.GlobalConstants))

---Usage:
---```
---local O, LibStub = ADT_Namespace(...)
---local AceConsole = O.AceConsole
---```
---@return Namespace
function ADT_Namespace(...)
    ---@type string
    local addon
    ---@type Namespace
    local namespace
    addon, namespace = ...


    ---@type GlobalObjects
    namespace.O = namespace.O or {}
    ---@type string
    namespace.name = addon
    ---@type string
    namespace.nameShort = GC:GetLogName()

    if 'table' ~= type(namespace.O) then namespace.O = {} end

    for key, val in pairs(LibUtil) do namespace.O[key] = val end
    for key, _ in pairs(M) do
        local lib = InitialModuleInstances[key]
        if lib then namespace.O[key] = lib end
    end

    namespace.pformat = namespace.O.pformat
    namespace.sformat = namespace.O.sformat
    namespace.M = M

    local pformat = namespace.pformat
    local getSortedKeys = namespace.O.Table.getSortedKeys

    ---Example:
    ---```
    ---local O, LibStub, M, ns = ADT_Namespace(...):LibPack()
    ---```
    ---@return GlobalObjects, LocalLibStub, Modules, Namespace
    function namespace:LibPack() return self.O, ns.LibStub, M, self end

    ---@param libName string The library name. Ex: 'GlobalConstants'
    ---@param o table The library object instance
    function namespace:Register(libName, o)
        if not (libName or o) then return end
        self.O[libName] = o
    end

    ---@param libName string The library name. Ex: 'GlobalConstants'
    function namespace:NewLogger(libName) return self.O.Logger:NewLogger(libName) end
    function namespace:ToStringNamespaceKeys() return pformat(getSortedKeys(ns)) end
    function namespace:ToStringObjectKeys() return pformat(getSortedKeys(ns.O)) end

    return namespace
end
---@return GlobalObjects, LocalLibStub, Modules, Namespace
function ADT_LibPack(...) return ADT_Namespace(...):LibPack() end
