from brownie import accounts, staking2


def main():
    acct = accounts.load('11')
    staking2.deploy('0x85e44b023E30D5500C9001c167F61baA3bCc8E61', {'from': acct})
