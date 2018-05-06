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


require 'lunity'
module( 'TestTypeConstraints', lunity )

function test_Natural ()
    local factory = NumberFactory()
    assertEqual( factory:n(24), 24 )
    assertErrors( factory.n, factory, "text" ) -- factory:n( "text" )
    assertErrors( factory.n, factory, 0 ) -- factory:n(0)
end

function test_Float ()
    local factory = NumberFactory()
    assertEqual( factory:f(2.0), 2.0 )
    assertErrors( factory.f, factory, "text" ) -- factory:f( "text" )
end

function test_Month ()
    local factory = NumberFactory()
    assertEqual( factory:month(1), 1 )
    assertEqual( factory:month(12), 12 )
    assertErrors( factory.month, factory, 0 ) -- factory:month(0)
    assertErrors( factory.month, factory, 14 ) -- factory:month(14)
end

function test_WinterMonth ()
    local factory = NumberFactory()
    assertEqual( factory:winter(12), 12 )
    assertErrors( factory.winter, factory, 0 ) -- factory:winter(0)
    assertErrors( factory.winter, factory, 14 ) -- factory:winter(14)
    assertErrors( factory.winter, factory, 8 ) -- factory:winter(8)
end

function test_Colour ()
    local factory = NumberFactory()
    assertEqual( factory:col( 'Red' ), 'Red' )
    assertEqual( factory:col( 'Green' ), 'Green' )
    assertEqual( factory:col( 'Blue' ), 'Blue' )
    assertErrors( factory.col, factory, 'Yellow' ) -- factory:col( 'Yellow' )
    assertErrors( factory.col, factory, 'Blu' ) -- factory:col( 'Blu' )
end


runTests{ useANSI = false }
