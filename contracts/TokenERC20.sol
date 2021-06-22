pragma solidity >=0.8.0;

import 'interfaces/ERC20.sol';

contract tokenPrueba is ERC20("Token de Prueba", "TKN1"){

  constructor () public {
    _mint(msg.sender, 10000 ether);
  }

  function burn(address account, uint256 amount) external {
    _burn(account, amount);
  }

  function mint(address account, uint256 amount) external {
    _mint(account, amount);
  }


}
