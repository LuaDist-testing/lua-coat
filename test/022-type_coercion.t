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

require 'Test.More'

plan(5)

foo = Record{ timestamp = 'now' }
ok( foo:isa 'Record', "direct" )
is( foo:timestamp(), 'now' )

foo = Record{ timestamp = 0 }
ok( foo:isa 'Record', "coercion" )
is( foo:timestamp(), '01/01/1970 00:00:00' )

error_like([[foo = Record{ timestamp = true }]],
           "^[^:]+:%d+: Invalid type for attribute 'timestamp' %(got boolean, expected string%)",
           "no coercion")

