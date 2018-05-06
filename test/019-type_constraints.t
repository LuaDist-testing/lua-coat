#!/usr/bin/env lua

require 'Coat'
require 'Coat.Types'

class 'NumberFactory'

subtype.Natural = {
    as = 'number',
    where = function (n) return n > 0 end,
    message = "%d is not a Natural number",
}

subtype.Month = {
    as = 'Natural',
    where = function (n) return n <= 12 end,
    message = "%d is not a month"
}

subtype.WinterMonth = {
    as = 'Month',
    where = function (n) return n >= 10 end,
    message = "%d is not a month of winter"
}

enum.Colour = { 'Red', 'Green', 'Blue' }

has.n = { is = 'rw', isa = 'Natural' }
has.f = { is = 'rw', isa = 'number' }
has.month = { is = 'rw', isa = 'Month' }
has.winter = { is = 'rw', isa = 'WinterMonth' }
has.col = { is = 'rw', isa = 'Colour' }

require 'Test.More'

plan(18)

if os.getenv "GEN_PNG" and os.execute "dot -V" == 0 then
    local f = io.popen("dot -T png -o 019.png", 'w')
    f:write(require 'Coat.UML'.to_dot())
    f:close()
end

factory = NumberFactory()
factory.n = 24
is( factory.n , 24, "Natural" )
error_like([[local factory = NumberFactory(); factory.n = "text"]],
           "^[^:]+:%d+: Invalid type for attribute 'n' %(got string, expected number%)")
error_like([[local factory = NumberFactory(); factory.n = 0]],
           "^[^:]+:%d+: 0 is not a Natural number")

factory.f = 2.0
is( factory.f, 2.0, "Float" )
error_like([[local factory = NumberFactory(); factory.f = "text"]],
           "^[^:]+:%d+: Invalid type for attribute 'f' %(got string, expected number%)")

factory.month = 1
is( factory.month, 1, "Month" )
factory.month = 12
is( factory.month, 12 )
error_like([[local factory = NumberFactory(); factory.month = 0]],
           "^[^:]+:%d+: 0 is not a Natural number")
error_like([[local factory = NumberFactory(); factory.month = 14]],
           "^[^:]+:%d+: 14 is not a month")

factory.winter = 12
is( factory.winter, 12, "WinterMonth" )
error_like([[local factory = NumberFactory(); factory.winter = 0]],
           "^[^:]+:%d+: 0 is not a Natural number")
error_like([[local factory = NumberFactory(); factory.winter = 14]],
           "^[^:]+:%d+: 14 is not a month")
error_like([[local factory = NumberFactory(); factory.winter = 8]],
           "^[^:]+:%d+: 8 is not a month of winter")

factory.col = 'Red'
is( factory.col, 'Red', "Colour" )
factory.col = 'Green'
is( factory.col, 'Green' )
factory.col = 'Blue'
is( factory.col, 'Blue' )
error_like([[local factory = NumberFactory(); factory.col = 'Yellow']],
           "^[^:]+:%d+: Value for attribute 'col' does not validate type constraint 'Colour'")
error_like([[local factory = NumberFactory(); factory.col = 'Blu']],
           "^[^:]+:%d+: Value for attribute 'col' does not validate type constraint 'Colour'")

