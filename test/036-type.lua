#!/usr/bin/env lua

require 'Coat'

class 'A'
has.a = { is = 'rw', isa = 'A' }

class 'B'
extends 'A'
has.b = { is = 'rw', isa = 'B' }

class 'C'
extends 'B'
has.c = { is = 'rw', isa = 'C' }


require 'lunity'
module( 'TestTypes', lunity )

function test_A ()
    local foo = A()
    assertType( foo:a(A()), 'A' )
    assertType( foo:a(B()), 'B' )
    assertType( foo:a(C()), 'C' )
end

function test_B ()
    local foo = B()
    assertType( foo:a(A()), 'A' )
    assertType( foo:a(B()), 'B' )
    assertType( foo:a(C()), 'C' )
    assertErrors( foo.b, foo, A() ) -- foo:b(A())
    assertType( foo:b(B()), 'B' )
    assertType( foo:b(C()), 'C' )
end

function test_C ()
    local foo = C()
    assertType( foo:a(A()), 'A' )
    assertType( foo:a(B()), 'B' )
    assertType( foo:a(C()), 'C' )
    assertErrors( foo.b, foo, A() ) -- foo:b(A())
    assertType( foo:b(B()), 'B' )
    assertType( foo:b(C()), 'C' )
    assertErrors( foo.c, foo, A() ) -- foo:c(A())
    assertErrors( foo.c, foo, B() ) -- foo:c(B())
    assertType( foo:c(C()), 'C' )
end


runTests{ useANSI = false }
