#!/usr/bin/env lua

require 'Coat'

class 'Foo'
has.x = { is = 'rw', isa = 'number' }
has.s = { is = 'rw', isa = 'string' }
has.c = { is = 'rw', isa = 'function' }
has.subobject = { is = 'rw', isa = 'Bar' }

class 'Bar'
has.x = { is = 'rw' }

class 'Baz'

require 'lunity'
module( 'TestTypeConstraints', lunity )

function test_Foo ()
    local foo = Foo.new()
    foo:x(43)
    assertEqual( foo:x(), 43 )
    foo:s "text"
    assertEqual( foo:s(), "text" )
    foo:c( function () return 3 end )
    assertEqual( foo:c()(), 3 )
    foo:subobject(Bar.new())
    assertType( foo:subobject(), 'Bar' )
    -- invalid call
    assertErrors( foo.x, foo, "text" ) -- foo:x "text"
    assertErrors( foo.s, foo, 2 ) -- foo:s(2)
    assertErrors( foo.c, foo, 2 ) -- foo:c(2)
    assertErrors( foo.subobject, foo, Baz.new() ) -- foo:subobject(Baz.new())
end

runTests{ useANSI = false }
