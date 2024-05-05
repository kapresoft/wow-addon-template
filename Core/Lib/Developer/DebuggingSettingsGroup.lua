--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...); local O = ns.O

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

        local NameDescG      = ns.LocaleUtil.NameDescGlobal
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
    end

    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:DebugLevelSection(debugConf, seq)
        local a = debugConf.args

        a.desc      = { name = sformat(" %s ", L['Debug Configuration']), type = "header", order = seq:next() }
        a.spacer1a  = { type = "description", name = sp, width = 'full', order = seq:next() }
        a.log_level = {
            type  = 'range', order = seq:next(), step  = 5, min   = 0, max   = 50, width = 1.5,
            name  = L['Log Level'], desc  = L['Log Level::Desc'],
            get   = function(_) return ns:GetLogLevel() end,
            set   = function(_, v) ns:SetLogLevel(v) end,
        }
        a.spacer1b = { type="description", name=sp, width="full", order = seq:next() }

        self:QuickLogLevelButtons(debugConf, seq)
    end


    --- @param debugConf AceConfigOption
    --- @param seq Kapresoft_SequenceMixin
    function o:QuickLogLevelButtons(debugConf, seq)
        local a = debugConf.args
        a.off  = {
            name  = 'off',
            type  = "execute", order = seq:next(), width = 'half',
            desc  = "Turn Off Logging",
            order = seq:next(),
            func  = function() a.log_level.set({}, 0) end,
        }
        a.info = {
            name  = 'info',
            type  = "execute", order = seq:next(), width = 'half',
            desc  = "Info Log Level (15)",
            order = seq:next(),
            func  = function() a.log_level.set({}, 15) end,
        }
        a.debugBtn = {
            name  = 'debug',
            type  = "execute", order = seq:next(), width = 'half',
            desc  = "Debug Log Level (20)",
            order = seq:next(),
            func  = function() a.log_level.set({}, 20) end,
        }
        a.fineBtn   = {
            name  = 'fine',
            type  = "execute", order = seq:next(), width = 'half',
            desc  = "Fine Log Level (25)",
            order = seq:next(),
            func  = function() a.log_level.set({}, 25) end,
        }
        a.finerBtn = {
            name  = 'finer',
            type  = "execute", order = seq:next(), width = 'half',
            desc  = "Finer Log Level (30)",
            order = seq:next(),
            func  = function() a.log_level.set({}, 30) end,
        }
        a.finestBtn = {
            name  = 'finest',
            type  = "execute", order = seq:next(), width = 'half',
            desc  = "Finest Log Level (35)",
            order = seq:next(),
            func  = function() a.log_level.set({}, 35) end,
        }
        a.traceBtn = {
            name  = 'trace',
            type  = "execute", order = seq:next(), width = 'half',
            desc  = "Trace Log Level (50)",
            order = seq:next(),
            func  = function() a.log_level.set({}, 50) end,
        }
        a.desc_cat = { name = "Categories", type = "header", order = seq:next() }
        a.spacer1d = { type = "description", name = sp, width = "full", order = seq:next() }
    end

    ---@param debugConf AceConfigOption
    ---@param seq Kapresoft_SequenceMixin
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

