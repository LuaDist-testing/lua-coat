#!/usr/bin/env lua

require 'Coat.Role'

role 'Foo'

local function m1 (self)
    return "m1"
end

method.m1 = m1

method.m2 = function (self)
    return m1(self) .. "m2"
end

class 'A'
with 'Foo'

class 'B'
with( 'Foo', { alias = { m1 = 'foo_m1', m2 = 'foo_m2' } } )

class 'C'
with( 'Foo', { alias = { m1 = 'foo_m1', m2 = 'foo_m2' },
               excludes = { 'm1', 'm2' } } )


require 'lunity'
module( 'TestRoleAliasMeth', lunity )

function test_A ()
    local a = A.new()
    assertTrue( a:isa 'A' )
    assertInvokable( a.m1 )
    assertInvokable( a.m2 )
    assertEqual( a:m1(), 'm1' )
    assertEqual( a:m2(), 'm1m2' )
end

function test_B ()
    local b = B.new()
    assertTrue( b:isa 'B' )
    assertInvokable( b.m1 )
    assertInvokable( b.m2 )
    assertInvokable( b.foo_m1 )
    assertInvokable( b.foo_m2 )
    assertEqual( b:m1(), 'm1' )
    assertEqual( b:m2(), 'm1m2' )
end

function test_C ()
    local c = C.new()
    assertTrue( c:isa 'C' )
    assertNil( c.m1 )
    assertNil( c.m2 )
    assertInvokable( c.foo_m1 )
    assertInvokable( c.foo_m2 )
    assertEqual( c:foo_m1(), 'm1' )
    assertEqual( c:foo_m2(), 'm1m2' )
end


runTests{ useANSI = false }
