--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
---@class LibStub
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

---@class AceConsole
local AceConsole_Interface = {
    -- Embeds AceConsole into the target object making the functions from the mixins list available on target:..
    ---@param self AceConsole
    ---@param target any object to embed AceBucket in
    Embed = function(self, target)  end
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
    ---@type AceConsole
    AceConsole = {},

    ---@type GlobalConstants
    GlobalConstants = {},
    ---@type Logger
    Logger = {},

    ---@type fun(fmt:string, ...)|fun(val:string)
    pformat = {},
    ---@type fun(fmt:string, ...)|fun(val:string)
    sformat = {},

    ---@type Kapresoft_LibUtil_Objects
    LU = {},
    ---@type Kapresoft_LibUtil_PrettyPrint
    PrettyPrint = {},
    ---@type Kapresoft_LibUtil_Assert
    Assert = {},
    ---@type Kapresoft_LibUtil_Incrementer
    Incrementer = {},
    ---@type Kapresoft_LibUtil_LuaEvaluator
    LuaEvaluator = {},
    ---@type Kapresoft_LibUtil_Mixin
    Mixin = {},
    ---@type Kapresoft_LibUtil_String
    String = {},
    ---@type Kapresoft_LibUtil_Table
    Table = {},

    ---@type Core
    Core = {},
    ---@type Wrapper
    Wrapper = {},
}
--[[-----------------------------------------------------------------------------
Modules
-------------------------------------------------------------------------------]]

---@class Modules
local M = {
    LU = 'LU',
    pformat = 'pformat',
    sformat = 'sformat',
    GlobalConstants = 'GlobalConstants',
    Core = 'Core',
    AceConsole = 'AceConsole',
    Logger = 'Logger',
    Wrapper = 'Wrapper',
}

local InitialModuleInstances = {
    LU = LibUtil,
    GlobalConstants = LibStub(LibName('GlobalConstants')),
    AceConsole = LibStub('AceConsole-3.0'),
    pformat = PrettyPrint.pformat,
}

---Usage:
---```
---local O, LibStub = SDNR_Namespace(...)
---local AceConsole = O.AceConsole
---```
---@return Namespace
function SDNR_Namespace(...)
    ---@type string
    local addon
    ---@type Namespace
    local namespace
    addon, namespace = ...


    ---@type GlobalObjects
    namespace.O = namespace.O or {}
    ---@type string
    namespace.name = addon

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

    ---@return GlobalObjects, LocalLibStub, Modules
    function namespace:LibPack() return self.O, ns.LibStub, M end
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


---@type Modules
SDNR_Modules = M
