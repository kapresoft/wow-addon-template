local ns = ADT_Namespace(...)
--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local O, LibStub, M = ns:LibPack()

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]


--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
---@class Core
local L = LibStub:NewLibrary(M.Core, 1)
local p = L.logger

p:log("Loaded: %s", 'Core')

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]

