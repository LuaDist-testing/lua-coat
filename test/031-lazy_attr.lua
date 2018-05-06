#!/usr/bin/env lua

require 'Coat'

class 'A'
has.x = { isa = 'number', is = 'rw', lazy = true, default = 2 }
has.y = { isa = 'number', is = 'rw', default = 2 }

class 'Foo'
has.dir = { is = 'rw', isa = 'string' }
has.name = { is = 'rw', isa = 'string' }
has.path = { is = 'rw', isa = 'string', lazy = true,
    default = function (self)
        return self:dir() .. '/' .. self:name()
    end,
}


require 'lunity'
module( 'TestBuild', lunity )

function test_A ()
    local a = A.new()
    assertNil( a._VALUES.x )
    assertEqual( a._VALUES.y, 2 )
    assertEqual( a:x(), 2 )
end

function test_Bad ()
    assertErrors( function ()
        A.has.z = { isa = 'number', is = 'rw', lazy = true }
    end )
end

function test_Foo ()
    local foo = Foo.new{ dir = '/tmp', name = 'file' }
    assertTrue( foo:isa 'Foo' )
    assertEqual( foo:name() , 'file' )
    assertEqual( foo:path(), '/tmp/file' )
end


runTests{ useANSI = false }
