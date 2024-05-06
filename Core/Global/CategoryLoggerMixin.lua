--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'CategoryLoggerMixin'
--- @class CategoryLoggerMixin
--- @field LogCategories LogCategories
local L = {}
local logp = ns.LogFunctions.logp(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param val EnabledInt|boolean|nil
--- @param key string|nil Category name
--- @return table<string, string>
local function __GetCategories(key, val)
    if key then ADT_DEBUG_ENABLED_CATEGORIES[key] = val end
    return ADT_DEBUG_ENABLED_CATEGORIES or {}
end

--- @param key string The category key
--- @return Enabled
local function __IsEnabledCategory(key)
    ADT_DEBUG_ENABLED_CATEGORIES = ADT_DEBUG_ENABLED_CATEGORIES or {}
    return ADT_DEBUG_ENABLED_CATEGORIES[key]
end

--- @param val number|nil Optional log level to set
--- @return number The new log level passed back
local function __GetLogLevel(val)
    if val then ADT_LOG_LEVEL = val end
    return ADT_LOG_LEVEL or 0
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o CategoryLoggerMixin
local function PropsAndMethods(o)

    --- @param namesp Namespace
    --- @param logCategories LogCategories
    function o:Configure(namesp, logCategories)
        assert(logCategories, 'CategoryLoggerMixin:Mixin(): LogCategories is required.')
        namesp.LogCategories = function() return logCategories end
        local CategoryLogger = namesp:KO().CategoryMixin:New()
        CategoryLogger:Configure(namesp.addonLogName, logCategories, {
            consoleColors = namesp.GC().C.CONSOLE_COLORS,
            levelSupplierFn = function() return __GetLogLevel() end,
            enabledCategoriesSupplierFn = function() return __GetCategories() end,
            printerFn = ns.print,
            enabled = namesp.debug:IsDeveloper(),
        })
        namesp.CategoryLogger = function() return CategoryLogger end
        namesp:K():Mixin(namesp, o)
        namesp.Configure = nil
    end

    --- @return number
    function o:GetLogLevel() return __GetLogLevel() end
    --- @param level number
    function o:SetLogLevel(level) __GetLogLevel(level) end

    --- @param name string | "'ADDON'" | "'BAG'" | "'BUTTON'" | "'DRAG_AND_DROP'" | "'EVENT'" | "'FRAME'" | "'ITEM'" | "'MESSAGE'" | "'MOUNT'" | "'PET'" | "'PROFILE'" | "'SPELL'"
    --- @param v boolean|number | "1" | "0" | "true" | "false"
    function o:SetLogCategory(name, val)
        assert(name, 'Debug category name is missing.')
        ---@param v boolean|nil
        local function normalizeVal(v) if v == 1 or v == true then return 1 end; return 0 end
        __GetCategories(name, normalizeVal(val))
    end
    --- @return boolean
    function o:IsLogCategoryEnabled(name)
        assert(name, 'Debug category name is missing.')
        local val = __IsEnabledCategory(name)
        return val == 1 or val == true
    end
    function o:LC() return self.LogCategories() end
    function o:CreateDefaultLogger(moduleName) return self:LC().DEFAULT:NewLogger(moduleName) end

end; PropsAndMethods(L)
ns.CategoryLoggerMixin = L
