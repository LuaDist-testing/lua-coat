#!/usr/bin/env lua

require 'Coat'

class 'Parent'

method.orig = function (self, ...)
    local val = ...
    table.insert( _G.seen, 'orig : ' .. val )
end

class 'Child'
extends 'Parent'

around.orig = function (self, func, ...)
    local val = ...
    table.insert( _G.seen, 'around 1 before : ' .. val)
    func(self, ...)
    table.insert( _G.seen, 'around 1 after' )
end

around.orig = function (self, func, ...)
    local val = ...
    table.insert( _G.seen, 'around 2 before : ' .. val)
    func(self, ...)
    table.insert( _G.seen, 'around 2 after' )
end

require 'lunity'
module( 'TestMultipleAround', lunity )

function setup ()
    _G.seen = {}
end

function test_Simple ()
    local p = Parent.new()
    assertTrue( p:isa 'Parent' )
    assertInvokable( p.orig )
    p:orig 'val'
    assertTableEquals( _G.seen, { 'orig : val' } )
end

function test_MultipleAround ()
    local c = Child.new()
    assertTrue( c:isa 'Child' )
    assertTrue( c:isa 'Parent' )
    assertInvokable( c.orig )
    c:orig 'val'
    assertTableEquals( _G.seen, {
        'around 2 before : val',
                'around 1 before : val',
                        'orig : val',
                'around 1 after',
        'around 2 after',
    } )
end


runTests{ useANSI = false }
