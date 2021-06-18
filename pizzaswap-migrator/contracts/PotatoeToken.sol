pragma solidity =0.6.6;

import "./token/BEP20/BEP20.sol";

contract PotatoeToken is BEP20 {
    address public admin;
    address public liquidator;

    constructor() public BEP20("Potatoe Token", "PTO") {
        admin = msg.sender;
    }

    function setLiquidator(address _liquidator) external {
        require(msg.sender == admin, "only admin");
        liquidator = _liquidator;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == liquidator, "only liquidator");
        _mint(to, amount);
    }
}
