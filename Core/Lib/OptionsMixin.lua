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
Method and Properties
-------------------------------------------------------------------------------]]
--- @param o OptionsMixin
local function MethodsAndProps(o)
    local L = ns:AceLocale()
    local util = O.OptionsUtil:New(o)

    --- Called automatically by CreateAndInitFromMixin(..)
    --- @param optionsMixin AddonTemplate
    function o:Init(optionsMixin) self.optionsMixin = optionsMixin end

    --- Usage:  local instance = OptionsMixin:New(addon)
    --- @param optionsMixin OptionsMixin
    --- @return OptionsMixin
    function o:New(optionsMixin) return ns:K():CreateAndInitFromMixin(o, optionsMixin) end

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
                            get =  util:ProfileGet('enableSomething'),
                            set = util:ProfileSet('enableSomething')
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
