--
-- lua-Coat : <http://lua-coat.luaforge.net/>
--

require 'Coat'

local ipairs = ipairs
local setmetatable = setmetatable
local pairs = pairs
local _G = _G
local table = table

local checktype = Coat.checktype

module 'Coat.Types'

_TC = {}
_COERCE = {}

function subtype (name, t)
    checktype('subtype', 1, name, 'string')
    checktype('subtype', 2, t, 'table')
    local parent = t.as
    checktype('subtype', 2, parent, 'string')
    local validator = t.where
    checktype('subtype', 3, validator, 'function')
    local message = t.message
    checktype('subtype', 4, message or '', 'string')
    if _TC[name] then
        error("Duplicate definition of type " .. name)
    end
    _TC[name] = {
        parent = parent,
        validator = validator,
        message = message,
    }
end
_G.subtype = setmetatable({}, { __newindex = function (t, k, v) subtype(k, v) end })

function enum (name, t)
    checktype('enum', 1, name, 'string')
    checktype('enum', 2, t, 'table')
    if _TC[name] then
        error("Duplicate definition of type " .. name)
    end
    if #t < 1 then
        error "You must have at least two values to enumerate through"
    end
    local hash = {}
    for i, v in ipairs(t) do
        checktype('enum', 1+i, v, 'string')
        hash[v] = true
    end
    _TC[name] = {
        parent = 'string',
        validator = function (val)
                        return hash[val]
                    end,
    }
end
_G.enum = setmetatable({}, { __newindex = function (t, k, v) enum(k, v) end })

function coerce (name, t)
    checktype('coerce', 1, name, 'string')
    checktype('coerce', 2, t, 'table')
    if not _COERCE[name] then
        _COERCE[name] = {}
    end
    for from, via in pairs(t) do
        checktype('coerce', 2, from, 'string')
        checktype('coerce', 2, via, 'function')
        _COERCE[name][from] = via
    end
end
_G.coerce = setmetatable({}, { __newindex = function (t, k, v) coerce(k, v) end })

--
-- Copyright (c) 2009 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
