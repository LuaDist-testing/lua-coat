#!/usr/bin/env lua

require 'Coat.Types'

coerce.B = { A = function (val) return B{ x = 3 } end }

class 'A'
has.x = { is = 'rw', isa = 'number' }
has.b = { is = 'rw', isa = 'B', coerce = true }
has.c = { is = 'rw', isa = 'C' }

class 'B'
has.x = { is = 'rw', isa = 'number' }

class 'C'
has.x = { is = 'rw', isa = 'number' }

require 'Test.More'

plan(6)

if os.getenv "GEN_PNG" and os.execute "dot -V" == 0 then
    local f = io.popen("dot -T png -o 024.png", 'w')
    f:write(require 'Coat.UML'.to_dot())
    f:close()
end

a = A{ x = 1 }
b = B{ x = 2 }
ok( a:isa 'A' )
ok( b:isa 'B' )
a.b = b
is( a.b.x, 2 )
a.b = a
is( a.b.x, 3 ) -- coerced

error_like([[local a = A{ x = 1 }; a.c = A.new()]],
           "^[^:]+:%d+: Invalid type for attribute 'c' %(got A, expected C%)")

error_like([[local a = A{ x = 1 }; a.c = "text"]],
           "^[^:]+:%d+: Invalid type for attribute 'c' %(got string, expected C%)")

