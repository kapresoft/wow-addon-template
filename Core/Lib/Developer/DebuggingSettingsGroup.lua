--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...); local O = ns.O
local NameDescG = ns.LocaleUtil.NameDescGlobal

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.DebuggingSettingsGroup()
--- @class DebuggingSettingsGroup
local S       = ns:NewLibWithEvent(libName)
local p       = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o DebuggingSettingsGroup | AceEventInterface
local function PropsAndMethods(o)
    --- spacer
    local sp = '                                                                   '
    local L  = ns:AceLocale()

    --- @return AceConfigOption
    function o:CreateDebuggingGroup()
        local seq = ns:CreateSequence(1)

        --- @type AceConfigOption
        local debugConf = {
            type = 'group',
            name = L['Debugging'],
            desc = L['Debugging::Desc'],
            order = 999, -- place last
            --- @type table<string, AceConfigOption>
            args = {},
        }

        self:DebugLevelSection(debugConf, seq)
        self:AddCategories(debugConf, seq)
        return debugConf;
    end

    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:DebugLevelSection(debugConf, seq)
        self:QuickLogLevelButtons(debugConf, seq)
        self:LogLevelSlider(debugConf, seq)
    end

    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:QuickLogLevelButtons(debugConf, seq)
        local a = debugConf.args
        a.off = {
            name = 'Off', type = "execute", order = seq:next(), width = 0.4, desc = "Turn Off Logging",
            func = function() a.log_level.set({}, 0) end,
        }
        a.info = {
            name = 'Info', type = "execute", order = seq:next(), width = 0.4, desc = "Info Log Level (15)",
            func = function() a.log_level.set({}, 15) end,
        }
        a.debugBtn = {
            name = 'Debug', type = "execute", order = seq:next(), width = 0.5, desc = "Debug Log Level (20)",
            func = function() a.log_level.set({}, 20) end,
        }
        a.fineBtn = {
            name = 'F1', type = "execute", order = seq:next(), width = 0.3, desc = "Fine Log Level (25)",
            func = function() a.log_level.set({}, 25) end,
        }
        a.finerBtn = {
            name = 'F2', type = "execute", order = seq:next(), width = 0.3, desc = "Finer Log Level (30)",
            func = function() a.log_level.set({}, 30) end,
        }
        a.finestBtn = {
            name = 'F3', type = "execute", order = seq:next(), width = 0.3, desc = "Finest Log Level (35)",
            func = function() a.log_level.set({}, 35) end,
        }
        a.traceBtn = {
            name = 'Trace', type = "execute", order = seq:next(), width = 0.4, desc = "Trace Log Level (50)",
            func = function() a.log_level.set({}, 50) end,
        }
        a.qlb_spacer = { type="description", name=sp, width="full", order = seq:next() }
    end

    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:LogLevelSlider(debugConf, seq)
        local a = debugConf.args
        a.log_level = {
            type = 'range', order = seq:next(),
            step = 1, bigStep=5, min = 0, max = 100, softMax=50, width = 1.5,
            get = function(_) return ns:GetLogLevel() end,
            set = function(_, v) ns:SetLogLevel(v) end,
        }; NameDescG(a.log_level, 'Log Level')
        a.spacer1b = { type="description", name=sp, width="full", order = seq:next() }
    end

    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:AddCategories(debugConf, seq)
        local a = debugConf.args
        local startSeq = seq:get()
        a.enable_all = {
            name = L['Debugging::Category::Enable All::Button'], desc = L['Debugging::Category::Enable All::Button::Desc'],
            type = "execute", order = seq:next(), width = 0.7,
            func = function()
                for _, option in pairs(a) do
                    if option.type == 'toggle' and option.order > startSeq then
                        option.set({}, true)
                    end
                end
            end }
        a.spacer2 = { type="description", name=' ', width=0.1, order = seq:next() }
        a.disable_all = {
            name = L['Debugging::Category::Disable All::Button'], desc = L['Debugging::Category::Disable All::Button::Desc'],
            type ="execute", order = seq:next(), width = 0.7,
            func = function()
                for _, option in pairs(a) do
                    if option.type == 'toggle' and option.order > startSeq then
                        option.set({}, false)
                    end
                end
            end }
        a.spacer3 = { type="description", name=' ', width="full", order = seq:next() },

        ns.CategoryLogger():ForEachCategory(function(cat)
            local elem = {
                type = 'toggle', name =cat.labelFn(), order = seq:next(), width =1.2,
                get  = function() return ns:IsLogCategoryEnabled(cat.name) end,
                set  = function(_, val) ns:SetLogCategory(cat.name, val) end
            }
            a[cat.name] = elem
        end)
    end

end; PropsAndMethods(S)

