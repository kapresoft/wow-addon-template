
--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
if not ns.debug:IsDeveloper() then return end

local GC = ns.GC()
local colorUtil      = ns:KO().ColorUtil
local primaryColor   = colorUtil:NewColorFromHex(ns.consoleColors.primary .. 'fc')
local secondaryColor = colorUtil:NewColorFromHex(ns.consoleColors.secondary .. 'fc')

local c1, c2  = ns:K():cf(primaryColor.color), ns:K():cf(secondaryColor.color)
local c3, c4  = ns:K():cf(ADVENTURES_COMBAT_LOG_BLUE), ns:K():cf(FACTION_GREEN_COLOR)
local c5      = ns:K():cf(LIGHTGRAY_FONT_COLOR)
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.DebugConsole()
local libNamePretty = c1('DBGC')
--- @class DebugConsole
local L = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Main Code
Available Fonts:
 ConsoleMonoCondensedSemiBold
 ConsoleMonoCondensedSemiBoldOutline
 ConsoleMonoSemiCondensedBlack
 ConsoleMedium
 ConsoleMediumOutline
 SystemFont_Outline_Small
-------------------------------------------------------------------------------]]

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type DebugConsole | AceEventInterface
local o = L; do

    local pre = ns.sformat('{{%s}}', libNamePretty)
    local logp = ns.LogFunctions.logp(pre)
    local printp = ns.LogFunctions.printp(pre)


    --- @private
    function o.OnAddonReady()
        -- give some delay so the Chat Frame UI size isn't wonky on LogIn
        C_Timer.After(0.5, function() o:InitializeDebugChatFrame() end)
        o:RegisterMessage(GC.M.OnDebugConsoleToggle, o.OnDebugConsoleStateChanged)
    end

    --- @private
    function o.OnDebugConsoleStateChanged() o:ToggleDebugConsole() end

    --- @private
    function o:InitializeDebugChatFrame()
        if ns:db().global.debug.enableLogConsole ~= true then return end
        ns.O.DebugConsole:EnableDebugChatFrame()
        ns:ChatFrame():InitialTabSelection(ns:dbg().selectLogConsoleTab)
        p:f3(function() return 'IsShown(): %s', ns:IsChatFrameTabShown() end)
    end

    function o:ToggleDebugConsole()
        local enable = ns:dbg().enableLogConsole == true
        if enable ~= true and ns:HasChatFrame() then
            ns:ChatFrame():CloseTab()
            return p:vv('Debug console DISABLED')
        end
        self:EnableDebugChatFrame()
        p:vv('Debug console ENABLED')
    end

    --- Enable Debug Chat Frame
    function o:EnableDebugChatFrame()
        if ns:HasChatFrame() then
            local chatFrame = ns:ChatFrame()
             chatFrame:RestoreChatFrame(ns:dbg().selectLogConsoleTab)
            printp(libName, 'Chat frame exists:', ns:ChatFrame():GetName())
            return chatFrame
        end

        local function LoadDebugChatFrame()
            local addonName = 'DebugChatFrame'
            local U = ns:KO().AddonUtil
            U:LoadOnDemand(addonName, function(loadSuccess)
                print(pre, addonName, 'Loaded OnDemand:', loadSuccess)
            end)
        end; LoadDebugChatFrame()
        if not DebugChatFrame then return print(pre, 'DebugChatFrame is not available') end

        --- @type DebugChatFrameInterface
        local dcf = DebugChatFrame

        --- @type DebugChatFrameOptionsInterface
        local opt = {
            -- TODO: Add ColorProfile(primary, secondary, tertiary, others?)
            addon = string.upper(ns.addonLogName),
            chatFrameTabName = ns.addonShortName,
            font = DCF_ConsoleMonoCondensedSemiBoldOutline,
            fontSize = 16,
            windowAlpha = 0.9,
            maxLines = ns:dbg().maxLogConsoleLines,
        }

        --- @type ChatLogFrameInterface
        local cf  = dcf:New(opt, function(chatFrame)
            chatFrame:SetAlpha(1.0)
            local windowColor = ns:ColorUtil():NewColorFromHex('343434fc')
            FCF_SetWindowColor(chatFrame, windowColor:GetRGBA())
            FCF_SetWindowAlpha(chatFrame, opt.windowAlpha)
            ns:RegisterChatFrame(chatFrame)
        end)

        logp(c5('-------------------------------------------'))
        logp('Debug ChatFrame initialized.')
        logp('GameVersion:', c4(ns.gameVersion))

        local font, size, flags = cf:GetFont()
        logp('Size:', c3(size), 'Flags:', c3(flags), 'Font:', c5(font))

        printp(c2(cf:GetName()), c3(ns.sformat('(%s)', opt.chatFrameTabName)),
             'selected:', c3(cf:IsSelected()))
        printp(c2(DEFAULT_CHAT_FRAME:GetName()), c3('(DEFAULT_CHAT_FRAME)'))
        logp('Log Commands:')
        logp('    ', c3('/run d:log("hello","there")'))
        logp('    ', c3('/run d:logp("hello","there")'))
        logp(c5('-------------------------------------------'), '\n\n')

        return ns:ChatFrame()
    end

    o:RegisterMessage(GC.M.OnAddonReady, o.OnAddonReady)

end



