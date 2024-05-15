--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

local O, GC, Ace                 = ns.O, ns.GC(), ns:AceLibrary()
local AceConfig, AceConfigDialog = Ace.AceConfig, Ace.AceConfigDialog
local AceDBOptions               = Ace.AceDBOptions

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.OptionsMixin()
--- @class OptionsMixin
local S = ns:NewLib(libName)
local p = ns:LC().OPTIONS:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Method and Properties
-------------------------------------------------------------------------------]]
--- @param o OptionsMixin
local function MethodsAndProps(o)
    local L    = ns:AceLocale()
    local util = O.OptionsUtil:New(o)

    --- Called automatically by CreateAndInitFromMixin(..)
    --- @param optionsMixin AddonTemplate
    function o:Init(optionsMixin)
        self.optionsMixin = optionsMixin
        self.util         = util
    end

    --- Usage:  local instance = OptionsMixin:New(addon)
    --- @param optionsMixin OptionsMixin
    --- @return OptionsMixin
    function o:New(optionsMixin) return ns:K():CreateAndInitFromMixinWithDefExc(o, optionsMixin) end

    function o:CreateOptions()
        local options = {
            name    = ns.name,
            handler = self,
            type    = "group",
            args    = {
                general = {
                    type  = "group",
                    name  = L['General'],
                    desc  = L['General::Desc'],
                    order = 2,
                    args  = {
                        enable = {
                            type  = "toggle",
                            name  = "Enable",
                            desc  = "Enable Addon",
                            order = 1,
                            get   = util:ProfileGet('enableSomething'),
                            set   = util:ProfileSet('enableSomething')
                        }
                    },
                },
            }
        }; self:ConfigureDebugging(options)
        return options
    end

    ---@param opt AceConfigOption
    function o:ConfigureDebugging(opt)
        --@do-not-package@
        if ns.debug:IsDeveloper() then
            opt.args.debugging = O.DebuggingSettingsGroup:CreateDebuggingGroup()
            p:a(function() return 'Debugging tab in Settings UI is enabled.' end)
            return
        end
        --@end-do-not-package@
        ADT_LOG_LEVEL = 0
    end

    function o:InitOptions()
        local options = self:CreateOptions()
        -- This creates the Profiles Tab/Section in Settings UI
        options.args.profiles = AceDBOptions:GetOptionsTable(ns:db())

        --AceConfigDialog:SetDefaultSize(ns.name, 950, 600)
        AceConfig:RegisterOptionsTable(ns.name, options, {
            GC.C.CONSOLE_COMMAND_OPTIONS, GC.C.CONSOLE_COMMAND_OPTIONS_SHORT
        })
        AceConfigDialog:AddToBlizOptions(ns.name, ns.nameShort)
        if O.API:GetUIScale() > 1.0 then return end

        AceConfigDialog:SetDefaultSize(ns.addon, 950, 600)
    end

end; MethodsAndProps(S)
