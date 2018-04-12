
--
-- lua-Coat : <http://lua-coat.luaforge.net/>
--

module 'Coat.Meta'

function has (class, name)
    return class._ATTR[name]
end

local _classes = {}
function classes ()
    return _classes
end

function class (name)
    return _classes[name]
end

local _roles = {}
function roles ()
    return _roles
end

function role (name)
    return _roles[name]
end

--
-- Copyright (c) 2009 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
