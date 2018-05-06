
--
-- lua-Coat : <http://fperrad.github.com/lua-Coat/>
--

module 'Coat.Meta.Role'

local _roles = {}
function roles ()
    return _roles
end

function role (name)
    return _roles[name]
end

function attributes (role)
    local i = 0
    return  function ()
                local v
                repeat
                    i = i + 1
                    v = role._STORE[i]
                    if not v then return nil end
                until v[1] == 'has'
                return v[2], v[3]
            end
end

function methods (role)
    local i = 0
    return  function ()
                local v
                repeat
                    i = i + 1
                    v = role._STORE[i]
                    if not v then return nil end
                until v[1] == 'method'
                return v[2], v[3]
            end
end

--
-- Copyright (c) 2009-2010 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
