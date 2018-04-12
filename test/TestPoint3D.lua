#!/usr/bin/env lua

require 'Point3D'
require 'lunity'
module( 'TestPoint3D', lunity )

function test_new ()
    local a = Point3D{x = 1, y = 2, z = 3}
    assertType( a, 'Point3D' )
    assertTrue( a:isa 'Point3D' )
    assertTrue( a:isa 'Point' )
    assertType( a:x(), 'number')
    assertType( a:y(), 'number')
    assertType( a:z(), 'number')
    assertEqual( a:x(), 1 )
    assertEqual( a:y(), 2 )
    assertEqual( a:z(), 3 )
    assertEqual( tostring(a), "(1, 2, 3)" )
end

function test_new_default ()
    local a = Point3D()
    assertType( a, 'Point3D' )
    assertType( a:x(), 'number')
    assertType( a:y(), 'number')
    assertType( a:z(), 'number')
    assertEqual( a:x(), 0 )
    assertEqual( a:y(), 0 )
    assertEqual( a:z(), 0 )
    assertEqual( tostring(a), "(0, 0, 0)" )
end

function test_new_bad ()
    -- local a = Point3D{x = "x", y = "y", z = "z"}
    assertErrors( Point3D, {x = "x", y = "y", z = "z"} )
end

function test_mutator ()
    local a = Point3D()
    a:x( 1 )
    a:y( 2 )
    a:z( 3 )
    assertType( a:x(), 'number')
    assertType( a:y(), 'number')
    assertType( a:z(), 'number')
    assertEqual( a:x(), 1 )
    assertEqual( a:y(), 2 )
    assertEqual( a:z(), 3 )
    assertEqual( tostring(a), "(1, 2, 3)" )
end

function test_method ()
    local a = Point3D{x = 1, y = 2, z = 3}
    assertType( a, 'Point3D' )
    assertInvokable( a.draw )
    assertTrue( a:can 'draw' )
    assertTrue( Point:can 'draw' )
    assertType( a.draw, 'function' )
    assertEqual( a:draw(), "drawing Point3D(1, 2, 3)" )
end

runTests{ useANSI = false }
