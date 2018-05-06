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


require 'lunity'
module( 'TestRoleAttrBuilder', lunity )

function test_Red ()
    local c = Red.new()
    assertTrue( c:isa 'Red' )
    assertEqual( c:color(), 'red' )
end

function test_Blue ()
    local c = Blue.new()
    assertTrue( c:isa 'Blue' )
    assertEqual( c:color(), 'blue' )
end


runTests{ useANSI = false }
