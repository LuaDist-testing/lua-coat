#!/usr/bin/env lua

require 'Coat'

class 'Foo'

has.var = { is = 'rw', isa = 'number', default = 1 }

method.BUILD = function (self)
    self:var(2)
end

require 'Test.More'

plan(4)

foo = Foo.new{ var = 4 }
ok( foo:isa 'Foo', "Foo" )
is( foo:var(), 2 )

foo = Foo.new()
ok( foo:isa 'Foo', "Foo (default)" )
is( foo:var(), 2 )

