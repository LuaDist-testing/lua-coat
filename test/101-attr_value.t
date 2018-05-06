#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.attr = { is = 'rw' }

require 'Test.More'

plan(4)

if os.getenv "GEN_PNG" and os.execute "dot -V" == 0 then
    local f = io.popen("dot -T png -o 101.png", 'w')
    f:write(require 'Coat.UML'.to_dot())
    f:close()
end

foo = Foo.new()
is( foo.attr, nil )
foo.attr = 2
is( foo.attr, 2 )
foo.attr = false
is( foo.attr, false )
foo.attr = nil
is( foo.attr, nil )

