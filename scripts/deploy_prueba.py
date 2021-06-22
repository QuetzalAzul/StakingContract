from brownie import accounts, staking_contract


def main():
    acct = accounts.load('11')
    staking_contract.deploy({'from': acct})
