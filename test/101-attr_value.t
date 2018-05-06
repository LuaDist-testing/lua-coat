#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.attr = { is = 'rw', clearer = 'clear_attr' }

require 'Test.More'

plan(6)

foo = Foo.new()
is( foo:attr(), nil )
foo:attr(2)
is( foo:attr(), 2 )
foo:attr(false)
is( foo:attr(), false )
foo:attr(nil) -- ~ foo:attr() ie. getter
is( foo:attr(), false )
ok( foo.clear_attr )
foo:clear_attr()
is( foo:attr(), nil )

