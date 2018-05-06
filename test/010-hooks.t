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

require 'Test.More'

plan(7)

p = Parent.new()
ok( p:isa 'Parent', "Simple" )
ok( p.pushelem )
_G.list = {}
p:pushelem 'Coat'
eq_array( _G.list, { 'Coat' } )

c = Child.new()
ok( c:isa 'Child', "Multiple" )
ok( c:isa 'Parent' )
ok( c.pushelem )
_G.list = {}
c:pushelem 'Coat'
eq_array( _G.list, {
        'before3:Coat',
        'before2:Coat',
        'before1:Coat',
                'Coat',
        'after1:Coat',
        'after2:Coat',
        'after3:Coat',
} )

