--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer
local L = {}
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o Developer
local function PropsAndMethods(o)

    --- /run DEV_ADS:Info()
    function o:Info()
        return print(ns.GC():GetAddonInfoFormatted())
    end
    -- /run DEV_ADS:dump('ADT')
    ---@param arg string
    function o:dump(arg)
        ns.dump(arg)
    end

end; PropsAndMethods(L); DEV_ADS = L

