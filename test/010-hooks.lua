#!/usr/bin/env lua

require 'Coat'

class 'Parent'

method.pushelem = function (self, elem)
    table.insert( _G.list, elem )
end

class 'Child'
extends 'Parent'

before.pushelem = function (self, elem)
    table.insert( _G.list, 'before1:' .. elem )
end

before.pushelem = function (self, elem)
    table.insert( _G.list, 'before2:' .. elem )
end

after.pushelem = function (self, elem)
    table.insert( _G.list, 'after1:' .. elem )
end

before.pushelem = function (self, elem)
    table.insert( _G.list, 'before3:' .. elem )
end

after.pushelem = function (self, elem)
    table.insert( _G.list, 'after2:' .. elem )
end

after.pushelem = function (self, elem)
    table.insert( _G.list, 'after3:' .. elem )
end

require 'lunity'
module( 'TestHooks', lunity )

function setup ()
    _G.list = {}
end

function test_Simple ()
    local p = Parent.new()
    assertTrue( p:isa 'Parent' )
    assertInvokable( p.pushelem )
    p:pushelem 'Coat'
    assertTableEquals( _G.list, { 'Coat' } )
end

function test_Multiple ()
    local c = Child.new()
    assertTrue( c:isa 'Child' )
    assertTrue( c:isa 'Parent' )
    assertInvokable( c.pushelem )
    c:pushelem 'Coat'
    assertTableEquals( _G.list, {
        'before3:Coat',
        'before2:Coat',
        'before1:Coat',
                'Coat',
        'after1:Coat',
        'after2:Coat',
        'after3:Coat',
    } )
end


runTests{ useANSI = false }
