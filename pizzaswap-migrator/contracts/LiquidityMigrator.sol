pragma solidity =0.6.6;
import "./token/BEP20/IBEP20.sol";
import "./IPancakePair.sol";
import "./IPancakeRouter02.sol";
import "./PotatoeToken.sol";

contract LiquidityMigrator {
    IPancakeRouter02 public router;
    IPancakePair public pair;
    IPancakeRouter02 public routerFork;
    IPancakePair public pairFork;
    PotatoeToken public potatoeToken;
    address public admin;
    mapping(address => uint256) public unclaimedBalances;
    bool public migrationDone;

    constructor(
        address _router,
        address _pair,
        address _routerFork,
        address _pairFork,
        address _potatoeToken
    ) public {
        router = IPancakeRouter02(_router);
        pair = IPancakePair(_pair);
        routerFork = IPancakeRouter02(_routerFork);
        pairFork = IPancakePair(_pairFork);
        potatoeToken = PotatoeToken(_potatoeToken);
        admin = msg.sender;
    }

    function deposit(uint256 amount) external {
        require(migrationDone == false, "Migration already done");
        pair.transferFrom(msg.sender, address(this), amount);
        potatoeToken.mint(msg.sender, amount);
        unclaimedBalances[msg.sender] += amount;
    }

    function migrate() external {
        require(msg.sender == admin, "only admin");
        require(migrationDone == false, "migration already done");
        IBEP20 token0 = IBEP20(pair.token0());
        IBEP20 token1 = IBEP20(pair.token1());
        uint256 totalBalance = pair.balanceOf(address(this));
        // tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline
        router.removeLiquidity(
            address(token0),
            address(token1),
            totalBalance,
            0,
            0,
            address(this),
            block.timestamp
        );
        uint256 token0Balance = token0.balanceOf(address(this));
        uint256 token1Balance = token1.balanceOf(address(this));
        token0.approve(address(routerFork), token0Balance);
        token1.approve(address(routerFork), token1Balance);

        // routerFork.addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin, to, deadline);
        routerFork.addLiquidity(
            address(token0),
            address(token1),
            token0Balance,
            token1Balance,
            token0Balance,
            token1Balance,
            address(this),
            block.timestamp
        );
        migrationDone = true;
    }

    function claimLpTokens() external {
        require(unclaimedBalances[msg.sender] >= 0, "no unclaimed balance");
        require(migrationDone == true, "migration not done yet");
        uint256 amountToSend = unclaimedBalances[msg.sender];
        unclaimedBalances[msg.sender] = 0;
        pairFork.transfer(msg.sender, amountToSend);
    }
}
