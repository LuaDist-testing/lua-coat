
--
-- lua-Coat : <http://lua-coat.luaforge.net/>
--

require 'Coat'

local pairs = pairs
local require = require
local setmetatable = setmetatable
local _G = _G
local table = require 'table'

local basic_type = type
local checktype = Coat.checktype
local coat_module = Coat.module

module 'Coat.Role'

local Meta = require 'Coat.Meta.Role'

function has (role, name, options)
    checktype('has', 1, name, 'string')
    checktype('has', 2, options or {}, 'table')
    table.insert(role._STORE, { 'has', name, options })
end

function method (role, name, func)
    checktype('method', 1, name, 'string')
    checktype('method', 2, func, 'function')
    table.insert(role._STORE, { 'method', name, func })
end

function requires (role, ...)
    for i, meth in pairs{...} do
        checktype('requires', i, meth, 'string')
        table.insert(role._REQ, meth)
    end
end

function excludes (role, ...)
    for i, r in pairs{...} do
        checktype('excludes', i, r, 'string')
        table.insert(role._EXCL, r)
    end
end

function _G.role (modname)
    checktype('role', 1, modname, 'string')
    local M = coat_module(modname, 3)
    setmetatable(M, { __index = _G })
    M._STORE = {}
    M._REQ = {}
    M._EXCL = {}
    M.has = setmetatable({}, { __newindex = function (t, k, v) has(M, k, v) end })
    M.method = setmetatable({}, { __newindex = function (t, k, v) method(M, k, v) end })
    M.requires = function (...) return requires(M, ...) end
    M.excludes = function (...) return excludes(M, ...) end
    local roles = Meta.roles()
    roles[modname] = M
end

--
-- Copyright (c) 2009-2010 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
