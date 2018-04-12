#!/usr/bin/env lua

require 'CheckingAccount'
require 'lunity'
module( 'TestCheckingAccount', lunity )

function test_BankAccount ()
    local savings_account = BankAccount{ balance = 250 }
    assertTrue( savings_account:isa 'BankAccount' )
    assertEqual( savings_account:balance(), 250 )
    savings_account:withdraw( 50 )
    assertEqual( savings_account:balance(), 200 )
    savings_account:deposit( 150 )
    assertEqual( savings_account:balance(), 350 )
end

function test_CheckingAccount ()
    local savings_account = BankAccount{ balance = 350 }
    local checking_account = CheckingAccount{ balance = 100, overdraft_account = savings_account }
    assertTrue( checking_account:isa 'CheckingAccount' )
    assertTrue( checking_account:isa 'BankAccount' )
    assertEqual( checking_account:overdraft_account(), savings_account )
    assertEqual( checking_account:balance(), 100 )
    checking_account:withdraw(50)
    assertEqual( checking_account:balance(), 50 )
    assertEqual( savings_account:balance(), 350 )
    checking_account:withdraw(200)
    assertEqual( checking_account:balance(), 0 )
    assertEqual( savings_account:balance(), 200 )
end

function test_CheckingAccountSimple ()
    local checking_account = CheckingAccount{ balance = 100 }
    assertTrue( checking_account:isa 'CheckingAccount' )
    assertTrue( checking_account:isa 'BankAccount' )
    assertNil( checking_account:overdraft_account() )
    assertEqual( checking_account:balance(), 100 )
    assertEqual( checking_account:balance(), 100 )
    checking_account:withdraw(50)
    assertEqual( checking_account:balance(), 50 )
    assertErrors( checking_account.withdraw, checking_account, 200 ) -- checking_account:withdraw(200)
    assertEqual( checking_account:balance(), 50 )
end


runTests{ useANSI = false }
