--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local ns = adt_ns(...)
local O, GC, M, LibStub, KO = ns.O, ns.GC, ns.M, ns.LibStub, ns:KO()
local AceDB = O.AceLibrary.AceDB
local IsEmptyTable = KO.Table.isEmpty

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class AceDbInitializerMixin : BaseLibraryObject
local L = LibStub:NewLibrary(M.AceDbInitializerMixin)
local p = ns:LC().DB:NewLogger(M.AceDbInitializerMixin)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param a AddonTemplate
local function AddonCallbackMethods(a)
    function a:OnProfileChanged()
        p:vv('OnProfileChanged called...')
    end
    function a:OnProfileChanged()
        p:vv('OnProfileReset called...')
    end
    function a:OnProfileChanged()
        p:vv('OnProfileCopied called...')
    end
end

--- @param o AceDbInitializerMixin
local function PropsAndMethods(o)

    --- Called by CreateAndInitFromMixin(..) Automatically
    --- @param addon AddonTemplate
    function o:Init(addon)
        self.addon = addon
        self.addon.db = AceDB:New(GC.C.DB_NAME)
        self.addon.dbInit = self
        self.db = self.addon.db
        ns:SetAddOnDB(self.db)
    end

    --- Usage:  local instance = AceDbInitializerMixin:New(addon)
    --- @param addon AddonTemplate
    --- @return AceDbInitializerMixin
    function o:New(addon) return ns:K():CreateAndInitFromMixin(o, addon) end

    --- @return AceDB
    function o:GetDB() return self.addon.db end

    function o:InitDb()
        p:f1( 'Initialize called...')
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
        p:i(function() return 'Profile: %s', self.db:GetCurrentProfile() end)
    end
end; PropsAndMethods(L)

