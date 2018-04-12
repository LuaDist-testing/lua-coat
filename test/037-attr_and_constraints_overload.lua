#!/usr/bin/env lua

require 'Coat.Types'

subtype.Positive = {
    as = 'number',
    where = function (n) return n > 0 end
}

class 'Parent'
has.name = { is = 'rw', isa = 'string' }
has.lazy_classname = { is = 'ro', lazy = true,
    default = function () return "Parent" end,
}
has.type_constrained = { is = 'rw', isa = 'Positive',
    default = 5.5
}

class 'Child'
extends 'Parent'
has.name = { '+', default = "Junior" }
has.lazy_classname = { '+', default = function () return "Child" end }
has.type_constrained = { '+', isa = 'string', default = 'empty' }


require 'lunity'
module( 'TestHandles', lunity )

function test_Parent ()
    local foo = Parent.new()
    assertTrue( foo:isa 'Parent' )
    assertNil( foo:name() )
    assertEqual( foo:name( 'John' ), 'John' )
    assertEqual( foo:lazy_classname(), 'Parent' )
    assertErrors( foo.lazy_classname, foo, 'Object' ) -- foo:lazy_classname 'Object'
    assertEqual( foo:type_constrained(), 5.5 )
    assertEqual( foo:type_constrained(10.5), 10.5 )
    assertErrors( foo.type_constrained, foo, -0.5 ) -- foo:type_constrained(-0.5)
end

function test_Child ()
    local foo = Child.new()
    assertTrue( foo:isa 'Child' )
    assertTrue( foo:isa 'Parent' )
    assertEqual( foo:name(), 'Junior' )
    assertEqual( foo:name( 'John' ), 'John' )
    assertEqual( foo:lazy_classname(), 'Child' )
    assertErrors( foo.lazy_classname, foo, 'Object' ) -- foo:lazy_classname 'Object'
    assertEqual( foo:type_constrained(), 'empty' )
    assertEqual( foo:type_constrained( 'text' ), 'text' )
    assertErrors( foo.type_constrained, foo, -0.5 ) -- foo:type_constrained(-0.5)
end


runTests{ useANSI = false }
