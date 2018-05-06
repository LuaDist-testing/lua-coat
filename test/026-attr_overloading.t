#!/usr/bin/env lua

require 'Coat'

class 'A'
has.x = { is = 'rw', isa = 'number', default = 42 }

class 'B'
extends 'A'
has.x = { '+', default = 43 }

require 'Test.More'

plan(5)

foo = A.new()
ok( foo:isa 'A', "A" )
is( foo:x(), 42 )

foo = B.new()
ok( foo:isa 'B', "B" )
ok( foo:isa 'A' )
is( foo:x(), 43 )

