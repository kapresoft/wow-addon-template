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

        self:DebugConsoleSection(debugConf, seq)
        self:DebugLevelSection(debugConf, seq)
        self:AddCategories(debugConf, seq)
        return debugConf;
    end

    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:DebugConsoleSection(debugConf, seq)

        local function DebugConsoleGetFn() return ns:dbg().enableLogConsole == true end

        local function DebugConsoleSetFn(_, v)
            local val = (v == true)
            ns:dbg().enableLogConsole = val
            o:SendMessage(ns.GC().M.OnDebugConsoleToggle, libName)
        end

        local a              = debugConf.args

        a.descDBC            = { name = sformat(" %s ", L['Debug Console']), type = "header", order = seq:next() }
        a.spacer1aDBC        = { type = "description", name = sp, width = 'full', order = seq:next() }

        -- L['Enable Debug Console::Desc']
        a.enableDebugConsole = {
            type = 'toggle', order = seq:next(), width = 'normal',
            get  = DebugConsoleGetFn,
            set  = DebugConsoleSetFn,
        }; NameDescG(a.enableDebugConsole, 'Enable Debug Console')
        a.showTabOnLoad = {
            type = 'toggle', order = seq:next(), width = 'normal',
            get = function() return ns:dbg().selectLogConsoleTab == true  end,
            set = function(_, v) ns:dbg().selectLogConsoleTab = (v == true) end,
        }; NameDescG(a.showTabOnLoad, 'Show Tab On Load')

        a.maxLines = {
            type = 'range', order = seq:next(), width = 'normal',
            min=10, max=10000, softMin=500, softMax=5000,
            step=1, bigStep=100,
            get = function() return ns:dbg().maxLogConsoleLines  end,
            set = function(_, v)
                ns:dbg().maxLogConsoleLines = v
                ns:ChatFrame():SetMaxLines(v)
            end,
        }; NameDescG(a.maxLines, 'Max Lines')
        a.spacer1c = { type="description", name=sp, width="full", order = seq:next() }

        a.DEVTOOLS_DEPTH_CUTOFF = {
            type = 'range', order = seq:next(), width = 1.5,
            min=1, max=50, softMin=2, softMax=10, step=1, bigStep=1,
            get = function() return DEVTOOLS_DEPTH_CUTOFF or 1  end,
            set = function(_, v)
                DEVTOOLS_DEPTH_CUTOFF = v
            end,
        }; NameDescG(a.DEVTOOLS_DEPTH_CUTOFF, 'DEVTOOLS_DEPTH_CUTOFF')
        a.spacer1d = { type="description", name=sp, width=0.2, order = seq:next() }

        a.DEVTOOLS_MAX_ENTRY_CUTOFF = {
            type = 'range', order = seq:next(), width = 1.5,
            min=1, max=1000, softMin=10, softMax=200, step=1, bigStep=10,
            get = function() return DEVTOOLS_MAX_ENTRY_CUTOFF or 1  end,
            set = function(_, v)
                DEVTOOLS_MAX_ENTRY_CUTOFF = v
            end,
        }; NameDescG(a.DEVTOOLS_MAX_ENTRY_CUTOFF, 'DEVTOOLS_MAX_ENTRY_CUTOFF')

        a.spacer1e = { type="description", name=sp, width="full", order = seq:next() }
    end

    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:DebugLevelSection(debugConf, seq)
        local a = debugConf.args

        a.desc      = { name = sformat(" %s ", L['Debug Configuration']), type = "header", order = seq:next() }
        a.spacer1a  = { type = "description", name = sp, width = 'full', order = seq:next() }

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

