--[[-----------------------------------------------------------------------------
Type: CoreNamespace
-------------------------------------------------------------------------------]]
--[[--- @class CoreNamespace : Kapresoft_Base_Namespace
--- @field gameVersion GameVersion]]

--[[-----------------------------------------------------------------------------
Type: CoreNamespace
-------------------------------------------------------------------------------]]
--- @type string
local addon
--- @type CoreNamespace | Kapresoft_LibUtil_NamespaceAceLibraryMixin
local ns
addon, ns = ...; ns.addon = addon

--- @deprecated Deprecated. Use ns.addon
ns.name = addon
ns.addonShortName = 'adt'
ns.addonLogName   = string.upper(ns.addonShortName)

local K = ns.Kapresoft_LibUtil

--- @type Kapresoft_LibUtil_ColorDefinition
ns.consoleColors = {
    primary   = 'FF780A',
    secondary = 'fbeb2d',
    tertiary = 'ffffff',
}

--- @class ColorFormatters
local colorFormatters = {
    --- Use this for values
    val = K:cf(LIGHTGRAY_FONT_COLOR)
}; ns.f = function() return colorFormatters end

K:MixinWithDefExc(ns, K.Objects.CoreNamespaceMixin, K.Objects.NamespaceAceLibraryMixin)
--- The "name" field conflicts with K.Objects. We need to restore it here
--- ns.name is deprecated
ns.name = ns.addon

--[[-----------------------------------------------------------------------------
Namespace Methods
-------------------------------------------------------------------------------]]
--- @return boolean
function ns:IsDev() return ns.debug:IsDeveloper() end

--[[-----------------------------------------------------------------------------
Type: DebugSettingsFlag
-------------------------------------------------------------------------------]]
--- @class DebugSettingsFlag
--- @see GlobalDeveloper
local flag = {
    --- Enable developer mode: logging and debug tab settings
    developer = false,
}

--- @return DebugSettings
local function debug()
    --- @class DebugSettings
    local o = {
        flag = flag,
    }
    --- @return boolean
    function o:IsDeveloper() return self.flag.developer == true  end
    return o;
end

ns.debug = debug()
