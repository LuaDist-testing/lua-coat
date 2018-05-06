#!/usr/bin/env lua

require 'Coat'

class 'Car'

has.engine = { is = 'ro', isa = 'string', lazy = true, builder = '_build_engine' }

method._build_engine = function ()
    return "Engine"
end

class 'SpecialCar'
extends 'Car'

override._build_engine = function ()
    return "SpecialEngine"
end


require 'lunity'
module( 'TestAttrBuilder', lunity )

function test_Car ()
    local car = Car.new()
    assertTrue( car:isa 'Car' )
    assertEqual( car:engine(), 'Engine' )
end

function test_SpecialCar ()
    local car = SpecialCar.new()
    assertTrue( car:isa 'SpecialCar' )
    assertTrue( car:isa 'Car' )
    assertEqual( car:engine(), 'SpecialEngine' )
end


runTests{ useANSI = false }
