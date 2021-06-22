pragma solidity >=0.8.0;


import "./TokenERC20.sol";
import "../interfaces/ERC20.sol";
import "../interfaces/IterableMapping.sol";

contract Staking {


  uint256 public inicio;
  uint256 public totalStaked;
  uint256 public rewards_per_second;
  uint256 public deadline;
  tokenPrueba public token;
  uint256 public numberOfStakers;
  itmap mapaStakeador;

  using IterableMapping for itmap;


  constructor(address StakingToken) public {
    token = tokenPrueba(StakingToken);
    inicio = block.timestamp;
    deadline = inicio + 864000;
    rewards_per_second = 1157*10**12;

  }

  function _Unstaking() external {
    require (block.timestamp > deadline, 'Staking is not over yet');
    distributeRewardsOnlyOnePerson(msg.sender);
    uint tokensOriginales = mapaStakeador.data[msg.sender].value.stakedBalance;
    uint tokenRewards = mapaStakeador.data[msg.sender].value.rewards;

    token.mint(msg.sender, tokenRewards + tokensOriginales );
    
  }

  function _Staking(uint256 tokenAmount) external {

    require (block.timestamp < deadline, 'Staking out of time');
    distributeRewards();

    if (mapaStakeador.contains(msg.sender)){
      mapaStakeador.data[msg.sender].value.stakedBalance += tokenAmount;
      token.burn(msg.sender, tokenAmount);
      totalStaked += tokenAmount;

    }
    else {
      datosStaker memory temp = datosStaker({stakedBalance: tokenAmount, timestamp: block.timestamp, rewards: 0});
      numberOfStakers = insertStaker(msg.sender, temp);
      token.burn(msg.sender, tokenAmount);
      totalStaked += tokenAmount;
    }


  }
  function distributeRewardsOnlyOnePerson(address _staker) internal {
    datosStaker storage datos = mapaStakeador.data[_staker].value;
    uint256 rewards_extras = _calcularPorcentaje(datos, deadline);
    datos.rewards += rewards_extras;
  }

  function distributeRewards() internal {
    for (uint i = mapaStakeador.iterate_start(); mapaStakeador.iterate_valid(i); i = mapaStakeador.iterate_next(i+1)){
      (address direccionStaker, datosStaker storage datos_del_Staker) = mapaStakeador.iterate_get(i);

      uint256 rewards_calculados = _calcularPorcentaje(datos_del_Staker, block.timestamp);
      datos_del_Staker.rewards += rewards_calculados;
      datos_del_Staker.timestamp = block.timestamp;
    }
  }

  function _calcularPorcentaje(datosStaker memory estakeador, uint256 tiempo) internal view returns (uint256){
    uint256 stake = estakeador.stakedBalance;
    uint256 tokens_antes_de_aplicar_porcentaje = rewards_per_second*(tiempo-estakeador.timestamp);
    uint256 _rewards = tokens_antes_de_aplicar_porcentaje*stake/totalStaked;
    return _rewards;

  }

  function insertStaker(address _staker, datosStaker memory datos_Staker) internal returns (uint size){

    mapaStakeador.insert(_staker, datos_Staker);
    return mapaStakeador.size;

  }

}
