import pytest



@pytest.fixture(scope='module')
def token(tokenPrueba, accounts):
    contract = tokenPrueba.deploy({'from': accounts[0]})
    return contract



@pytest.fixture(scope='module')
def staking(Staking, accounts, token):
    contract = Staking.deploy(token, {'from': accounts[0]})
    return contract


#@pytest.fixture()
#def isolate(fn_isolation):
#    pass
