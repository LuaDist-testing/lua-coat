#!/usr/bin/env lua

require 'Coat.Role'

role 'Breakable'

has.is_broken = { is = 'rw', isa = 'boolean', default = false }

function method:_break ()
    self.is_broken = true
end

role 'Breakdancer'

function method:_break ()
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

function method:_break ()
    print "I broke"
end


require 'Test.More'

plan(7)

if os.getenv "GEN_PNG" and os.execute "dot -V" == 0 then
    local f = io.popen("dot -T png -o 204.png", 'w')
    f:write(require 'Coat.UML'.to_dot())
    f:close()
end

man = FragileDancer.new()
ok( man:isa 'FragileDancer', "FragileDancer" )
ok( man:does 'Breakable' )
ok( man:does 'Breakdancer' )
is( man.is_broken, false )
ok( man.break_bone )
ok( man.break_dance )
ok( man._break )

