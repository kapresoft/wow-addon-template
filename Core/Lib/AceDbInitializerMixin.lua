--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local _, ns = ...
local O, LibStub, M, KO = ns.O, ns.LibStub, ns.M, ns:KO()
local GC, AceDB = O.GlobalConstants, O.AceLibrary.AceDB
local IsEmptyTable = KO.Table.isEmpty

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class AceDbInitializerMixin : BaseLibraryObject
local L = LibStub:NewLibrary(M.AceDbInitializerMixin)
local p = L.logger;

--- Called by Mixin Automatically
--- @param addon AddonTemplate
function L:Init(addon)
    self.addon = addon
    self.addon.db = AceDB:New(GC.C.DB_NAME)
    self.addon.dbInit = self
    self.db = self.addon.db
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param a AddonTemplate
local function AddonCallbackMethods(a)
    function a:OnProfileChanged()
        p:log('OnProfileChanged called...')
    end
    function a:OnProfileChanged()
        p:log('OnProfileReset called...')
    end
    function a:OnProfileChanged()
        p:log('OnProfileCopied called...')
    end
end

--- @param o AceDbInitializerMixin
local function Methods(o)

    --- Usage:  local instance = AceDbInitializerMixin:New(addon)
    --- @param addon AddonTemplate
    --- @return AceDbInitializerMixin
    function o:New(addon) return ns:K():CreateAndInitFromMixin(o, addon) end

    --- @return AceDB
    function o:GetDB() return self.addon.db end

    function o:InitDb()
        p:log(100, 'Initialize called...')
        AddonCallbackMethods(self.addon)
        self.db.RegisterCallback(self.addon, "OnProfileChanged", "OnProfileChanged")
        self.db.RegisterCallback(self.addon, "OnProfileReset", "OnProfileChanged")
        self.db.RegisterCallback(self.addon, "OnProfileCopied", "OnProfileChanged")
        self:InitDbDefaults()
    end

    function o:InitDbDefaults()
        local profileName = self.addon.db:GetCurrentProfile()
        local defaultProfile = { hello = 'there'}
        local defaults = { profile = defaultProfile }
        self.db:RegisterDefaults(defaults)
        self.addon.profile = self.db.profile
        local wowDB = _G[GC.C.DB_NAME]
        if IsEmptyTable(wowDB.profiles[profileName]) then wowDB.profiles[profileName] = defaultProfile end
        self.addon.profile.enable = true
        p:log(1, 'Profile: %s', self.db:GetCurrentProfile())
    end
end

Methods(L)

