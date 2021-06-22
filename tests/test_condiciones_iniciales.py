import pytest
from brownie import accounts, chain,web3, ZERO_ADDRESS


def test_deployeo_token(token,accounts):

    assert token.balanceOf(accounts[0]) == 10000e18
    assert token.name() == "Token de Prueba"
    assert token.symbol() == "TKN1"
    assert token.totalSupply() == 10000e18


def test_staking(token, staking, accounts):
    timestamp = web3.eth.getBlock(web3.eth.blockNumber)['timestamp']
    assert staking.token() == token
    assert staking.inicio() == timestamp
    assert staking.rewards_per_second() == 1157*10**12
    assert staking.totalStaked() == 0

def test_primerstaking(token, staking, accounts):

    staking._Staking(5000e18, {'from': accounts[0]})
    assert token.balanceOf(accounts[0]) == 5000e18;
    assert staking.totalStaked() == 5000e18;
    assert staking.numberOfStakers() == 1;

def test_segundostakeo_primera_persona(token, staking, accounts):

    chain.sleep(86400)
    staking._Staking(5000e18, {'from': accounts[0]})
    assert token.balanceOf(accounts[0]) == 0;
    assert staking.totalStaked() == 10000e18;
    assert staking.numberOfStakers() == 1;
    assert staking.mapaStakeador().data[accounts[0]].value.stakedBalance == 10000e18
