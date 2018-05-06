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

factory = NumberFactory()
is( factory:n(24), 24, "Natural" )
error_like([[local factory = NumberFactory(); factory:n( "text" )]],
           "^[^:]+:%d+: Invalid type for attribute 'n' %(got string, expected number%)")
error_like([[local factory = NumberFactory(); factory:n(0)]],
           "^[^:]+:%d+: 0 is not a Natural number")

is( factory:f(2.0), 2.0, "Float" )
error_like([[local factory = NumberFactory(); factory:f( "text" )]],
           "^[^:]+:%d+: Invalid type for attribute 'f' %(got string, expected number%)")

is( factory:month(1), 1, "Month" )
is( factory:month(12), 12 )
error_like([[local factory = NumberFactory(); factory:month(0)]],
           "^[^:]+:%d+: 0 is not a Natural number")
error_like([[local factory = NumberFactory(); factory:month(14)]],
           "^[^:]+:%d+: 14 is not a month")

is( factory:winter(12), 12, "WinterMonth" )
error_like([[local factory = NumberFactory(); factory:winter(0)]],
           "^[^:]+:%d+: 0 is not a Natural number")
error_like([[local factory = NumberFactory(); factory:winter(14)]],
           "^[^:]+:%d+: 14 is not a month")
error_like([[local factory = NumberFactory(); factory:winter(8)]],
           "^[^:]+:%d+: 8 is not a month of winter")

is( factory:col( 'Red' ), 'Red', "Colour" )
is( factory:col( 'Green' ), 'Green' )
is( factory:col( 'Blue' ), 'Blue' )
error_like([[local factory = NumberFactory(); factory:col( 'Yellow' )]],
           "^[^:]+:%d+: Value for attribute 'col' does not validate type constraint 'Colour'")
error_like([[local factory = NumberFactory(); factory:col( 'Blu' )]],
           "^[^:]+:%d+: Value for attribute 'col' does not validate type constraint 'Colour'")

