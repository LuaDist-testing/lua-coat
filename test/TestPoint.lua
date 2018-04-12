#!/usr/bin/env lua

require 'Point'
require 'lunity'
module( 'TestPoint', lunity )

function test_new ()
    local a = Point{x = 1, y = 2}
    assertType( a, 'Point' )
    assertTrue( a:isa 'Point' )
    assertInvokable( a.x )
    assertInvokable( a.y )
    assertType( a.x, 'function' )
    assertType( a.y, 'function' )
    assertType( a:x(), 'number')
    assertType( a:y(), 'number')
    assertEqual( a:x(), 1 )
    assertEqual( a:y(), 2 )
    assertEqual( tostring(a), "(1, 2)" )
end

function test_new_default ()
    local a = Point()
    assertType( a, 'Point' )
    assertType( a:x(), 'number')
    assertType( a:y(), 'number')
    assertEqual( a:x(), 0 )
    assertEqual( a:y(), 0 )
    assertEqual( tostring(a), "(0, 0)" )
end

function test_new_bad ()
    -- local a = Point{x = "x", y = "y"}
    assertErrors( Point, {x = "x", y = "y"} )
end

function test_mutator ()
    local a = Point()
    a:x( 1 )
    a:y( 2 )
    assertType( a:x(), 'number')
    assertType( a:y(), 'number')
    assertEqual( a:x(), 1 )
    assertEqual( a:y(), 2 )
    assertEqual( tostring(a), "(1, 2)" )
    assertErrors( a.x, a, "number expected" ) -- a:x( "number expected" )
end

function test_method ()
    local a = Point{x = 1, y = 2}
    assertType( a, 'Point' )
    assertInvokable( a.draw )
    assertTrue( a:can 'draw' )
    assertTrue( Point:can 'draw' )
    assertType( a.draw, 'function' )
    assertEqual( a:draw(), "drawing Point(1, 2)" )
end

runTests{ useANSI = false }
