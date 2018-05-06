#!/usr/bin/env lua

module('MyApp', package.seeall)

require 'Coat.Role'

role 'MyApp.Biz'

class 'MyApp.Bar'

class 'MyApp.Bar.Foo'
with 'MyApp.Biz'
has.bar = { is = 'rw' }

class 'MyApp.Baz'

class 'MyApp.Baz.Foo'
with 'MyApp.Biz'
has.baz = { is = 'rw' }

require 'Test.More'

plan(8)

bar = MyApp.Bar.new()
ok( bar:isa 'MyApp.Bar', "MyApp.Bar" )

foo = MyApp.Bar.Foo.new()
ok( foo:isa 'MyApp.Bar.Foo', "MyApp.Bar.Foo" )
ok( foo:does 'MyApp.Biz' )
is( foo:bar( 'bar' ), 'bar' )

foo = MyApp.Baz.new()
ok( foo:isa 'MyApp.Baz', "MyApp.Baz" )

foo = MyApp.Baz.Foo.new()
ok( foo:isa 'MyApp.Baz.Foo', "MyApp.Baz.Foo" )
ok( foo:does 'MyApp.Biz' )
is( foo:baz( 'baz' ), 'baz' )

