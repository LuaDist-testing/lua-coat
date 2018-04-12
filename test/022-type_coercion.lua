#!/usr/bin/env lua

require 'Coat'
require 'Coat.Types'

subtype.DateTime = {
    as = 'string',
    where = function (val) return true end
}

coerce.DateTime = {
    number = function (val) return os.date("!%d/%m/%Y %H:%M:%S", val) end
}

class 'Record'

has.timestamp = { is = 'ro', isa = 'DateTime', required = true, coerce = true }

require 'lunity'
module( 'TestTypeCoercion', lunity )

function test_Direct ()
    local foo = Record{ timestamp = 'now' }
    assertTrue( foo:isa 'Record' )
    assertEqual( foo:timestamp(), 'now' )
end

function test_Coercion ()
    local foo = Record{ timestamp = 0 }
    assertTrue( foo:isa 'Record' )
    assertEqual( foo:timestamp(), '01/01/1970 00:00:00' )
end

function test_NoCoercion ()
    assertErrors( Record.new, { timestamp = true } ) -- Record{ timestamp = true }
end


runTests{ useANSI = false }
