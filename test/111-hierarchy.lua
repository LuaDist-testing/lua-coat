#!/usr/bin/env lua

require 'MyApp'

require 'lunity'
module( 'TestHierarchy', lunity )

function test_Bar ()
    local bar = MyApp.Bar.new()
    assertTrue( bar:isa 'MyApp.Bar' )
end

function test_BarFoo ()
    local foo = MyApp.Bar.Foo.new()
    assertTrue( foo:isa 'MyApp.Bar.Foo' )
    assertEqual( foo:bar( 'bar' ), 'bar' )
end

function test_Baz ()
    local baz = MyApp.Baz.new()
    assertTrue( baz:isa 'MyApp.Baz' )
end

function test_BazFoo ()
    local foo = MyApp.Baz.Foo.new()
    assertTrue( foo:isa 'MyApp.Baz.Foo' )
    assertEqual( foo:baz( 'baz' ), 'baz' )
end


runTests{ useANSI = false }
