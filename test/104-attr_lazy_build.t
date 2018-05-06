#!/usr/bin/env lua

require 'Coat'

class 'Car'

has.engine = { is = 'ro', isa = 'string', lazy_build = true }
has._size = { is = 'ro', lazy_build = true }

method._build_engine = function ()
    return "Engine"
end

method._build__size = function ()
    return 1
end

class 'SpecialCar'
extends 'Car'

override._build_engine = function ()
    return "SpecialEngine"
end

require 'Test.More'

plan(9)

car = Car.new()
ok( car:isa 'Car', "Car" )
is( car:engine(), 'Engine' )
ok( car.clear_engine )
is( car:_size(), 1 )
ok( car._clear_size )

car = SpecialCar.new()
ok( car:isa 'SpecialCar', "SpecialCar" )
ok( car:isa 'Car' )
is( car:engine(), 'SpecialEngine' )
ok( car.clear_engine )

