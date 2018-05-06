#!/usr/bin/env lua

require 'Coat.Role'

class 'MyApp.Foo.Bar'
has.baz = { is = 'rw' }

require 'Test.More'

plan(2)

foo = MyApp.Foo.Bar.new()
ok( foo:isa 'MyApp.Foo.Bar' )
is( foo:baz( 'baz' ), 'baz' )

