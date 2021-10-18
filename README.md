# ERC20 Vesting Smart Contract
*The repo only consists of the smart contracts. They can be found in the **contracts** folder.*

The project consists of a ERC20 token named `MeshaCoin` with a fixed-supply of 1000 tokens, and a vesting smart contract named `MeshaCoinVesting`. The latter smart contract allows token vesting over a vesting period of 4 years with 25% of fixed-supply of tokens i.e 250 tokens issued every year.

### Some math related to `MeshaCoinVesting`
- Total vesting period = **4 years**

| Time | Vested Amount |
| ---- | ------------  |
| 1 yr |      250      |
| 2 yr |      500      |
| 3 yr |      750      |
| 4 yr |      1000     |

The below function in `MeshaCoinVesting.sol` calculates the vesting amount for each year.
```solidity
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
```

The time at which the current function is called is calculated i.e **timePassed** and if this is greater than the vesting period, all the tokens are returned. Else the amount is calculated using 
```math
amount = timePassed / duration
amount = amount * 250
```

*For testing purposes, the **duration** in `MeshaCoinVesting` can be set to **30 seconds**.*

