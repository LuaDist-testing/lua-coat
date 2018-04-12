#!/usr/bin/env lua

require 'lunity'
module( 'TestRequire', lunity )

function test_require ()
    local m = require 'Coat'
    assertType( m, 'table' )
    assertEqual( m, Coat )
    assertEqual( m, package.loaded.Coat )
    assertNotNil( m._COPYRIGHT:match 'Perrad' )
    assertNotNil( Coat._DESCRIPTION:match 'Lua' )
    assertType( m._VERSION, 'string' )
    assertNotNil( m._VERSION:match '^%d%.%d%.%d$' )
end

function test_ns_pollution ()
    require 'Coat'
    assertNil( Coat.math )
end

function test_type ()
    require 'Coat'
    assertType( nil, 'nil' )
    assertType( 3.14, 'number' )
    assertType( "text", 'string' )
    assertType( false, 'boolean' )
    assertType( {}, 'table' )
    assertType( function () return true end, 'function' )
end

function test_type_ro_table ()
    require 'Coat'
    local t = { x=1 }
    assertType( t, 'table')
    setmetatable( t, { __index = function() error "read only" end } )
    assertType( t, 'table')
end


runTests{ useANSI = false }
