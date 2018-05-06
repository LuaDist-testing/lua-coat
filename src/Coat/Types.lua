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
local does = Coat.does
local isa = Coat.isa

module 'Coat.Types'

local _TC = {}
local _COERCE = {}

function find_type_constraint (name)
    local tc = _TC[name]
    if tc then
        return tc
    end
    local capt = name:match'^table(%b<>)$'
    if capt then
        local function check_type (val, tname)
            local tc = find_type_constraint(tname)
            if tc then
                return check_type(val, tc.parent) and tc.validator(val)
            else
                return isa(val, tname) or does(val, tname)
            end
        end -- check_type

        tc = { parent = 'table' }
        local typev = capt:sub(2, capt:len()-1)
        local idx = typev:find','
        if idx then
            local typek = typev:sub(1, idx-1)
            typev = typev:sub(idx+1)
            tc.validator = function (val)
                            for k, v in pairs(val) do
                                if not check_type(k, typek) then
                                    return false
                                end
                                if not check_type(v, typev) then
                                    return false
                                end
                            end
                            return true
                        end
        else
            tc.validator = function (val)
                            for _, v in ipairs(val) do
                                if not check_type(v, typev) then
                                    return false
                                end
                            end
                            return true
                        end
        end
        _TC[name] = tc
    end
    return tc
end

function coercion_map (name)
    return _COERCE[name]
end

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
-- Copyright (c) 2009-2010 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
