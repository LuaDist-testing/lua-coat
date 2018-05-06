#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.read = { is = 'ro', default = 2, isa = 'number' }
has.write = { is = 'rw', default = 3, isa = 'number' }

require 'lunity'
module( 'TestAttrPermission', lunity )

function test_Foo ()
    local foo = Foo.new{ read = 4, write = 5 }
    assertEqual( foo:read(), 4 )
    assertEqual( foo:write(), 5 )
    foo:write(7)
    assertEqual( foo:write(), 7 )
    assertErrors( foo.read, foo, 5 ) -- foo:read(5)
end

function test_FooDefault ()
    local foo = Foo.new()
    assertEqual( foo:read(), 2 )
    assertEqual( foo:write(), 3 )
    foo:write(7)
    assertEqual( foo:write(), 7 )
    assertErrors( foo.read, foo, 5 ) -- foo:read(5)
end


runTests{ useANSI = false }
