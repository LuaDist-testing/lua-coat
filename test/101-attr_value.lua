#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.attr = { is = 'rw', clearer = 'clear_attr' }

require 'lunity'
module( 'TestAttrValue', lunity )

function test_Foo ()
    local foo = Foo.new()
    assertEqual( foo:attr(), nil )
    foo:attr(2)
    assertEqual( foo:attr(), 2 )
    foo:attr(false)
    assertEqual( foo:attr(), false )
    foo:attr(nil) -- ~ foo:attr() ie. getter
    assertEqual( foo:attr(), false )
    assertInvokable( foo.clear_attr )
    foo:clear_attr()
    assertEqual( foo:attr(), nil )
end


runTests{ useANSI = false }
