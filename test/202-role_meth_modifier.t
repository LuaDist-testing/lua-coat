#!/usr/bin/env lua

require 'Coat.Role'

role 'Breakable'

has.is_broken = { is = 'rw', isa = 'boolean' }

method._break = function (self)
    self:is_broken(true)
end

class 'Car'
with 'Breakable'

has.engine = { is = 'ro', isa = 'Engine' }

after._break = function (self)
    return "I broke"
end

require 'Test.More'

plan(5)

car = Car.new()
ok( car:isa 'Car', "Car" )
ok( car:does 'Breakable' )
is( car:is_broken(), nil )
is( car:_break(), "I broke" )
ok( car:is_broken() )

