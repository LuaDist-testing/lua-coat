#!/usr/bin/env lua

require 'Coat'

class 'A'

has.id = {
    is = 'ro',
    required = true,
    isa = 'number',
}
has.buffer = {
    is = 'ro',
    default = function () return {} end,
}

method.BUILD = function (self)
    table.insert( self:buffer(), "BUILD A" )
end
method.DEMOLISH = function (self)
    _G.REG.A[self:id()] = self:buffer()
end

class 'B'
extends 'A'

after.BUILD = function (self)
    table.insert( self:buffer(), "BUILD B" )
end
before.DEMOLISH = function (self)
    _G.REG.B[self:id()] = self:buffer()
end


require 'Test.More'

plan(8)

_G.REG = {}

expected = { "BUILD A" }
_G.REG.A = {}
a = A{ id = 1 }
ok( a:isa 'A', "A" )
eq_array( a:buffer(), expected )
a:__gc()  -- manual
a = nil
-- collectgarbage 'collect'
eq_array( _G.REG.A[1], expected )

expected = { "BUILD A", "BUILD B" }
_G.REG.A = {}
_G.REG.B = {}
b = B{ id = 2 }
ok( b:isa 'B', "B" )
ok( b:isa 'A' )
eq_array( b:buffer(), expected )
b:__gc()  -- manual
b = nil
-- collectgarbage 'collect'
eq_array( _G.REG.B[2], expected )
eq_array( _G.REG.A[2], expected )

