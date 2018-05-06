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

require 'lunity'
module( 'TestAttrInheritance', lunity )

function test_Foo ()
    local foo = Foo.new()
    assertTrue( foo:isa 'Foo' )
    assertInvokable( foo.field_from_foo_string )
    assertInvokable( foo.field_from_foo_int )
    assertEqual( foo:field_from_foo_int(), 1 )
end

function test_Bar ()
    local bar = Bar.new()
    assertTrue( bar:isa 'Bar' )
    assertInvokable( bar.field_from_foo_string )
    assertInvokable( bar.field_from_foo_int )
    assertInvokable( bar.field_from_bar )
    assertEqual( bar:field_from_foo_int(), 1 )
end

function test_Baz ()
    local baz = Baz.new()
    assertTrue( baz:isa 'Baz' )
    assertInvokable( baz.field_from_foo_string )
    assertInvokable( baz.field_from_foo_int )
    assertInvokable( baz.field_from_bar )
    assertInvokable( baz.field_from_baz )
    assertEqual( baz:field_from_foo_int(), 2 )
end

function test_Biz ()
    local biz = Biz.new()
    assertTrue( biz:isa 'Biz' )
    assertInvokable( biz.field_from_biz )
end

function test_BalBaz ()
    local bal = BalBaz.new()
    assertTrue( bal:isa 'BalBaz' )
    assertInvokable( bal.field_from_foo_string )
    assertInvokable( bal.field_from_foo_int )
    assertInvokable( bal.field_from_bar )
    assertInvokable( bal.field_from_biz )
    assertEqual( bal:field_from_foo_int(), 1 )
end


runTests{ useANSI = false }
