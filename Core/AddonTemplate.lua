--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat, unpack = string.format, unpack

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...); local addon = ns.addon
local O, GC, LibStub = ns.O, ns.GC(), ns.LibStubAce()

local Table, String         = ns:Table(), ns:String()
local AceConfigDialog       = ns:AceConfigDialog()
local IsAnyOf, IsEmptyTable = String.IsAnyOf, Table.isEmpty

local GENERAL_TAB           = 'general'
local DEBUGGING_TAB         = 'debugging'

--- @class AddonTemplate
local A = LibStub("AceAddon-3.0"):NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local mt = getmetatable(A) or {}; mt.__tostring = ns:ToStringFunction()
local p = ns:CreateDefaultLogger(addon)

local c1 = ns:K():cf(HIGHLIGHT_LIGHT_BLUE)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
do
    local o = A;
    O.MainController:Init(o)

    function o:OnInitialize()
        p:f3("OnInitialize() called...")
        self:RegisterSlashCommands()
        O.AceDbInitializerMixin:New(self):InitDb()
        O.OptionsMixin:New(self.addon):InitOptions()
        self:SendMessage(GC.M.OnAfterInitialize, self)
    end

    function o:ns() return ns end

    function o:RegisterSlashCommands()
        self:RegisterChatCommand(GC.C.CONSOLE_COMMAND_NAME, "SlashCommands")
        self:RegisterChatCommand(GC.C.CONSOLE_COMMAND_SHORT, "SlashCommands")
    end

    function o:SlashCommand_OpenConfig() o:OpenConfig() end
    function o:SlashCommand_Info_Handler() p:a(GC:GetAddonInfoFormatted()) end
    function o:SlashCommand_Help_Handler()
        local C = GC.C
        p:a('')
        local COMMAND_INFO_TEXT = "Prints additional addon info"
        local COMMAND_CONFIG_TEXT = "Shows the config UI"
        local COMMAND_HELP_TEXT = "Shows this help"
        local OPTIONS_LABEL = "options"
        local USAGE_LABEL = sformat(
                "usage: %s or %s [%s]",
                C.CONSOLE_SHORT_COMMAND_PLAIN, C.CONSOLE_PLAIN,  OPTIONS_LABEL)
        p:a(USAGE_LABEL)
        p:a(OPTIONS_LABEL .. ":")
        p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'config', COMMAND_CONFIG_TEXT end)
        p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'info', COMMAND_INFO_TEXT end)
        p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'help', COMMAND_HELP_TEXT end)
        --@do-not-package@
        if ns.debug:IsDeveloper() then
            p:a(c1('options (debug):'))
            p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'dump', 'dump ADT' end)
            p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'dumpns', 'dump ADT.ns()' end)
        end
        --@end-do-not-package@
    end

    --- @param spaceSeparatedArgs string
    function o:SlashCommands(spaceSeparatedArgs)
        local args = Table.parseSpaceSeparatedVar(spaceSeparatedArgs)
        if IsEmptyTable(args) then
            self:SlashCommand_Help_Handler(); return
        end
        if IsAnyOf('config', unpack(args)) or IsAnyOf('conf', unpack(args)) then
            return self:SlashCommand_OpenConfig()
        elseif IsAnyOf('info', unpack(args)) then
            return self:SlashCommand_Info_Handler()
        end
        --@do-not-package@
        if IsAnyOf('dump', unpack(args)) then
            return ns:K().dump('ADT')
        elseif IsAnyOf('dumpns', unpack(args)) then
            return ns:K().dump('ADT_NS')
        end
        --@end-do-not-package@
        self:SlashCommand_Help_Handler()
    end

    --- @param enableSound BooleanOptional
    function o:OnHide_Config(enableSound)
        local enable = enableSound == true
        p:d(function() return 'OnHide_Config called with enableSound=%s', tostring(enable) end)
        if true == enable then PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE) end
    end
    function o:OnHide_Config_WithSound() self:OnHide_Config(true) end
    function o:OnHide_Config_WithoutSound() self:OnHide_Config() end

    ---@param tabName Name
    function o:OpenConfig(tabName)
        tabName = tabName or GENERAL_TAB
        local dlg = AceConfigDialog
        if dlg.OpenFrames[addon] then return dlg:SelectGroup(addon, tabName) end

        dlg:Open(addon)
        self:DialogGlitchHack(tabName)

        self.onHideHooked = self.onHideHooked or false
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
        self.configDialogWidget = dlg.OpenFrames[addon]
        if not self.onHideHooked then
            self:HookScript(self.configDialogWidget.frame, 'OnHide', 'OnHide_Config_WithSound')
            self.onHideHooked = true
        end
    end

    function o:OpenConfigDebug() self:OpenConfig(DEBUGGING_TAB) end

    --- This hacks solves the range UI notch not positioning properly
    function o:DialogGlitchHack(tabName)
        local dlg = AceConfigDialog
        dlg:Open(addon)
        dlg:SelectGroup(addon, DEBUGGING_TAB)
        if tabName == DEBUGGING_TAB then return end

        C_Timer.After(0.01, function() dlg:SelectGroup(addon, tabName) end)
    end

end; ADT = A
