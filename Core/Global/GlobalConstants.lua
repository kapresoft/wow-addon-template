if type(SDNR_DB) ~= "table" then SDNR_DB = {} end
if type(SDNR_LOG_LEVEL) ~= "number" then SDNR_LOG_LEVEL = 1 end
if type(SDNR_DEBUG_MODE) ~= "boolean" then SDNR_DEBUG_MODE = false end


--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
---@type string
local addon
---@type Namespace
local ns
addon, ns = ...

local pformat = Kapresoft_LibUtil.PrettyPrint.pformat
local addonShortName = 'SavedDNR'
local useShortName = true

local LibStub = LibStub

local TOSTRING_ADDON_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe}}|r'
local TOSTRING_SUBMODULE_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe::|r|cfdfbeb2d%s|r|cfdfefefe}}|r'

---@param moduleName string
---@param optionalMajorVersion number|string
local function LibName(moduleName, optionalMajorVersion)
    assert(moduleName, "Module name is required for LibName(moduleName)")
    local majorVersion = optionalMajorVersion or '1.0'
    local v = sformat("%s-%s-%s", addon, moduleName, majorVersion)
    return v
end
---@param moduleName string
local function ToStringFunction(moduleName)
    local name = addon
    if useShortName then name = addonShortName end
    if moduleName then return function() return string.format(TOSTRING_SUBMODULE_FMT, name, moduleName) end end
    return function() return string.format(TOSTRING_ADDON_FMT, name) end
end

---@class LocalLibStub
local S = {}

---@param moduleName string
---@param optionalMinorVersion number
function S:NewLibrary(moduleName, optionalMinorVersion)
    --use Ace3 LibStub here
    local o = LibStub:NewLibrary(LibName(moduleName), optionalMinorVersion or 1)
    assert(o, sformat("Module not found: %s", tostring(moduleName)))
    o.mt = getmetatable(o) or {}
    o.mt.__tostring = ns.ToStringFunction(moduleName)
    setmetatable(o, o.mt)
    ns:Register(moduleName, o)
    ---@type Logger
    local loggerLib = LibStub(LibName(ns.M.Logger), 1)
    o.logger = loggerLib:NewLogger(moduleName)
    return o
end

---@param moduleName string
---@param optionalMinorVersion number
function S:GetLibrary(moduleName, optionalMinorVersion) return LibStub(LibName(moduleName), optionalMinorVersion or 1) end

S.mt = { __call = function (_, ...) return S:GetLibrary(...) end }
setmetatable(S, S.mt)

---@class GlobalConstants
local L = LibStub:NewLibrary(LibName('GlobalConstants'), 1)

---@param o GlobalConstants
local function Methods(o)
    --  TODO
end
Methods(L)

ns.LibName = LibName
ns.ToStringFunction = ToStringFunction
ns.LibStub = S