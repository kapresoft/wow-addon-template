--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local ns = adt_ns(...)
local O, GC, M, LibStub = ns.O, ns.GC, ns.M, ns.LibStub
local ACE = O.AceLibrary
local AceConfig, AceConfigDialog, AceDBOptions = ACE.AceConfig, ACE.AceConfigDialog, ACE.AceDBOptions
local DebugSettings = O.DebuggingSettingsGroup
local AceEvent = ns:AceEvent()
local libName = M.OptionsMixin
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsMixin : BaseLibraryObject
local S = LibStub:NewLibrary(libName)
local p = ns:LC().OPTIONS:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @see GlobalConstants#M for Message names
---@param optionalVal any|nil
local function SendMessage(addOnMessage, optionalVal)
    AceEvent:SendMessage(addOnMessage, libName, optionalVal)
end

--- @param propKey string
--- @param defVal any
local function _GetGlobalValue(propKey, defVal) return ns:db().global[propKey] or defVal end

--- @param propKey string
--- @param val any
local function _SetGlobalValue(propKey, val) ns:db().global[propKey] = val end

--- @param propKey string
--- @param defVal any
local function _GetValue(propKey, defVal) return ns:db().profile[propKey] or defVal end

--- @param propKey string
--- @param val any
local function _SetValue(propKey, val) ns:db().profile[propKey] = val end

--- @param fallback any The fallback value
--- @param key string The key value
local function ProfileGet(key, fallback)
    return function(_)
        return _GetValue(key, fallback)
    end
end
--- @param key string The key value
local function ProfileSet(key, eventMessageToFire)
    return function(_, v)
        _SetValue(key, v)
        if 'string' == type(eventMessageToFire) then
            SendMessage(eventMessageToFire, v)
        end
    end
end
--- @param fallback any The fallback value
--- @param key string The key value
local function GlobalGet(key, fallback)
    return function(_)
        return _GetGlobalValue(key, fallback)
    end
end
--- @param key string The key value
local function GlobalSet(key, eventMessageToFire)
    return function(_, v)
        _SetGlobalValue(key, v)
        if 'string' == type(eventMessageToFire) then
            SendMessage(eventMessageToFire, v)
        end
    end
end

--[[-----------------------------------------------------------------------------
Method and Properties
-------------------------------------------------------------------------------]]
--- @param o OptionsMixin
local function MethodsAndProps(o)
    local L = ns:AceLocale()

    --- Called automatically by CreateAndInitFromMixin(..)
    --- @param addon AddonTemplate
    function o:Init(addon)
        self.addon = addon
    end

    --- Usage:  local instance = OptionsMixin:New(addon)
    --- @param addon AddonTemplate
    --- @return OptionsMixin
    function o:New(addon) return ns:K():CreateAndInitFromMixin(o, addon) end

    function o:CreateOptions()
        local options = {
            name = ns.name,
            handler = self,
            type = "group",
            args = {
                general = {
                    type = "group",
                    name = L['General'],
                    desc = L['General::Desc'],
                    order = 2,
                    args = {
                        desc = { name = " " .. L['General Configuration'] .. " ", type = "header", order = 0 },
                        enable = {
                            type = "toggle",
                            name = "Enable",
                            desc = "Enable Addon",
                            order = 1,
                            get =  ProfileGet('enableSomething'),
                            set = ProfileSet('enableSomething')
                        }
                    },
                },
                debugging = DebugSettings:CreateDebuggingGroup(),
            }
        }
        return options
    end

    function o:InitOptions()
        local options = self:CreateOptions()
        -- This creates the Profiles Tab/Section in Settings UI
        options.args.profiles = AceDBOptions:GetOptionsTable(ns:db())

        --AceConfigDialog:SetDefaultSize(ns.name, 950, 600)
        AceConfig:RegisterOptionsTable(ns.name, options, { "adt_options" })
        AceConfigDialog:AddToBlizOptions(ns.name, ns.nameShort)
    end

end; MethodsAndProps(S)
