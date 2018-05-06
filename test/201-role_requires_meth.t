#!/usr/bin/env lua

require 'Coat.Role'

role 'Breakable'
requires '_break'
excludes 'Repairable'

role 'Repairable'

class 'Car'
with 'Breakable'

method._break = function (self)
    return "I broke"
end

class 'SpecialCar'
extends 'Car'

class 'BadCar'
extends 'Car'
with 'Repairable'

require 'Test.More'

plan(7)

car = Car.new()
ok( car:isa 'Car', "Car" )
ok( car:does 'Breakable' )
is( car:_break(), "I broke" )

car = SpecialCar.new()
ok( car:isa 'SpecialCar', "SpecialCar" )
ok( car:does 'Breakable' )
is( car:_break(), "I broke" )

error_like([[local car = BadCar.new()]],
           "^[^:]+:%d+: Role Breakable excludes role Repairable",
           "BadCar")

