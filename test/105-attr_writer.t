#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.bar = { is = 'ro', writer = '_set_bar', reader = '_get_bar' }

require 'Test.More'

plan(9)

foo = Foo.new{ bar = 1 }
ok( foo:isa 'Foo', "Foo" )
is( foo:bar(), 1 )
error_like([[local foo = Foo.new{ bar = 1 }; foo:bar(2)]],
           "^[^:]+:%d+: Cannot set a read%-only attribute %(bar%)")
is( foo:_set_bar(3), 3 )
is( foo:_get_bar(), 3 )
is( foo:bar(), 3 )
is( foo:_set_bar(nil), nil )
is( foo:_get_bar(), nil )
is( foo:bar(), nil )

