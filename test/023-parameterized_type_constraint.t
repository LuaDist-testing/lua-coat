#!/usr/bin/env lua

require 'Coat'
require 'Coat.Types'

class 'A'

has.array_of_str = { is = 'rw', isa = 'table<string>' }
has.hash_of_a = { is = 'rw', isa = 'table<string,A>' }
has.hash_of_num = { is = 'rw', isa = 'table<string,number>' }
has.many_a = { is = 'rw', isa = 'table<A>' }

class 'B'

has.x = { is = 'rw', isa = 'number' }

require 'Test.More'

plan(11)

if os.getenv "GEN_PNG" and os.execute "dot -V" == 0 then
    local f = io.popen("dot -T png -o 023.png", 'w')
    f:write(require 'Coat.UML'.to_dot())
    f:close()
end

a = A()
ok( a:isa 'A' )

many_a = {}
for _ = 1, 10 do table.insert(many_a, A() ) end
many_b = {}
for _ = 1, 10 do table.insert(many_b, B() ) end

lives_ok( function () a.many_a = many_a end, "array of objects A accepted" )

error_like(function () a.many_a = many_b end,
           "^[^:]+:%d+: Value for attribute 'many_a' does not validate type constraint 'table<A>'",
           "array of objects B refused")

lives_ok( function () a.hash_of_a = { one = A(), two = A() } end, "hash of A accepted" )

error_like(function () a.hash_of_a = { one = A(), two = B() } end,
           "^[^:]+:%d+: Value for attribute 'hash_of_a' does not validate type constraint 'table<string,A>'",
           "Hash of mixed A and B objects refused")

error_like(function () a.hash_of_a = 123 end,
           "^[^:]+:%d+: Invalid type for attribute 'hash_of_a' %(got number, expected table%)",
           "value refused : not a table")

lives_ok(function () a.hash_of_num = { one = 1, two = 2, three = 3 } end, "hash of Num accepted" )

error_like(function () a.hash_of_num = { one = 1, two = 2, three = 'foo' } end,
           "^[^:]+:%d+: Value for attribute 'hash_of_num' does not validate type constraint 'table<string,number>'",
           "hash mixed of num and str refused")

lives_ok( function () a.array_of_str = { 'Foo', 'Bar', 'Baz' } end, "array_of_str accepted" )

error_like(function () a.array_of_str = 23 end,
           "^[^:]+:%d+: Invalid type for attribute 'array_of_str' %(got number, expected table%)",
           "array_of_str refused : not a table")

error_like(function () a.array_of_str = { 23, 'Foo' } end,
           "^[^:]+:%d+: Value for attribute 'array_of_str' does not validate type constraint 'table<string>'",
           "mixed array refused")

