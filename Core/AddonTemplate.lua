--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat, unpack = string.format, unpack

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local _, ns = ...
local O, M = ns.O, ns.M

local LibStub = LibStub
local KO = ns:KO()

local GC, ACE, Table, String = O.GlobalConstants, O.AceLibrary, KO.Table, KO.String
local AceConfigDialog = ACE.AceConfigDialog
local toStringSorted, pformat = Table.toStringSorted, O.pformat
local IsBlank, IsAnyOf, IsEmptyTable = String.IsBlank, String.IsAnyOf, Table.isEmpty

--- @class AddonTemplate
local A = LibStub("AceAddon-3.0"):NewAddon(ns.name, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local mt = getmetatable(A) or {}
mt.__tostring = ns:ToStringFunction()
local p = O.Logger:NewLogger()
A.logger = p

--setmetatable(A, mt)
ns['addon'] = A

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o AddonTemplate
local function Methods(o)
    O.MainEventHandler:Init(o)

    function o:OnInitialize()
        p:log(10, "Initialized called..")

        self:RegisterSlashCommands()
        self:SendMessage(GC.M.OnAfterInitialize, self)

        O.AceDbInitializerMixin:New(self):InitDb()
        O.OptionsMixin:New(self):InitOptions()
    end

    function o:RegisterHooks()
        --- TODO: Is this needed?
    end

    function o:SlashCommand_OpenConfig() o:OpenConfig() end

    function o:RegisterSlashCommands()
        self:RegisterChatCommand(GC.C.CONSOLE_COMMAND_NAME, "SlashCommands")
    end

    --- @param spaceSeparatedArgs string
    function o:SlashCommands(spaceSeparatedArgs)
        local args = Table.parseSpaceSeparatedVar(spaceSeparatedArgs)
        if IsEmptyTable(args) then
            self:SlashCommand_Help_Handler(); return
        end
        if IsAnyOf('config', unpack(args)) or IsAnyOf('conf', unpack(args)) then
            self:SlashCommand_OpenConfig(); return
        end
        if IsAnyOf('info', unpack(args)) then
            self:SlashCommand_Info_Handler(); return
        end
        if IsAnyOf('list', unpack(args)) then
            self:SlashCommand_ListSavedInstances(); return
        end
        -- Otherwise, show help
        self:SlashCommand_Help_Handler()
    end

    function o:SlashCommand_Info_Handler()
        p:log(GC:GetAddonInfoFormatted())
    end

    function o:SlashCommand_Help_Handler()
        p:log('')
        local COMMAND_INFO_TEXT = ":: Prints additional addon info"
        local COMMAND_CONFIG_TEXT = ":: Shows the config UI"
        local COMMAND_HELP_TEXT = ":: Shows this help"
        local OPTIONS_LABEL = "options"
        local USAGE_LABEL = sformat("usage: %s [%s]", GC.C.CONSOLE_PLAIN, OPTIONS_LABEL)
        p:log(USAGE_LABEL)
        p:log(OPTIONS_LABEL .. ":")
        p:log(GC.C.CONSOLE_OPTIONS_FORMAT, 'config', COMMAND_CONFIG_TEXT)
        p:log(GC.C.CONSOLE_OPTIONS_FORMAT, 'info', COMMAND_INFO_TEXT)
        p:log(GC.C.CONSOLE_OPTIONS_FORMAT, 'help', COMMAND_HELP_TEXT)
    end

    function o:OpenConfig()
        AceConfigDialog:Open(ns.name)
        self.onHideHooked = self.onHideHooked or false
        self.configDialogWidget = AceConfigDialog.OpenFrames[ns.name]

        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
        if not self.onHideHooked then
            --self:HookScript(self.configDialogWidget.frame, 'OnHide', 'OnHide_Config_WithSound')
            --self.onHideHooked = true
        end
    end

    function o:BINDING_ADT_OPTIONS_DLG() self:OpenConfig() end
end

--- @param o AddonTemplate
local function RegisterEvents(o)

end

local function Constructor()
    Methods(A)
    RegisterEvents(A)

    p:log('Loaded: %s', ns.name)
    p:log('Namespace keys: %s', ns:ToStringNamespaceKeys())
    p:log('Namespace Object keys: %s', ns:ToStringObjectKeys())

    ADT = A

end

Constructor()
