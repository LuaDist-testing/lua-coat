
--
-- lua-Coat : <http://fperrad.github.com/lua-Coat/>
--

require 'Coat'

local require = require
local setmetatable = setmetatable
local _G = _G

local basic_type = type
local checktype = Coat.checktype
local coat_module = Coat.module

module 'Coat.Role'

local Meta = require 'Coat.Meta.Role'

function has (role, name, options)
    checktype('has', 1, name, 'string')
    checktype('has', 2, options or {}, 'table')
    local t = role._STORE; t[#t+1] = { 'has', name, options }
end

function method (role, name, func)
    checktype('method', 1, name, 'string')
    checktype('method', 2, func, 'function')
    local t = role._STORE; t[#t+1] = { 'method', name, func }
end

function requires (role, ...)
    local t = role._REQ
    local arg = {...}
    for i = 1, #arg do
        local meth = arg[i]
        checktype('requires', i, meth, 'string')
        t[#t+1] = meth
    end
end

function excludes (role, ...)
    local t = role._EXCL
    local arg = {...}
    for i = 1, #arg do
        local r = arg[i]
        checktype('excludes', i, r, 'string')
        t[#t+1] = r
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
