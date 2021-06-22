import pytest
from brownie import accounts, chain,web3, ZERO_ADDRESS



def test_distribucion(token, staking, accounts):


    token.burn(accounts[0], 1000e18, {'from':accounts[0]})
    token.transfer(accounts[1], 3000e18, {"from": accounts[0]})
    token.transfer(accounts[2], 3000e18, {"from": accounts[0]})
    assert token.balanceOf(accounts[0]) == 3000e18
    assert token.balanceOf(accounts[1]) == 3000e18
    assert token.balanceOf(accounts[2]) == 3000e18
    assert token.totalSupply() == 9000e18

def test_primer_stakeo(token, staking, accounts):

    staking._Staking(1500e18, {'from': accounts[0]})

    assert token.balanceOf(accounts[0]) == 1500e18
    assert token.totalSupply() == 7500e18

    chain.sleep(86400)


def test_segundo_stakeo_wallet2(token, staking, accounts):

    staking._Staking(3000e18, {'from': accounts[1]})

    assert token.balanceOf(accounts[0]) == 1500e18
    assert token.balanceOf(accounts[1]) == 0
    assert token.totalSupply() == 4500e18
    chain.sleep(432000)

def test_tercer_stakeo_wallet3(token, staking, accounts):

    staking._Staking(2000e18, {'from': accounts[2]})
    assert token.balanceOf(accounts[0]) == 1500e18
    assert token.balanceOf(accounts[1]) == 0
    assert token.balanceOf(accounts[2]) == 1000e18
    assert token.totalSupply() == 2500e18
    chain.sleep(864000)

def test_unstakeo(token, staking, accounts):
    staking._Unstaking({'from': accounts[0]})
    staking._Unstaking({'from': accounts[1]})
    staking._Unstaking({'from': accounts[2]})

    assert 3357e18 < token.balanceOf(accounts[0]) < 3359e18
    assert 3517e18 < token.balanceOf(accounts[1]) < 3518e18
    assert 3122e18 < token.balanceOf(accounts[2]) < 3124e18
    assert 9999e18 < token.totalSupply() <= 10000e18
