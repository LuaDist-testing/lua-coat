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


require 'lunity'
module( 'TestRoleRequiresMeth', lunity )

function test_Car ()
    local car = Car.new()
    assertTrue( car:isa 'Car' )
    assertTrue( car:does 'Breakable' )
    assertEqual( car:_break(), "I broke" )
end

function test_SpecialCar ()
    local car = SpecialCar.new()
    assertTrue( car:isa 'SpecialCar' )
    assertTrue( car:does 'Breakable' )
    assertEqual( car:_break(), "I broke" )
end

function test_BadCar ()
    -- local car = BadCar.new()
    assertErrors( BadCar.new )
end


runTests{ useANSI = false }
