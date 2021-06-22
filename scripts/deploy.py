from brownie import erc20, accounts


def main():
    acct = accounts.load('11')
    return erc20.deploy("Prueba2","P2", 18, 1e4, {'from': acct})
