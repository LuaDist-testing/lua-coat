#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.read = { is = 'ro', default = 2, isa = 'number' }
has.write = { is = 'rw', default = 3, isa = 'number' }

require 'Test.More'

plan(10)

if os.getenv "GEN_PNG" and os.execute "dot -V" == 0 then
    local f = io.popen("dot -T png -o 014.png", 'w')
    f:write(require 'Coat.UML'.to_dot())
    f:close()
end

foo = Foo.new{ read = 4, write = 5 }
is( foo.read, 4, "Foo" )
is( foo.write, 5 )
foo.write = 7
is( foo.write, 7 )

error_like([[local foo = Foo.new{ read = 4, write = 5 }; foo.read = 5]],
           "^[^:]+:%d+: Cannot set a read%-only attribute %(read%)")

foo = Foo.new()
is( foo.read, 2, "Foo (default)" )
is( foo.write, 3 )
foo.write = 7
is( foo.write, 7 )

error_like([[local foo = Foo.new(); foo.read = 5]],
           "^[^:]+:%d+: Cannot set a read%-only attribute %(read%)")

error_like([[local foo = Foo.new(); foo.bad = 5]],
           "^[^:]+:%d+: Cannot set 'bad' %(unknown%)")

is( foo.bad, nil )

