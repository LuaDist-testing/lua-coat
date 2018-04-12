#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.t = { is = 'rw', default = function () return 2 + 2 end }

require 'lunity'
module( 'TestAttrDefautFunction', lunity )

function test_Foo ()
    local foo = Foo.new{ t = 2 }
    assertTrue( foo:isa 'Foo' )
    assert( foo:t(), 2 )
end

function test_FooDefault ()
    local foo = Foo.new()
    assertTrue( foo:isa 'Foo' )
    local val = foo:t()
    assertNotEqual( type(val), 'function' )
    assertEqual( val, 4 )
end

runTests{ useANSI = false }
