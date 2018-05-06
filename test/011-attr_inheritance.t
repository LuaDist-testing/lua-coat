#!/usr/bin/env lua

require 'Coat'

class 'Foo'
has.field_from_foo_string = { is = 'rw', isa = 'string' }
has.field_from_foo_int = { is = 'rw', isa = 'number', default = 1 }

class 'Bar'
extends 'Foo'
has.field_from_bar = { is = 'rw' }

class 'Baz'
extends 'Bar'
has.field_from_baz = { is = 'rw' }
-- we redefine an attribute of an inherited class
has.field_from_foo_int = { '+', default = 2 }

class 'Biz'
has.field_from_biz = { is = 'rw' }

class 'BalBaz'
extends( 'Bar', 'Biz' )

require 'Test.More'

plan(23)

foo = Foo.new()
ok( foo:isa 'Foo', "Foo" )
ok( foo.field_from_foo_string )
ok( foo.field_from_foo_int )
is( foo:field_from_foo_int(), 1 )

bar = Bar.new()
ok( bar:isa 'Bar', "Bar" )
ok( bar.field_from_foo_string )
ok( bar.field_from_foo_int )
ok( bar.field_from_bar )
is( bar:field_from_foo_int(), 1 )

baz = Baz.new()
ok( baz:isa 'Baz', "Baz" )
ok( baz.field_from_foo_string )
ok( baz.field_from_foo_int )
ok( baz.field_from_bar )
ok( baz.field_from_baz )
is( baz:field_from_foo_int(), 2 )

biz = Biz.new()
ok( biz:isa 'Biz', "Biz" )
ok( biz.field_from_biz )

bal = BalBaz.new()
ok( bal:isa 'BalBaz', "BalBaz" )
ok( bal.field_from_foo_string )
ok( bal.field_from_foo_int )
ok( bal.field_from_bar )
ok( bal.field_from_biz )
is( bal:field_from_foo_int(), 1 )

