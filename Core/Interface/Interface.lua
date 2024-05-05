--[[-----------------------------------------------------------------------------
BaseLibraryObject
-------------------------------------------------------------------------------]]
--- @class BaseLibraryObject A base library object class definition.
--- @field mt table The metatable for objects of this class, including a custom `__tostring` function for debugging or logging purposes.
--- @field name string Retrieves the module's name. This is an instance method that should be implemented to return the name of the module.
--- @field major string Retrieves the major version of the module. i.e., <LibName>-1.0
--- @field minor string Retrieves the minor version of the module. i.e., <LibName>-1.0

--[[-----------------------------------------------------------------------------
BaseLibraryObject_WithAceEvent
-------------------------------------------------------------------------------]]
--- @class BaseLibraryObject_WithAceEvent : AceEvent A base library object that includes AceEvent functionality.
--- @field mt table The metatable for objects of this class, including a custom `__tostring` function for debugging or logging purposes.
--- @field name string Retrieves the module's name. This is an instance method that should be implemented to return the name of the module.
--- @field major string Retrieves the major version of the module. i.e., <LibName>-1.0
--- @field minor string Retrieves the minor version of the module. i.e., <LibName>-1.0
