--
-- lua-Coat : <http://fperrad.github.com/lua-Coat/>
--

local getmetatable = getmetatable
local io = require 'io'

module 'Coat.file'

getmetatable(io.input())._ISA = { 'file' }

--
-- Copyright (c) 2010 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
