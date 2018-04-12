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

require 'lunity'
module( 'TestHierarchy', lunity )

function test_Bar ()
    local bar = MyApp.Bar.new()
    assertTrue( bar:isa 'MyApp.Bar' )
end

function test_BarFoo ()
    local foo = MyApp.Bar.Foo.new()
    assertTrue( foo:isa 'MyApp.Bar.Foo' )
    assertTrue( foo:does 'MyApp.Biz' )
    assertEqual( foo:bar( 'bar' ), 'bar' )
end

function test_Baz ()
    local baz = MyApp.Baz.new()
    assertTrue( baz:isa 'MyApp.Baz' )
end

function test_BazFoo ()
    local foo = MyApp.Baz.Foo.new()
    assertTrue( foo:isa 'MyApp.Baz.Foo' )
    assertTrue( foo:does 'MyApp.Biz' )
    assertEqual( foo:baz( 'baz' ), 'baz' )
end


runTests{ useANSI = false }
