-- This file was automatically generated for the LuaDist project.

package = 'lua-Coat'
version = '0.9.2-1'
-- LuaDist source
source = {
  tag = "0.9.2-1",
  url = "git://github.com/LuaDist-testing/lua-coat.git"
}
-- Original source
-- source = {
--     url = 'http://github.com/fperrad/lua-Coat/raw/releases/lua-coat-0.9.2.tar.gz',
--     md5 = '4a409bb83b809d6324cb5e6df3ac0a54',
--     dir = 'lua-Coat-0.9.2',
-- }
description = {
    summary = "Yet Another Lua Object-Oriented Model",
    detailed = [[
        lua-Coat is a Lua 5.1 port of Coat (http://www.sukria.net/perl/coat/),
        a Perl5 module which mimics Moose (http://www.iinteractive.com/moose/),
        an object system for Perl5 which borrows features from Perl6,
        CLOS (LISP), Smalltalk and many other languages.
    ]],
    homepage = 'http://fperrad.github.io/lua-Coat/',
    maintainer = 'Francois Perrad',
    license = 'MIT/X11'
}
dependencies = {
    'lua >= 5.1',
    'lua-testmore >= 0.2.3',
}
build = {
    type = 'builtin',
    modules = {
        ['Coat']                = 'src/Coat.lua',
        ['Coat.Meta.Class']     = 'src/Coat/Meta/Class.lua',
        ['Coat.Meta.Role']      = 'src/Coat/Meta/Role.lua',
        ['Coat.Role']           = 'src/Coat/Role.lua',
        ['Coat.Types']          = 'src/Coat/Types.lua',
        ['Coat.UML']            = 'src/Coat/UML.lua',
        ['Coat.file']           = 'src/Coat/file.lua',
    },
    install = {
        bin = { 'src/coat2dot' }
    },
    copy_directories = { 'docs', 'test' },
}