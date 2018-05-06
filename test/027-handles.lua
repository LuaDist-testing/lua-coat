#!/usr/bin/env lua

require 'Coat'

class 'Spanish'
has.uno = { is = 'ro', default = 1 }
has.dos = { is = 'ro', default = 2 }
has.nombre = { is = 'rw', isa = 'string' }

class 'English'
has.translate = {
    is = 'ro',
    default = function () return Spanish.new() end,
    handles = {
        one = 'uno',
        two = 'dos',
        name = 'nombre',
        bad = '_bad_',
    },
}


require 'lunity'
module( 'TestHandles', lunity )

function test_Spanish ()
    local foo = Spanish.new()
    assertInvokable( foo.uno )
    assertEqual( foo:uno(), 1 )
    assertInvokable( foo.dos )
    assertEqual( foo:dos(), 2 )
    assertInvokable( foo.nombre )
    assertEqual( foo:nombre( 'Juan' ), 'Juan' )
end

function test_English ()
    local foo = English.new()
    assertType( foo:translate(), 'Spanish' )
    assertInvokable( foo.one )
    assertEqual( foo:one(), 1 )
    assertInvokable( foo.two )
    assertEqual( foo:two(), 2 )
    assertInvokable( foo.name )
    assertEqual( foo:name( 'John' ), 'John' )
    assertInvokable( foo.bad )
    assertErrors( foo.bad, foo ) -- foo:bad()
end


runTests{ useANSI = false }
