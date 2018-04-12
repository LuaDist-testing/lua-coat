#!/usr/bin/env lua

require 'Coat.Role'

class 'MyApp.Foo.Bar'
has.baz = { is = 'rw' }

require 'lunity'
module( 'TestCreateHierarchy', lunity )

function test_FooBar ()
    local foo = MyApp.Foo.Bar.new()
    assertTrue( foo:isa 'MyApp.Foo.Bar' )
    assertEqual( foo:baz( 'baz' ), 'baz' )
end


runTests{ useANSI = false }
