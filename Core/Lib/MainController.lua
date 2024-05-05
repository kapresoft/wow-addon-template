--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local CreateFrame, FrameUtil = CreateFrame, FrameUtil
local RegisterFrameForEvents, RegisterFrameForUnitEvents = FrameUtil.RegisterFrameForEvents, FrameUtil.RegisterFrameForUnitEvents

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC(), ns.M
local E, MSG = GC.E, GC.M

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.MainController()
--- @class MainController : BaseLibraryObject_WithAceEvent
local L = ns:NewLibWithEvent(libName)
local p = ns:LC().DEFAULT:NewLogger(libName)
local pp = ns:CreateDefaultLogger(ns.addon)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]

--- Other modules can listen to message
--- ```Usage:
--- AceEvent:RegisterMessage(MSG.OnAddonReady, function(evt, ...) end
--- ```
--- @param addon AddonTemplate
local function SendAddonReadyMessage(addon) L:SendMessage(MSG.OnAddonReady, addon) end

--- @param f MainControllerFrame
---@param event EventName
local function OnPlayerEnteringWorld(f, event, ...)
    local isLogin, isReload = ...
    local addon = f.ctx.addon

    SendAddonReadyMessage(addon)
    --@do-not-package@
    isLogin = true
    --@end-do-not-package@
    if not isLogin then return end

    pp:a(GC:GetMessageLoadedText())
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o MainController | AceEventInterface
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
        p:f3('RegisterEvents() called...')
        self:RegisterOnPlayerEnteringWorld()
        self:RegisterMessage(MSG.OnAddonReady, function() self:OnAddonReady()  end)
    end

    --- @private
    function L:OnAddonReady()
        -- add handlers when needed here
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
