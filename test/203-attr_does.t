#!/usr/bin/env lua

require 'Coat.Role'

role 'Breakable'

has.is_broken = { is = 'rw', isa = 'boolean' }

method._break = function (self)
    self:is_broken(true)
end

class 'Engine'
with 'Breakable'

class 'SpecialEngine'
extends 'Engine'

class 'Car'
has.engine = { is = 'rw', does = 'Breakable' }

require 'Test.More'

plan(6)

car = Car.new{ engine = Engine.new() }
ok( car:isa 'Car', "Car" )
ok( car:engine():does 'Breakable' )
is( car:engine():is_broken(), nil )
car:engine():_break()
ok( car:engine():is_broken() )
error_like([[local car = Car.new{ engine = Engine.new() }; car:engine( Car.new() )]],
           "^[^:]+:%d+: Value for attribute 'engine' does not consume role 'Breakable'")
car:engine( SpecialEngine.new() )
ok( car:engine():does 'Breakable' )

