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

require 'Test.More'

plan(17)

foo = Spanish.new()
ok( foo:isa "Spanish", "Spanish" )
ok( foo.uno )
is( foo:uno(), 1 )
ok( foo.dos )
is( foo:dos(), 2 )
ok( foo.nombre )
is( foo:nombre( 'Juan' ), 'Juan' )

foo = English.new()
ok( foo:isa 'English', "English" )
ok( foo:translate():isa 'Spanish')
ok( foo.one )
is( foo:one(), 1 )
ok( foo.two )
is( foo:two(), 2 )
ok( foo.name )
is( foo:name( 'John' ), 'John' )
ok( foo.bad )

error_like([[local foo = English.new(); foo:bad()]],
           "^[^:]+:%d+: Cannot delegate bad from translate %(_bad_%)")

