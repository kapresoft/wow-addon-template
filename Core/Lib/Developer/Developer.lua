--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local libName = 'Developer'
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class Developer
local L = {}
local p = ns:CreateDefaultLogger(libName)
p:v(function() return "Loaded: %s", libName end)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o Developer
local function PropsAndMethods(o)

    --- /run DEV_ADS:Info()
    function o:Info()
        return print(ns.GC:GetAddonInfoFormatted())
    end

end; PropsAndMethods(L); DEV_ADS = L
