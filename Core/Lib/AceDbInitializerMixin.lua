--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local GC, M = ns.GC, ns.M
local AceDB = ns:AceDB()


--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.AceDbInitializerMixin()
--- @class AceDbInitializerMixin
local L = ns:NewLib(libName)
local p = ns:LC().DB:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param a AddonTemplate
local function AddonCallbackMethods(a)
    function a:OnProfileChanged()
        p:f3('OnProfileChanged called...')
    end
    function a:OnProfileChanged()
        p:f3('OnProfileReset called...')
    end
    function a:OnProfileChanged()
        p:f3('OnProfileCopied called...')
    end
end

--- @param o AceDbInitializerMixin
local function PropsAndMethods(o)

    --- Called by CreateAndInitFromMixin(..) Automatically
    --- @param addon AddonTemplate
    function o:Init(addon)
        self.addon = addon
        --- @type AddOn_DB
        local db = AceDB:New(GC().C.DB_NAME)
        ns:SetAddOnFn(function() return db end)
    end

    --- Usage:  local instance = AceDbInitializerMixin:New(addon)
    --- @param addon AddonTemplate
    --- @return AceDbInitializerMixin
    function o:New(addon) return ns:K():CreateAndInitFromMixinWithDefExc(o, addon) end

    function o:InitDb()
        AddonCallbackMethods(self.addon)
        ns:db().RegisterCallback(self.addon, "OnProfileChanged", "OnProfileChanged")
        ns:db().RegisterCallback(self.addon, "OnProfileReset", "OnProfileChanged")
        ns:db().RegisterCallback(self.addon, "OnProfileCopied", "OnProfileChanged")
        ns:db():RegisterDefaults(ns.DefaultAddOnDatabase())
        p:i(function() return 'Profile: %s', ns:db():GetCurrentProfile() end)
    end

end; PropsAndMethods(L)

