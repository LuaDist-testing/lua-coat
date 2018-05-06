#!/usr/bin/env lua

require 'Coat.Role'

role 'Breakable'

has.is_broken = { is = 'rw', isa = 'boolean' }

method._break = function (self)
    self:is_broken(true)
end

role 'Breakdancer'

method._break = function (self)
    self:is_broken(true)
    print "break dance"
end

class 'FragileDancer'
with( 'Breakable', {
                alias = { _break = 'break_bone' },
                excludes = '_break',
      },
      'Breakdancer', {
                alias = { _break = 'break_dance' },
                excludes = '_break',
      } )

method._break = function (self)
    print "I broke"
end


require 'lunity'
module( 'TestRoleAlias', lunity )

function test_FragileDancer ()
    local man = FragileDancer.new()
    assertTrue( man:isa 'FragileDancer' )
    assertTrue( man:does 'Breakable' )
    assertTrue( man:does 'Breakdancer' )
    assertInvokable( man.break_bone )
    assertInvokable( man.break_dance )
    assertInvokable( man._break )
end


runTests{ useANSI = false }
