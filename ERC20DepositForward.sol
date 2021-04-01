pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/IERC20.sol";

abstract contract B {
    function deposit(uint _amount) virtual external; // its implementation must call transferFrom()
    function withdraw(uint _amount) virtual external;
}

contract A {
    IERC20 public token;
    B public contractB;
    
    constructor(address _token, address _contractB) public {
        token = IERC20(_token);
        contractB = B(_contractB);
    }
    
    // deposit to this contract with forwarding to a contractB
    function deposit(uint _amount) external {
        // owner needs to approve contract A first on token
        token.transferFrom(msg.sender, address(this), _amount);
        // approve Contract B
        token.approve(address(contractB), _amount);
        // contract B deposit
        contractB.deposit(_amount);
    }
    
    // withdraw from contracts
    function withdraw(uint _amount) external {
        contractB.withdraw(_amount);
        token.transfer(msg.sender, _amount);
    }
    
}
