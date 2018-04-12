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


require 'lunity'
module( 'TestAttrDoes', lunity )

function test_Car ()
    local car = Car.new{ engine = Engine.new() }
    assertTrue( car:isa 'Car' )
    assertTrue( car:engine():does 'Breakable' )
    assertNil( car:engine():is_broken() )
    car:engine():_break()
    assertTrue( car:engine():is_broken() )
    assertErrors( car.engine, car , Car.new() ) -- car:engine( Car.new() )
    car:engine( SpecialEngine.new() )
    assertTrue( car:engine():does 'Breakable' )
end


runTests{ useANSI = false }
