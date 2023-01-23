--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local _, ns = ...
local O, LibStub, M, KO = ns.O, ns.LibStub, ns.M, ns:KO()
local pformat = ns.pformat

local ACE = O.AceLibrary
local AceConfig, AceConfigDialog = ACE.AceConfig, ACE.AceConfigDialog
local IsEmptyTable = KO.Table.isEmpty

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsMixin : BaseLibraryObject
local L = LibStub:NewLibrary(M.OptionsMixin)
local p = L.logger;

--- @param addon AddonTemplate
function L:Init(addon)
    self.addon = addon
end

--- @param o OptionsMixin
local function Methods(o)

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
                --enable = {
                --    type = "toggle",
                --    name = "Enable",
                --    desc = "Enable Addon",
                --    order = 1,
                --},
                general = {
                    type = "group",
                    name = "General",
                    desc = "General Settings",
                    order = 2,
                    args = {
                        desc = { name = " General Configuration ", type = "header", order = 0 },
                        --enable_button1 = {
                        --    type = 'toggle',
                        --    disabled = false,
                        --    order = 1,
                        --    name = 'Enable',
                        --    get = function() end,
                        --    set = function() end,
                        --},
                    },
                },
            }
        }
        return options
    end

    function o:InitOptions()
        AceConfig:RegisterOptionsTable(ns.name, self:CreateOptions(), { "adt_options" })
        AceConfigDialog:AddToBlizOptions(ns.name, ns.nameShort)
    end

end

Methods(L)
