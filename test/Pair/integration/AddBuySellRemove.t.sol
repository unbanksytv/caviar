// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../shared/Fixture.t.sol";
import "../../../src/Caviar.sol";

contract AddBuySellRemoveTest is Fixture {
    function testItAddsBuysSellsRemovesCorrectAmount(
        uint256 addBaseTokenAmount,
        uint256 addFractionalTokenAmount,
        uint256 buyTokenAmount
    ) public {
        addBaseTokenAmount = bound(addBaseTokenAmount, 10000000, type(uint96).max);
        addFractionalTokenAmount = bound(addFractionalTokenAmount, 10000000, 10_000_000 * 1e18);
        buyTokenAmount = bound(buyTokenAmount, 1, addFractionalTokenAmount - 1);

        // add liquidity
        deal(address(usd), address(this), addBaseTokenAmount, true);
        deal(address(p), address(this), addFractionalTokenAmount, true);
        uint256 lpTokenAmount = Math.sqrt(addBaseTokenAmount * addFractionalTokenAmount) - 100_000;
        usd.approve(address(p), type(uint256).max);
        p.add(addBaseTokenAmount, addFractionalTokenAmount, lpTokenAmount, 0, type(uint256).max, 0);

        // buy some amount
        uint256 baseTokenBuyAmount = p.buyQuote(buyTokenAmount);
        deal(address(usd), address(this), baseTokenBuyAmount, true);
        p.buy(buyTokenAmount, baseTokenBuyAmount, 0);

        // remove some fraction of liquidity
        uint256 removeLpTokenAmount = lpTokenAmount / 10;
        uint256 expectedBaseTokenAmount = p.baseTokenReserves() * removeLpTokenAmount / lpToken.totalSupply();
        uint256 expectedFractionalTokenAmount =
            p.fractionalTokenReserves() * removeLpTokenAmount / lpToken.totalSupply();
        (uint256 baseTokenOutputAmount, uint256 fractionalTokenOutputAmount) = p.remove(removeLpTokenAmount, 0, 0, 0);

        assertApproxEqAbs(
            baseTokenOutputAmount, expectedBaseTokenAmount, 10, "Should have removed correct base token amount"
        );
        assertApproxEqAbs(
            fractionalTokenOutputAmount,
            expectedFractionalTokenAmount,
            10,
            "Should have removed correct fractional token amount"
        );
    }
}
