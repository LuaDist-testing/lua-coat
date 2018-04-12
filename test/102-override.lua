#!/usr/bin/env lua

require 'Coat'

class 'Parent'
method.bar = function (self) return 'bar' end
method.baz = function (self) return 'baz' end

class 'Child'
extends 'Parent'
override.bar = function (self) return 'BAR' end


require 'lunity'
module( 'TestTypeConstraints', lunity )

function test_Parent ()
    local p = Parent.new()
    assertTrue( p:isa 'Parent' )
    assertInvokable( p.bar )
    assertInvokable( p.baz )
    assertEqual( p:bar(), 'bar' )
    assertEqual( p:baz(), 'baz' )
end

function test_Child ()
    local c = Child.new()
    assertTrue( c:isa 'Child' )
    assertTrue( c:isa 'Parent' )
    assertInvokable( c.bar )
    assertInvokable( c.baz )
    assertEqual( c:bar(), 'BAR' )
    assertEqual( c:baz(), 'baz' )
end

function test_Bad1 ()
    assertErrors( function ()
        Child.override.biz = function (self) return 'BIZ' end
    end )
end

function test_Bad2 ()
    assertErrors( function ()
        Child.method.baz = function (self) return 'baz' end
    end )
end

function test_Bad3 ()
    assertErrors( function ()
        Parent.method.baz = function (self) return 'baz' end
    end )
end


runTests{ useANSI = false }
