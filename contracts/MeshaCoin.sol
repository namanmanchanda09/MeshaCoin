// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MeshaCoin is ERC20{
    
    address public owner;
    uint256 public _initialSupply = 100;
    uint256 public _fixedSupply = 1000;

    constructor() ERC20("MeshaCoin","MCN"){
        owner=msg.sender;
        _mint(owner,_initialSupply);
    }
    
    modifier onlyOwner(){
        require(msg.sender==owner,"You are not allowed to call this function");
        _;
    }
    
    function mint(uint256 _amount) public onlyOwner{
        require(_fixedSupply >= (totalSupply()+_amount),"The fixed supply");
        _mint(msg.sender, _amount);
    }
}

