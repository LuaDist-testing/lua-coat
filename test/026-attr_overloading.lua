#!/usr/bin/env lua

require 'Coat'

class 'A'
has.x = { is = 'rw', isa = 'number', default = 42 }

class 'B'
extends 'A'
has.x = { '+', default = 43 }


require 'lunity'
module( 'TestHandles', lunity )

function test_A ()
    local foo = A.new()
    assertTrue( foo:isa 'A' )
    assertEqual( foo:x(), 42 )
end

function test_B ()
    local foo = B.new()
    assertTrue( foo:isa 'B' )
    assertTrue( foo:isa 'A' )
    assertEqual( foo:x(), 43 )
end


runTests{ useANSI = false }
