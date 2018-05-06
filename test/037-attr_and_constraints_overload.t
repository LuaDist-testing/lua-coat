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


require 'Test.More'

plan(17)

foo = Parent.new()
ok( foo:isa 'Parent', "Parent" )
is( foo:name(), nil )
is( foo:name( 'John' ), 'John' )
is( foo:lazy_classname(), 'Parent' )
error_like([[local foo = Parent.new(); foo:lazy_classname 'Object']],
           "^[^:]+:%d+: Cannot set a read%-only attribute %(lazy_classname%)")
is( foo:type_constrained(), 5.5 )
is( foo:type_constrained(10.5), 10.5 )
error_like([[local foo = Parent.new(); foo:type_constrained(-0.5)]],
           "^[^:]+:%d+: Value for attribute 'type_constrained' does not validate type constraint 'Positive'")

foo = Child.new()
ok( foo:isa 'Child', "Child" )
ok( foo:isa 'Parent' )
is( foo:name(), 'Junior' )
is( foo:name( 'John' ), 'John' )
is( foo:lazy_classname(), 'Child' )
error_like([[local foo = Child.new(); foo:lazy_classname 'Object']],
           "^[^:]+:%d+: Cannot set a read%-only attribute %(lazy_classname%)")
is( foo:type_constrained(), 'empty' )
is( foo:type_constrained( 'text' ), 'text' )
error_like([[local foo = Child.new(); foo:type_constrained(-0.5)]],
           "^[^:]+:%d+: Invalid type for attribute 'type_constrained' %(got number, expected string%)")

