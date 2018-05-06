#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.t = { is = 'rw', default = function () return 2 + 2 end }

require 'Test.More'

plan(5)

foo = Foo.new{ t = 2 }
ok( foo:isa 'Foo', "Foo" )
is( foo:t(), 2 )

foo = Foo.new()
ok( foo:isa 'Foo', "Foo (default)" )
val = foo:t()
isnt( type(val), 'function' )
is( val, 4 )

