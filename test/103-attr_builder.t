#!/usr/bin/env lua

require 'Coat'

class 'Car'

has.engine = { is = 'ro', isa = 'string', lazy = true, builder = '_build_engine' }

function method._build_engine ()
    return "Engine"
end

class 'SpecialCar'
extends 'Car'

function override._build_engine ()
    return "SpecialEngine"
end

require 'Test.More'

plan(5)

if os.getenv "GEN_PNG" and os.execute "dot -V" == 0 then
    local f = io.popen("dot -T png -o 103.png", 'w')
    f:write(require 'Coat.UML'.to_dot())
    f:close()
end

car = Car.new()
ok( car:isa 'Car', "Car" )
is( car.engine, 'Engine' )

car = SpecialCar.new()
ok( car:isa 'SpecialCar', "SpecialCar" )
ok( car:isa 'Car' )
is( car.engine, 'SpecialEngine' )

