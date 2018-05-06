
--
-- lua-Coat : <http://lua-coat.luaforge.net/>
--

local pairs = pairs

local mc = require 'Coat.Meta.Class'
local mr = require 'Coat.Meta.Role'

module 'Coat.UML'

local function escape (txt)
    txt = txt:gsub( '&', '&amp;' )
    txt = txt:gsub( '<', '&lt;' )
    txt = txt:gsub( '>', '&gt;' )
    return txt
end

local function find_type (name)
    if mc.class(name) then
        return name
    end
    if mr.role(name) then
        return name
    end
    local capt = name:match'^table(%b<>)$'
    if capt then
        local typev = capt:sub(2, capt:len()-1)
        local idx = typev:find','
        if idx then
            typev = typev:sub(idx+1)
        end
        return find_type(typev)
    end
end

function to_dot (opt)
    opt = opt or {}
    local with_attr = not opt.no_attr
    local with_meth = not opt.no_meth
    local with_meta = not opt.no_meta
    local out = 'digraph {\n\n    node [shape=record];\n\n'
    for classname, class in pairs(mc.classes()) do
        out = out .. '    "' .. classname .. '"\n'
        out = out .. '        [label="{'
        if class.instance then
            out = out .. '&laquo;singleton&raquo;\\n'
        end
        out = out .. '\\N'
        if with_attr then
            local first = true
            for name, attr in mc.attributes(class) do
                if first then
                    out = out .. '|'
                    first = false
                end
                out = out .. name
                if attr.isa then
                    out = out .. ' : ' .. escape(attr.isa)
                elseif attr.does then
                    out = out .. ' : ' .. attr.does
                end
                out = out .. '\\l'
            end
        end
        if with_meth then
            local first = true
            if with_meta then
                for name in mc.metamethods(class) do
                    if first then
                        out = out .. '|'
                        first = false
                    end
                    out = out .. name .. '()\\l'
                end
            end
            for name in mc.methods(class) do
                if first then
                    out = out .. '|'
                    first = false
                end
                out = out .. name .. '()\\l'
            end
        end
        out = out .. '}"];\n'
        for name, attr in mc.attributes(class) do
            if attr.isa then
                local isa = find_type(attr.isa)
                if isa then
                    out = out .. '    "' .. classname .. '" -> "' .. isa .. '" // attr isa ' .. attr.isa .. '\n'
                    out = out .. '        [label = "' .. name .. '", arrowhead = none, arrowtail = odiamond];\n'
                end
            end
            if attr.does and mr.role(attr.does) then
                out = out .. '    "' .. classname .. '" -> "' .. attr.does .. '" // attr does\n'
                out = out .. '        [label = "' .. name .. '", arrowhead = none, arrowtail = odiamond];\n'
            end
        end
        for parent in mc.parents(class) do
            out = out .. '    "' .. classname .. '" -> "' .. parent .. '" // extends\n'
            out = out .. '        [arrowhead = onormal, arrowtail = none, arrowsize = 2.0];\n'
        end
        for role in mc.roles(class) do
            out = out .. '    "' .. classname .. '" -> "' .. role .. '" // with\n'
            out = out .. '        [arrowhead = odot, arrowtail = none];\n'
        end
        out = out .. '\n'
    end
    for rolename, role in pairs(mr.roles()) do
        out = out .. '    "' .. rolename .. '"\n'
        out = out .. '        [label="{&laquo;role&raquo;\\n\\N'
        if with_attr then
            local first = true
            for name, attr in mr.attributes(role) do
                if first then
                    out = out .. '|'
                    first = false
                end
                out = out .. name
                if attr.isa then
                    out = out .. ' : ' .. escape(attr.isa)
                elseif attr.does then
                    out = out .. ' : ' .. attr.does
                end
                out = out .. '\\l'
            end
        end
        if with_meth then
            local first = true
            for name in mr.methods(role) do
                if first then
                    out = out .. '|'
                    first = false
                end
                out = out .. name .. '()\\l'
            end
        end
        out = out .. '}"];\n\n'
        for name, attr in mr.attributes(role) do
            if attr.isa then
                local isa = find_type(attr.isa)
                if isa then
                    out = out .. '    "' .. rolename .. '" -> "' .. isa .. '" // attr isa ' .. attr.isa .. '\n'
                    out = out .. '        [label = "' .. name .. '", arrowhead = none, arrowtail = odiamond];\n'
                end
            end
            if attr.does and mr.role(attr.does) then
                out = out .. '    "' .. rolename .. '" -> "' .. attr.does .. '" // attr does\n'
                out = out .. '        [label = "' .. name .. '", arrowhead = none, arrowtail = odiamond];\n'
            end
        end
    end
    out = out .. '}'
    return out
end

--
-- Copyright (c) 2009-2010 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
