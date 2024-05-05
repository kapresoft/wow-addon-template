--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type CoreNamespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
Debug Flags
-------------------------------------------------------------------------------]]
ns.debug.flag.developer = true

--[[-----------------------------------------------------------------------------
Debugger Vars
--- @see Interface/SharedXML/Dump.lua
-------------------------------------------------------------------------------]]

--DEVTOOLS_MAX_ENTRY_CUTOFF = 100    -- Maximum table entries shown (default: 30)
--DEVTOOLS_LONG_STRING_CUTOFF = 200; -- Maximum string size shown
--DEVTOOLS_DEPTH_CUTOFF = 3;        -- Maximum table depth (default: 10)
--DEVTOOLS_USE_TABLE_CACHE = true;   -- Look up table names
--DEVTOOLS_USE_FUNCTION_CACHE = true;-- Look up function names
--DEVTOOLS_USE_USERDATA_CACHE = true;-- Look up userdata names
--DEVTOOLS_INDENT='  ';              -- Indentation string
