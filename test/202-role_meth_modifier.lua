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


require 'lunity'
module( 'TestRoleMethModifier', lunity )

function test_Car ()
    local car = Car.new()
    assertTrue( car:isa 'Car' )
    assertTrue( car:does 'Breakable' )
    assertNil( car:is_broken() )
    assertEqual( car:_break(), "I broke" )
    assertTrue( car:is_broken() )
end


runTests{ useANSI = false }
