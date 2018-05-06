#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.bar = { is = 'ro', writer = '_set_bar', reader = '_get_bar' }

require 'lunity'
module( 'TestAttrWriter', lunity )

function test_Foo ()
    local foo = Foo.new{ bar = 1 }
    assertTrue( foo:isa 'Foo' )
    assertEqual( foo:bar(), 1 )
    assertErrors( foo.bar, foo, 2 ) -- foo:bar(2)
    assertEqual( foo:_set_bar(3), 3 )
    assertEqual( foo:_get_bar(), 3 )
    assertEqual( foo:bar(), 3 )
    assertNil( foo:_set_bar(nil) )
    assertNil( foo:_get_bar() )
    assertNil( foo:bar() )
end


runTests{ useANSI = false }
