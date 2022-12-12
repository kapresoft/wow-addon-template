local ns = SDNR_Namespace(...)
local O, LibStub, M = ns:LibPack()
local GC = O.GlobalConstants

---@class Wrapper
local L = LibStub:NewLibrary(M.Wrapper)
local p = L.logger

p:log('Loaded: %s msg: %s', M.Wrapper, 'Hello')