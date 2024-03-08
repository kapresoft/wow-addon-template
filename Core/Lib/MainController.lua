--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local CreateFrame, FrameUtil = CreateFrame, FrameUtil
local RegisterFrameForEvents, RegisterFrameForUnitEvents = FrameUtil.RegisterFrameForEvents, FrameUtil.RegisterFrameForUnitEvents

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local ns = adt_ns(...)
local O, GC, M = ns.O, ns.GC, ns.M
local Ace, LibStub = ns.KO().AceLibrary.O, ns.LibStub
local E, MSG = GC.E, GC.M

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class MainController : BaseLibraryObject_WithAceEvent
local L = LibStub:NewLibrary(M.MainController, 1); if not L then return end
Ace.AceEvent:Embed(L)
local p = ns:LC().DEFAULT:NewLogger(M.MainController)
local pp = ns:CreateDefaultLogger(ns.name)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]

---Other modules can listen to message
---```Usage:
---AceEvent:RegisterMessage(MSG.OnAddonReady, function(evt, ...) end
---```
--- @param addon AddonTemplate
local function SendAddonReadyMessage(addon)
    L:SendMessage(MSG.OnAddonReady, addon)
end

--- @param f MainControllerFrame
local function OnPlayerEnteringWorld(f, event, ...)
    local isLogin, isReload = ...
    local addon = f.ctx.addon

    SendAddonReadyMessage(addon)

    --@debug@
    isLogin = true
    p:d(function() return "IsLogin=%s IsReload=%s", tostring(isLogin), tostring(isReload) end)
    --@end-debug@

    if not isLogin then return end

    pp:vv(GC:GetMessageLoadedText())
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o MainController
local function InstanceMethods(o)

    ---Init Method: Called by Mixin
    ---Example:
    ---```
    ---local newInstance = Mixin:MixinAndInit(O.MainControllerMixin, addon)
    ---```
    --- @param addon AddonTemplate
    function o:Init(addon)
        self.addon = addon
        self:RegisterMessage(MSG.OnAfterInitialize, function(evt, ...) self:OnAfterInitialize() end)
    end

    function o:OnAfterInitialize() self:RegisterEvents() end

    --- @private
    function o:RegisterEvents()
        p:f1("RegisterEvents called...")
        self:RegisterOnPlayerEnteringWorld()
        self:RegisterMessage(MSG.OnAddonReady, function() self:OnAddonReady()  end)
    end

    --- @private
    function L:OnAddonReady()
        O.OptionsMixin:New(self.addon):InitOptions()
    end

    --- @private
    function L:RegisterOnPlayerEnteringWorld()
        local f = self:CreateEventFrame()
        f:SetScript(E.OnEvent, OnPlayerEnteringWorld)
        RegisterFrameForEvents(f, { E.PLAYER_ENTERING_WORLD })
    end

    --- @param eventFrame MainControllerFrame
    --- @return MainEventContext
    function o:CreateEventContext(eventFrame)
        --- @class MainEventContext
        --- @field frame MainControllerFrame
        --- @field addon AddonTemplate
        local ctx = {
            frame = eventFrame,
            addon = self.addon,
        }
        return ctx
    end

    --- @return MainControllerFrame
    function o:CreateEventFrame()
        --- @class MainControllerFrame : _Frame
        --- @field ctx MainEventContext
        local f = CreateFrame("Frame", nil, self.addon.frame)
        f.ctx = self:CreateEventContext(f)
        return f
    end
end

InstanceMethods(L)
