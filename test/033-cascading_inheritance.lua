#!/usr/bin/env lua

require 'Coat'

class 'One'
has.one = { isa = 'number', is = 'rw', default = 1 }

class 'Two'
extends 'One'
has.two = { isa = 'number', is = 'rw', default = 2 }

class 'Three'
extends 'Two'
has.three = { isa = 'number', is = 'rw', default = 3 }

class 'Four'
extends 'Three'
has.four = { isa = 'number', is = 'rw', default = 4 }


require 'lunity'
module( 'TestTypeConstraints', lunity )

function test_AttrFour ()
    local four = Four.new()
    assertEqual( four:one(), 1 )
    assertEqual( four:two(), 2 )
    assertEqual( four:three(), 3 )
    assertEqual( four:four(), 4 )
end

function test_IsaFour ()
    local four = Four.new()
    assertTrue( four:isa 'One' )
    assertTrue( four:isa 'Two' )
    assertTrue( four:isa 'Three' )
    assertTrue( four:isa 'Four' )
end


runTests{ useANSI = false }
