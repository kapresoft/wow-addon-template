--[[-----------------------------------------------------------------------------
BaseLibraryObject
-------------------------------------------------------------------------------]]
--- @class BaseLibraryObject
local BaseLibrary = {
    --- @type table
    mt = { __tostring = function() end },
    --- @type Logger
    logger = {}
}

--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @class Namespace : Kapresoft_LibUtil_Mixins
local Namespace = {
    --- The namespace name (this is the AddOn Name)
    --- @type string
    name = "",

    ---Usage:
    ---```
    ---local GC = LibStub(LibName('GlobalConstants'), 1)
    ---```
    --- @type fun(moduleName:string, optionalMajorVersion:string)
    --- @return string The full LibStub library name. Example:  '[AddonName]-GlobalConstants-1.0.1'
    LibName = {},
    ---Usage:
    ---```
    ---local L = {}
    ---local mt = { __tostring = ns.ToStringFunction() }
    ---setmetatable(mt, L)
    ---```
    --- @type fun(moduleName:string)
    ToStringFunction = {},

    --- @type Kapresoft_LibUtil
    Kapresoft_LibUtil = {},
    --- @type fun(self:Namespace) : Kapresoft_LibUtil
    K = {},
    --- @type fun(self:Namespace) : Kapresoft_LibUtil_Objects
    KO = {},

    --- @type LocalLibStub
    LibStub = {},

    --- @type fun(o:any, ...) : void
    pformat = {},

}

--[[-----------------------------------------------------------------------------
GlobalObjects
-------------------------------------------------------------------------------]]
--- @class GlobalObjects
local GlobalObjects = {
    --- @type Kapresoft_LibUtil_AceLibraryObjects
    AceLibrary = {},
    --- @type LibStub
    AceLibStub = {},

    --- @type fun(fmt:string, ...)|fun(val:string)
    pformat = {},
    --- @type fun(fmt:string, ...)|fun(val:string)
    sformat = {},

    --- @type AceDbInitializerMixin
    AceDbInitializerMixin = {},
    --- @type Core
    Core = {},
    --- @type GlobalConstants
    GlobalConstants = {},
    --- @type Logger
    Logger = {},
    --- @type MainEventHandler
    MainEventHandler = {},
    --- @type OptionsMixin
    OptionsMixin = {},
}
