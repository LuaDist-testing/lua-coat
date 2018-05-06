
--
-- lua-Coat : <http://lua-coat.luaforge.net/>
--

local error = error
local getmetatable = getmetatable
local ipairs = ipairs
local pairs = pairs
local pcall = pcall
local rawget = rawget
local require = require
local setfenv = setfenv
local setmetatable = setmetatable
local type = type
local _G = _G
local package = package
local table = table

module 'Coat'

local Meta = require 'Coat.Meta'

basic_type = type
local basic_type = basic_type
local function object_type (obj)
    local t = basic_type(obj)
    if t == 'table' then
        pcall(function () t = obj._CLASS or t end)
    end
    return t
end
_G.type = object_type

local function argerror (caller, narg, extramsg)
    error("bad argument #" .. tostring(narg) .. " to "
          .. caller .. " (" .. extramsg .. ")")
end

local function typerror (caller, narg, arg, tname)
    argerror(caller, narg, tname .. " expected, got " .. object_type(arg))
end

function checktype (caller, narg, arg, tname)
    if basic_type(arg) ~= tname then
        typerror(caller, narg, arg, tname)
    end
end
local checktype = checktype

function findtable (fname)
    local i = 1
    local t = _G
    for w in fname:gmatch "(%w+)%." do
        i = i + w:len() + 1
        t[w] = t[w] or {}
        t = t[w]
    end
    local name = fname:sub(i)
    t[name] = t[name] or {}
    return t[name]
end

function can (obj, name)
    checktype('can', 2, name, 'string')
    return basic_type(obj[name]) == 'function'
end

function isa (obj, t)
    if basic_type(t) == 'table' and t._NAME then
        t = t._NAME
    end
    if basic_type(t) ~= 'string' then
        argerror('isa', 2, "string or Object/Class expected")
    end

    local function walk (types)
        for _, v in ipairs(types) do
            if v == t then
                return true
            elseif basic_type(v) == 'table' then
                local result = walk(v)
                if result then
                    return result
                end
            end
        end
        return false
    end -- walk

    if basic_type(obj) == 'table' and obj._ISA then
        return walk(obj._ISA)
    else
        return basic_type(obj) == t
    end
end

function does (obj, r)
    if basic_type(r) == 'table' and r._NAME then
        r = r._NAME
    end
    if basic_type(r) ~= 'string' then
        argerror('does', 2, "string or Role expected")
    end

    local function walk (roles)
        for _, v in ipairs(roles) do
            if v == r then
                return true
            elseif basic_type(v) == 'table' then
                local result = walk(v)
                if result then
                    return result
                end
            end
        end
        return false
    end -- walk

    if basic_type(obj) == 'table' and obj._DOES then
        return walk(obj._DOES)
    else
        return false
    end
end

function new (class, args)
    args = args or {}
    local obj = {
        _CLASS = class._NAME,
        _VALUES = {}
    }
    setmetatable(obj, {})

    for _, r in ipairs(class._ROLE) do -- check roles
        for _, v in ipairs(r._EXCL) do
            if class:does(v) then
                error("Role " .. r._NAME .. " excludes role " .. v)
            end
        end
        for _, v in ipairs(r._REQ) do
            if not class[v] then
                error("Role " .. r._NAME .. " requires method " .. v)
            end
        end
    end

    class._INIT(obj, args)
    if class.BUILD then
        class.BUILD(obj, args)
    end
    return obj
end

function __gc (class, obj)
    if class.DEMOLISH then
        class.DEMOLISH(obj)
    end
end

local function attr_default (options, obj)
    local builder = options.builder
    if builder then
        local func = obj[builder]
        if not func then
            error("method " .. builder .. " not found")
        end
        return func(obj)
    else
        local default = options.default
        if basic_type(default) == 'function' then
            return default(obj)
        else
            return default
        end
    end
end

local function validate (name, options, val)
    if val == nil then
        if options.required and not options.lazy then
            error("Attribute '" .. name .. "' is required")
        end
    else
        if options.isa then
            if options.coerce then
                local mapping = Types and Types._COERCE[options.isa]
                if not mapping then
                    error("Coercion is not available for type " .. options.isa)
                end
                local coerce = mapping[object_type(val)]
                if coerce then
                    val = coerce(val)
                end
            end

            local function check_isa (tname)
                local tc = Types and Types._TC[tname]
                if tc then
                    check_isa(tc.parent)
                    if not tc.validator(val) then
                        local msg = tc.message
                        if msg == nil then
                            error("Value for attribute '" .. name
                                  .. "' does not validate type constraint '"
                                  .. tname .. "'")
                        else
                            error(string.format(msg, val))
                        end
                    end
                else
                    if not isa(val, tname) then
                        error("Invalid type for attribute '" .. name
                              .. "' (got " .. object_type(val)
                              .. ", expected " .. tname ..")")
                    end
                end
            end -- check_isa

            check_isa(options.isa)
        end

        if options.does then
            local role = options.does
            if not does(val, role) then
                error("Value for attribute '" .. name
                      .. "' does not consume role '" .. role .. "'")
            end
        end
    end
    return val
