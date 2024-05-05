--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local M = ns.M

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.API()
--- @class API
local L = ns:NewLib(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o API
local function PropsAndMethods(o)

    function o:GetUIScale()
        -- This returns "1" if UI scaling is enabled, "0" otherwise.
        local useUiScale = GetCVar('useUiScale')
        if useUiScale == "1" then
            local uiScale = GetCVar('uiScale')
            return tonumber(uiScale)
        else
            -- UI scaling is not enabled, so scale is effectively 1.
            return 1
        end
    end

    function o:GetCurrentPlayer() return UnitName('player') end

end; PropsAndMethods(L)

