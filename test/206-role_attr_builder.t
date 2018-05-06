#!/usr/bin/env lua

require 'Coat.Role'

role 'HasColor'
requires '_build_color'

has.color = { is = 'ro', isa = 'string', lazy = true, builder = '_build_color' }

class 'Red'
with 'HasColor'

method._build_color = function ()
    return 'red'
end

class 'Blue'
with 'HasColor'

method._build_color = function ()
    return 'blue'
end


require 'Test.More'

plan(4)

c = Red.new()
ok( c:isa 'Red', "Red" )
is( c:color(), 'red' )

c = Blue.new()
ok( c:isa 'Blue', "Blue" )
is( c:color(), 'blue' )