end

function _INIT (class, obj, args)
    for k, opts in pairs(class._ATTR) do
        if obj._VALUES[k] == nil then
            local val = args[k]
            if val ~= nil then
                if basic_type(val) == 'function' then
                    val = val(obj)
                end
            elseif not opts.lazy then
                val = attr_default(opts, obj)
            end
            val = validate(k, opts, val)
            obj._VALUES[k] = val
        end
    end

    local m = getmetatable(obj)
    for k, v in pairs(class._MT) do
        if not m[k] then
            m[k] = v
        end
    end

    for _, p in ipairs(class._PARENT) do
        p._INIT(obj, args)
    end
end

function has (class, name, options)
    checktype('has', 1, name, 'string')
    options = options or {}
    checktype('has', 2, options, 'table')

    if options[1] == '+' then
        inherited = class._ATTR[name]
        if inherited == nil then
            error("Cannot overload unknown attribute " .. name)
        end
        local t = {}
        for k, v in pairs(inherited) do
            t[k] = v
        end
        for k, v in pairs(options) do
            t[k] = v
        end
        options = t
    elseif class._ATTR[name] ~= nil then
        error("Duplicate definition of attribute " .. name)
    end

    if options.lazy_build then
        options.lazy = true
        options.builder = '_build_' .. name
        if name:sub(1, 1) == '_' then
            options.clearer = '_clear' .. name
        else
            options.clearer = 'clear_' .. name
        end
    end
    if options.trigger and basic_type(options.trigger) ~= 'function' then
        error "The trigger option requires a function"
    end
    if options.default and options.builder then
        error "The options default and builder are not compatible"
    end
    if options.lazy and options.default == nil and options.builder == nil then
        error "The lazy option implies the builder or default option"
    end
    if options.builder and basic_type(options.builder) ~= 'string' then
        error "The builder option requires a string (method name)"
    end
    class._ATTR[name] = options

    if options.is then
        class[name] = function (obj, val)
            if val ~= nil then
                -- setter
                if options.is == 'ro' then
                    error("Cannot set a read-only attribute ("
                          .. name .. ")")
                else
                    val = validate(name, options, val)
                    obj._VALUES[name] = val
                    local trigger = options.trigger
                    if trigger then
                        trigger(obj, val)
                    end
                    return val
                end
            end
            -- getter
            if options.lazy and obj._VALUES[name] == nil then
                local val = attr_default(options, obj)
                val = validate(name, options, val)
                obj._VALUES[name] = val
            end
            return obj._VALUES[name]
        end
    end

    if options.reader then
        class[options.reader] = function (obj)
            if options.lazy and obj._VALUES[name] == nil then
                local val = attr_default(options, obj)
                val = validate(name, options, val)
                obj._VALUES[name] = val
                end
            return obj._VALUES[name]
        end
    end

    if options.writer then
        class[options.writer] = function (obj, val)
            val = validate(name, options, val)
            obj._VALUES[name] = val
            local trigger = options.trigger
            if trigger then
                trigger(obj, val)
            end
            return val
        end
    end

    if options.handles then
        for k, v in pairs(options.handles) do
            class[k] = function (obj, ...)
                local attr = obj._VALUES[name]
                local func = attr[v]
                if func == nil then
                    error("Cannot delegate " .. k .. " from "
                          .. name .. " (" .. v .. ")")
                end
                return func(attr, ...)
            end
        end
    end

    if options.clearer then
        if options.required then
            error "The clearer option is incompatible with required option"
        end
        if basic_type(options.clearer) ~= 'string' then
            error "The clearer option requires a string"
        end
        class[options.clearer] = function (obj)
            obj._VALUES[name] = nil
            local trigger = options.trigger
            if trigger then
                trigger(obj, nil)
            end
        end
    end
end

function method (class, name, func)
    checktype('method', 1, name, 'string')
    checktype('method', 2, func, 'function')
    if class[name] then
        error("Duplicate definition of method " .. name)
    end
    class[name] = func
end

function overload (class, name, func)
    checktype('overload', 1, name, 'string')
    checktype('overload', 2, func, 'function')
    class._MT[name] = func
end

function override (class, name, func)
    checktype('override', 1, name, 'string')
    checktype('override', 2, func, 'function')
    if not class[name] then
        error("Cannot override non-existent method "
              .. name .. " in class " .. class._NAME)
    end
    class[name] = func
end

function before (class, name, func)
    checktype('before', 1, name, 'string')
    checktype('before', 2, func, 'function')
    local super = class[name]
    if not super then
        error("Cannot before non-existent method "
              .. name .. " in class " .. class._NAME)
    end

    class[name] = function (...)
        local result = func(...)
        super(...)
        return result
    end
end

function around (class, name, func)
    checktype('around', 1, name, 'string')
    checktype('around', 2, func, 'function')
    local super = class[name]
    if not super then
        error("Cannot around non-existent method "
              .. name .. " in class " .. class._NAME)
    end

    class[name] = function (obj, ...)
        return func(obj, super,  ...)
    end
