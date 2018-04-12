#!/usr/bin/env lua

require 'Coat.Types'

coerce.B = { A = function (val) return B{ x = 3 } end }

class 'A'
has.x = { is = 'rw', isa = 'number' }
has.b = { is = 'rw', isa = 'B', coerce = true }
has.c = { is = 'rw', isa = 'C' }

class 'B'
has.x = { is = 'rw', isa = 'number' }

class 'C'
has.x = { is = 'rw', isa = 'number' }


require 'lunity'
module( 'TestClassNameTypeConstraint', lunity )

function test_ABC ()
    local a = A{ x = 1 }
    local b = B{ x = 2 }
    assertTrue( a:isa 'A' )
    assertTrue( b:isa 'B' )
    a:b(b)
    assertEqual( a:b():x(), 2 )
    a:b(a)
    assertEqual( a:b():x(), 3 ) -- coerced
    assertErrors( a.c, a, A.new() ) -- a:c( A.new() )
    assertErrors( a.c, a, "text" ) -- a:c "text"
end


runTests{ useANSI = false }
