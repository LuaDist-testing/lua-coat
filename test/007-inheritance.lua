#!/usr/bin/env lua

require 'Coat'

class 'Person'

has.name = { is = 'rw', isa = 'string' }
has.force = { is = 'rw', isa = 'number', default = 1 }

method.walk = function (self)
    return self:name() .. " walks\n"
end

class 'Soldier'

extends 'Person'

has.force = { '+', default = 3 }

method.attack = function (self)
    return self:force() + math.random( 10 )
end

class 'General'

extends 'Soldier'

has.force = { '+', default = 5 }

-- just to make sur we can hook something inherited
before.walk = function ()
    return 1
end

require 'lunity'
module( 'TestInheritance', lunity )

function test_Person ()
    local man = Person.new{ name = 'John' }
    assertTrue( man:isa 'Person' )
    assertTrue( man:isa(Person) )
    assertTrue( man:isa(man) )
    assertNotNil( Coat.Meta.has( Person, 'name' ) )
    assertNotNil( Coat.Meta.has( Person, 'force' ) )
    assertEqual( man:force(), 1 )
    assert( man:walk() )
end

function test_Soldier ()
    assertTrue( Soldier:isa 'Soldier' )
    assertTrue( Soldier:isa 'Person' )
    assertTrue( Soldier:isa(Person) )
    local man = Person.new()
    assertTrue( Soldier:isa(man) )

    local soldier = Soldier.new{ name = 'Dude' }
    assertTrue( soldier:isa 'Soldier' )
    assertTrue( soldier:isa 'Person' )
    assertTrue( soldier:isa(Person) )
    assertTrue( soldier:isa(man) )
    assertNotNil( Coat.Meta.has( Soldier, 'name' ) )
    assertNotNil( Coat.Meta.has( Soldier, 'force' ) )
    assertEqual( soldier:force(), 3 )
    assert( soldier:walk() )
    assert( soldier:attack() )
end

function test_General ()
    local general = General.new{ name = 'Smith' }
    assertTrue( general:isa 'General' )
    assertTrue( general:isa 'Soldier' )
    assertTrue( general:isa 'Person' )
    assertNotNil( Coat.Meta.has( General, 'name' ) )
    assertNotNil( Coat.Meta.has( General, 'force' ) )
    assertEqual( general:force(), 5 )
    assert( general:walk() )
    assert( general:attack() )
end


runTests{ useANSI = false }