end

function after (class, name, func)
    checktype('after', 1, name, 'string')
    checktype('after', 2, func, 'function')
    local super = class[name]
    if not super then
        error("Cannot after non-existent method "
              .. name .. " in class " .. class._NAME)
    end

    class[name] = function (...)
        super(...)
        return func(...)
    end
end

function extends(class, ...)
    for i, v in ipairs{...} do
        local parent
        if basic_type(v) == 'string' then
            parent = require(v)
        elseif v._NAME then
            parent = v
        end
        if not parent or not parent._INIT then
            argerror('extends', i, "string or Class expected")
        end

        if parent:isa(class) then
            error("Circular class structure between '"
                  .. class._NAME .."' and '" .. parent._NAME .. "'")
        end

        table.insert(class._PARENT, parent)
        table.insert(class._ISA, parent._ISA)
        table.insert(class._DOES, parent._DOES)
        for _, r in ipairs(parent._ROLE) do
            table.insert(class._ROLE, r)
        end
    end

    local t = getmetatable(class)
    t.__index = function (t, k)
                    local function search ()
                        for _, p in ipairs(class._PARENT) do
                            local v = p[k]
                            if v then
                                return v
                            end
                        end
                    end -- search

                    local v = rawget(t, k) or search()
                    t[k] = v      -- save for next access
                    return v
                end
    local a = getmetatable(class._ATTR)
    a.__index = function (t, k)
                    local function search ()
                        for _, p in ipairs(class._PARENT) do
                            local v = p._ATTR[k]
                            if v then
                                return v
                            end
                        end
                    end -- search

                    local v = rawget(t, k) or search()
                    t[k] = v      -- save for next access
                    return v
                end
end

function with (class, ...)
    local role
    for i, v in ipairs{...} do
        if role and basic_type(v) == 'table' then
            if v.alias then
                local alias = v.alias
                if basic_type(alias) ~= 'table' then
                    argerror('with-alias', i, "table expected")
                end
                for old, new in pairs(alias) do
                    if basic_type(old) ~= 'string' then
                        argerror('with-alias', i, "string expected")
                    end
                    if basic_type(new) ~= 'string' then
                        argerror('with-alias', i, "string expected")
                    end
                    class[new] = class[old]
                end
            end
            if v.excludes then
                local excludes = v.excludes
                if basic_type(excludes) == 'string' then
                    excludes = { excludes }
                end
                for i, name in ipairs(excludes) do
                    if basic_type(name) ~= 'string' then
                        argerror('with-excludes', i, "string expected")
                    end
                    class[name] = nil
                end
            end
            role = nil
        else
            if basic_type(v) == 'string' then
                role = require(v)
            elseif v._NAME then
                role = v
            end
            if not role or role._INIT then
                argerror('with', i, "string or Role expected")
            end

            table.insert(class._DOES, role._NAME)
            table.insert(class._ROLE, role)
            for _, v in ipairs(role._STORE) do
                _G.Coat[v[1]](class, v[2], v[3])
            end
        end
    end
end

function _G.class (modname)
    checktype('class', 1, modname, 'string')
    if basic_type(package.loaded[modname]) == 'table' then
        error("name conflict for module '" .. modname .. "'")
    end

    local M = findtable(modname)
    package.loaded[modname] = M
    setmetatable(M, {
        __index = _G,
        __call  = function (t, ...)
                      return t.new(...)
                  end,
    })
    setfenv(2, M)
    M._NAME = modname
    M._M = M
    M._ISA = { modname }
    M._PARENT = {}
    M._DOES = {}
    M._ROLE = {}
    M._MT = { __index = M }
    M._ATTR = {}
    setmetatable(M._ATTR, {})
    M.can = can
    M.isa = isa
    M.does = does
    M.new = function (...) return new(M, ...) end
    M.__gc = function (...) return __gc(M, ...) end
    M._INIT = function (...) return _INIT(M, ...) end
    M.has = setmetatable({}, { __newindex = function (t, k, v) has(M, k, v) end })
    M.method = setmetatable({}, { __newindex = function (t, k, v) method(M, k, v) end })
    M.overload = setmetatable({}, { __newindex = function (t, k, v) overload(M, k, v) end })
    M.override = setmetatable({}, { __newindex = function (t, k, v) override(M, k, v) end })
    M.before = setmetatable({}, { __newindex = function (t, k, v) before(M, k, v) end })
    M.around = setmetatable({}, { __newindex = function (t, k, v) around(M, k, v) end })
    M.after = setmetatable({}, { __newindex = function (t, k, v) after(M, k, v) end })
    M.extends = function (...) return extends(M, ...) end
    M.with = function (...) return with(M, ...) end
    local classes = Meta.classes()
    classes[modname] = M
end

_VERSION = "0.5.0"
_DESCRIPTION = "lua-Coat : Yet Another Lua Object-Oriented Model"
_COPYRIGHT = "Copyright (c) 2009 Francois Perrad"
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
