--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local ns = adt_ns(...)
local O, GC, M, LibStub = ns.O, ns.GC, ns.M, ns.LibStub

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @return DebuggingSettingsGroup, Kapresoft_CategoryLogger
local function CreateLib()
    local libName = M.DebuggingSettingsGroup
    --- @class DebuggingSettingsGroup : BaseLibraryObject
    local newLib = LibStub:NewLibrary(libName); if not newLib then return nil end
    local logger = ns:CreateDefaultLogger(libName)
    return newLib, logger
end; local LIB, p = CreateLib(); if not LIB then return end

local dbgSeq = ns:CreateSequence()

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o DebuggingSettingsGroup
local function PropsAndMethods(o)
    --- spacer
    local sp = '                                                                   '
    local L = ns:AceLocale()

    --- @return AceConfigOption
    function o:CreateDebuggingGroup()

        --- @type AceConfigOption
        local debugConf = {
            type = 'group',
            name = L['Debugging'],
            desc = L['Debugging::Desc'],
            -- Place right before Profiles
            order = 90,

            args = {
                desc = { name = sformat(" %s ", L['Debugging Configuration']), type = "header", order = dbgSeq:next() },
                spacer1a = { type="description", name=sp, width="full", order = dbgSeq:next() },
                log_level = {
                    type = 'range',
                    order = dbgSeq:next(),
                    step = 5,
                    min = 0,
                    max = 50,
                    width = 1.5,
                    name = L['Log Level'],
                    desc = L['Log Level::Desc'],
                    get = function(_) return ns:GetLogLevel() end,
                    set = function(_, v) ns:SetLogLevel(v) end,
                },
                spacer1b = { type="description", name=sp, width="full", order = dbgSeq:next() },
                desc_cat = { name = ' ' .. L['Categories'] .. ' ', type = "header", order = dbgSeq:next() },
                spacer1c = { type="description", name=sp, width="full", order = dbgSeq:next() },
            },
        }

        self:AddCategories(debugConf)
        return debugConf;
    end

    ---@param conf AceConfigOption
    function o:AddCategories(conf)
        conf.args.enable_all = {
            name = L['Debugging::Category::Enable All::Button'], desc = L['Debugging::Category::Enable All::Button::Desc'],
            type = "execute", order = dbgSeq:next(), width = 'normal',
            func = function()
                for _, option in pairs(conf.args) do
                    if option.type == 'toggle' then option.set({}, true) end
                end
            end }
        conf.args.disable_all = {
            name = L['Debugging::Category::Disable All::Button'], desc = L['Debugging::Category::Disable All::Button::Desc'],
            type="execute", order=dbgSeq:next(), width = 'normal',
            func = function()
                for _, option in pairs(conf.args) do
                    if option.type == 'toggle' then option.set({}, false) end
                end
            end }
        conf.args.spacer2 = { type="description", name=sp, width="full", order = dbgSeq:next() },

        ns.LogCategory:ForEachCategory(function(cat)
            local elem = {
                type = 'toggle', name=cat.labelFn(), order=dbgSeq:next(), width=1.2,
                get = function() return ns:IsLogCategoryEnabled(cat.name) end,
                set = function(_, val) ns:SetLogCategory(cat.name, val) end
            }
            conf.args[cat.name] = elem
        end)
    end

end; PropsAndMethods(LIB)

