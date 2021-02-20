pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Holder.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";

abstract contract B is ERC721Holder {
    function deposit(uint _tokenId) virtual external;
    function withdraw(uint _tokenId) virtual external;
}

contract A is ERC721Holder {
    

    IERC721 public token;
    B public contractB;
    
    constructor(address _token, address _contractB) public {
        token = IERC721(_token);
        contractB = B(_contractB);
    }
    
    // deposit to this contract with forwarding to contractB
    function deposit(uint _tokenId) external {
        // owner needs to approve contract A first on token
        token.safeTransferFrom(msg.sender, address(this),_tokenId);
        // approve Contract B
        token.approve(address(contractB), _tokenId);
        // contract B deposit
        contractB.deposit(_tokenId);
    }
    
    // withdraw from contracts
    function withdraw(uint _tokenId) external {
        contractB.withdraw(_tokenId);
        token.safeTransferFrom(address(this),msg.sender,_tokenId);
    }
    
}