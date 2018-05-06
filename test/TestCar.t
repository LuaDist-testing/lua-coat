#!/usr/bin/env lua

require 'Test.More'

plan(7)

if not require_ok 'Car' then
    skip_rest "no lib"
    os.exit()
end

car = Car.new()
ok( car:isa 'Car', "isa" )
ok( car:does 'Breakable', "does" )
is( car:is_broken(), nil )
ok( car:can '_break', "can" )
is( car:_break(), "I broke" )
is( car:is_broken(), true )
