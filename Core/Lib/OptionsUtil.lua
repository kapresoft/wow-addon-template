--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, LibStub = ns.O, ns.O.GlobalConstants, ns.M, ns.LibStub

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.OptionsUtil or 'OptionsUtil'
--- @return OptionsUtil, Kapresoft_CategoryLogger
local function CreateLib()
    --- @class OptionsUtil : BaseLibraryObject_WithAceEvent
    --- @field optionsMixin OptionsMixin
    local newLib = LibStub:NewLibrary(libName); if not newLib then return nil end
    ns:AceEvent(newLib)
    local logger = ns:CreateDefaultLogger(libName)
    return newLib, logger
end; local L, p = CreateLib(); if not L then return end
p:v(function() return "Loaded: %s", L.name or tostring(L) end)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o OptionsUtil
local function PropsAndMethods(o)

    --- @public
    --- @param optionsMixin OptionsMixin
    --- @return OptionsUtil
    function o:New(optionsMixin) return ns:K():CreateAndInitFromMixin(o, optionsMixin) end

    --- Called Automatically by CreateAndInitFromMixin
    --- @private
    --- @param optionsMixin OptionsMixin
    function o:Init(optionsMixin)
        self.optionsMixin = optionsMixin
    end

    --- @see GlobalConstants#M for Message names
    --- @param optionalVal any|nil
    function o:SendEventMessage(addOnMessage, optionalVal)
        self:SendMessage(addOnMessage, libName, optionalVal)
    end

    --- @param propKey string
    --- @param defVal any
    function o:GetGlobalValue(propKey, defVal) return ns:db().global[propKey] or defVal end

    --- @param propKey string
    --- @param val any
    function o:SetGlobalValue(propKey, val) ns:db().global[propKey] = val end

    --- @param propKey string
    --- @param defVal any
    function o:GetValue(propKey, defVal) return ns:db().profile[propKey] or defVal end

    --- @param propKey string
    --- @param val any
    function o:SetValue(propKey, val) ns:db().profile[propKey] = val end

    --- @param fallback any The fallback value
    --- @param key string The key value
    function o:ProfileGet(key, fallback)
        return function(_)
            return self:GetValue(key, fallback)
        end
    end
    --- @param key string The key value
    function o:ProfileSet(key, eventMessageToFire)
        return function(_, v)
            self:SetValue(key, v)
            if 'string' == type(eventMessageToFire) then
                self:SendEventMessage(eventMessageToFire, v)
            end
        end
    end
    --- @param fallback any The fallback value
    --- @param key string The key value
    function o:GlobalGet(key, fallback)
        return function(_)
            return self:GetGlobalValue(key, fallback)
        end
    end
    --- @param key string The key value
    function o:GlobalSet(key, eventMessageToFire)
        return function(_, v)
            self:SetGlobalValue(key, v)
            if 'string' == type(eventMessageToFire) then
                self:SendEventMessage(eventMessageToFire, v)
            end
        end
    end

end; PropsAndMethods(L)

