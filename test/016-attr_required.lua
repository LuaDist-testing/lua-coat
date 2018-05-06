#!/usr/bin/env lua

require 'Coat'

class 'Foo'
has.bar = { is = 'ro', required = true }
has.baz = { is = 'rw', default = 100, required = true }
has.boo = { is = 'rw', lazy = true, default = 50, required = true }
has.subobject = { isa = 'Bar' }


require 'lunity'
module( 'TestAttrRequired', lunity )

function test_Foo1 ()
    local foo = Foo.new{ bar = 10, baz = 20, boo = 100 }
    assertTrue( foo:isa 'Foo' )
    assertEqual( foo:bar(), 10 )
    assertEqual( foo:baz(), 20 )
    assertEqual( foo:boo(), 100 )
end

function test_Foo2 ()
    local foo = Foo.new{ bar = 10, boo = 5 }
    assertTrue( foo:isa 'Foo' )
    assertEqual( foo:bar(), 10 )
    assertEqual( foo:baz(), 100 )
    assertEqual( foo:boo(), 5 )
end

function test_Foo3 ()
    local foo = Foo.new{ bar = 10 }
    assertTrue( foo:isa 'Foo' )
    assertEqual( foo:bar(), 10 )
    assertEqual( foo:baz(), 100 )
    assertEqual( foo:boo(), 50 )
end

function test_Foo4 ()
    -- local foo = Foo.new()
    assertErrors( Foo.new )
end

runTests{ useANSI = false }
