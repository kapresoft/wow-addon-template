--[[-----------------------------------------------------------------------------
Localization: Place this at the end of the locale list
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local addonName = ns.addon
local L         = LibStub("AceLocale-3.0"):GetLocale(addonName)
local c1        = ns:K():cf(LIGHTBLUE_FONT_COLOR)

-- General
ADT_TITLE                          = addonName
ADT_TITLE_SUFFIX_KEYB              = ns.sformat(c1(' (%s)'), addonName)
ADT_CATEGORY                       = "AddOns/" .. ADT_TITLE

-- Key binding localization text
BINDING_HEADER_ADT_OPTIONS         = ADT_TITLE
BINDING_NAME_ADT_OPTIONS_DLG       = L["BINDING_NAME_ADT_OPTIONS_DLG"] .. ADT_TITLE_SUFFIX_KEYB
BINDING_NAME_ADT_OPTIONS_DEBUG_DLG = L["BINDING_NAME_ADT_OPTIONS_DEBUG_DLG"] .. ADT_TITLE_SUFFIX_KEYB

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @class LocaleUtil
local LocaleUtil = {}; ns.LocaleUtil = LocaleUtil; do

    local o = LocaleUtil
    local globalSetting = c1('(' .. L['Global Setting'] .. ')')
    local charSetting = c1('(' .. L['Character Setting'] .. ')')

    --- @param localeKey string
    function o.G(localeKey)
        return ns.sformat('%s\n%s', L[localeKey], globalSetting)
    end

    --- @param localeKey string
    function o.C(localeKey)
        return ns.sformat('%s\n%s', L[localeKey], charSetting)
    end

    --- @param opt AceConfigOption
    --- @param name string
    function o.NameDescGlobal(opt, name)
        opt.name = L[name]
        opt.desc = o.G(name .. '::Desc')
    end

    --- @param opt AceConfigOption
    --- @param name string
    function o.NameDescCharacter(opt, name)
        opt.name = L[name]
        opt.desc = o.C(name .. '::Desc')
    end

end
