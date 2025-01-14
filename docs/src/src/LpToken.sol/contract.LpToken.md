# LpToken
[Git Source](https://github.com/outdoteth/Caviar/blob/fe772f95d422ab3b2897f7403c37b8326c5a1bbf/src/LpToken.sol)

**Inherits:**
Owned, ERC20

**Author:**
out.eth (@outdoteth)

LP token which is minted and burned by the Pair contract to represent liquidity in the pool.


## Functions
### constructor


```solidity
constructor(string memory pairSymbol)
    Owned(msg.sender)
    ERC20(string.concat(pairSymbol, " LP token"), string.concat("LP-", pairSymbol), 18);
```

### mint

Mints new LP tokens to the given address.


```solidity
function mint(address to, uint256 amount) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|The address to mint to.|
|`amount`|`uint256`|The amount to mint.|


### burn

Burns LP tokens from the given address.


```solidity
function burn(address from, uint256 amount) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`from`|`address`|The address to burn from.|
|`amount`|`uint256`|The amount to burn.|


