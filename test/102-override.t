#!/usr/bin/env lua

require 'Coat'

class 'Parent'
method.bar = function (self) return 'bar' end
method.baz = function (self) return 'baz' end

class 'Child'
extends 'Parent'
override.bar = function (self) return 'BAR' end

require 'Test.More'

plan(14)

p = Parent.new()
ok( p:isa 'Parent', "Parent" )
ok( p.bar )
ok( p.baz )
is( p:bar(), 'bar' )
is( p:baz(), 'baz' )

c = Child.new()
ok( c:isa 'Child', "Child" )
ok( c:isa 'Parent' )
ok( c.bar )
ok( c.baz )
is( c:bar(), 'BAR' )
is( c:baz(), 'baz' )

error_like([[Child.override.biz = function (self) return 'BIZ' end]],
           "^[^:]+:%d+: Cannot override non%-existent method biz in class Child",
           "bad 1")

error_like([[Child.method.baz = function (self) return 'baz' end]],
           "^[^:]+:%d+: Duplicate definition of method baz",
           "bad 2")

error_like([[Parent.method.baz = function (self) return 'baz' end]],
           "^[^:]+:%d+: Duplicate definition of method baz",
           "bad 3")

