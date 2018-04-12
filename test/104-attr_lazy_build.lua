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


require 'lunity'
module( 'TestAttrLazyBuild', lunity )

function test_Car ()
    local car = Car.new()
    assertTrue( car:isa 'Car' )
    assertEqual( car:engine(), 'Engine' )
    assertInvokable( car.clear_engine )
    assertEqual( car:_size(), 1 )
    assertInvokable( car._clear_size )
end

function test_SpecialCar ()
    local car = SpecialCar.new()
    assertTrue( car:isa 'SpecialCar' )
    assertTrue( car:isa 'Car' )
    assertEqual( car:engine(), 'SpecialEngine' )
    assertInvokable( car.clear_engine )
end


runTests{ useANSI = false }
