#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.read = { is = 'ro', default = 2, isa = 'number' }
has.write = { is = 'rw', default = 3, isa = 'number' }

require 'Test.More'

plan(8)

foo = Foo.new{ read = 4, write = 5 }
is( foo:read(), 4, "Foo" )
is( foo:write(), 5 )
foo:write(7)
is( foo:write(), 7 )

error_like([[local foo = Foo.new{ read = 4, write = 5 }; foo:read(5)]],
           "^[^:]+:%d+: Cannot set a read%-only attribute %(read%)")

foo = Foo.new()
is( foo:read(), 2, "Foo (default)" )
is( foo:write(), 3 )
foo:write(7)
is( foo:write(), 7 )

error_like([[local foo = Foo.new(); foo:read(5)]],
           "^[^:]+:%d+: Cannot set a read%-only attribute %(read%)")

