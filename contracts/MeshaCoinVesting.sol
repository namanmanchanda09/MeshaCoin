// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MeshaCoin.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MeshaCoinVesting{
    
    using SafeMath for uint256;

    uint duration = 365 days; // 1-vesting cycle
    uint public vestingPeriod = duration.mul(4); // total vesting period
    
    uint public start; // block timestamp during deployment 
    
    uint public released; // total vested value released to beneficiary
    
    address public beneficiary; // Beneficiary address
    
    MeshaCoin public token = new MeshaCoin(); // Token instance
    
    /*
    *The constructor sets the beneficiary address who'll receive the vested tokens as well as the start time.
    *It also mints the initial supply of tokens to the current contract.
    */
    constructor(address _beneficiary){
        beneficiary = _beneficiary;
        start = block.timestamp;
        token.mint(token._fixedSupply() - token._initialSupply());
    }
    
    modifier onlyBeneficiary(){
        require(msg.sender == beneficiary,"You are not allowed to call this.");
        _;
    }
    
    /*
    *Returns the name of the Token
    */
    function getName() public view returns(string memory){
        return token.name();
    }
    
    /*
    *Returns the token balance of the MeshaCoinVesting contract
    */
    function getBalance() public view returns(uint){
        uint balance = token.balanceOf(address(this));
        return balance;
    }
    
    /*
    *Returns the symbol of the Token
    */
    function getSymbol() public view returns(string memory){
        string memory symbol = token.symbol();
        return symbol;
    }
    
    /*
    *Returns the decimal count of the Token
    */
    function getDecimal() public view returns(uint){
        uint decimal = token.decimals();
        return decimal;
    }
    
    /*
    *Returns the vesting amount of each cycle.
    *The function is private and is being called inside releaseToken()
    */
    function vestedAmount() private view returns(uint){
        uint currentTime = block.timestamp;
        uint timePassed = currentTime - start;
        if(timePassed>=vestingPeriod){
            return 1000;
        }else{
            uint amount = timePassed.div(duration);
            amount=amount.mul(250);
            return amount;
        }
    }
    
    /*
    *Releases the vested amount to the beneficiary.
    *Only the beneficiary can call the function.
    */
    function releaseToken() public onlyBeneficiary{
        uint vested = vestedAmount();
        uint toBeReleased = vested.sub(released);
        token.transfer(beneficiary,toBeReleased);
        released=released.add(toBeReleased);
    }
    
    /*
    *Returns the token balance of the beneficiary
    */
    function getBeneficiaryBalance() public view returns(uint){
        return token.balanceOf(beneficiary);
    }
}

