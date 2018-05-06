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

require 'Test.More'

plan(18)

foo = A()
is( foo:a(A()):type(), 'A', "A" )
is( foo:a(B()):type(), 'B' )
is( foo:a(C()):type(), 'C' )

foo = B()
is( foo:a(A()):type(), 'A', "B" )
is( foo:a(B()):type(), 'B' )
is( foo:a(C()):type(), 'C' )
error_like([[local foo = B(); foo:b(A())]],
           "^[^:]+:%d+: Invalid type for attribute 'b' %(got A, expected B%)")
is( foo:b(B()):type(), 'B' )
is( foo:b(C()):type(), 'C' )

foo = C()
is( foo:a(A()):type(), 'A', "C" )
is( foo:a(B()):type(), 'B' )
is( foo:a(C()):type(), 'C' )
error_like([[local foo = C(); foo:b(A())]],
           "^[^:]+:%d+: Invalid type for attribute 'b' %(got A, expected B%)")
is( foo:b(B()):type(), 'B' )
is( foo:b(C()):type(), 'C' )
error_like([[local foo = C(); foo:c(A())]],
           "^[^:]+:%d+: Invalid type for attribute 'c' %(got A, expected C%)")
error_like([[local foo = C(); foo:c(B())]],
           "^[^:]+:%d+: Invalid type for attribute 'c' %(got B, expected C%)")
is( foo:c(C()):type(), 'C' )

