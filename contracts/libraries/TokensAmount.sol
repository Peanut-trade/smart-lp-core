//SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.6;

import '@uniswap/v3-core/contracts/libraries/TickMath.sol';
import '@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';

library TokensAmount {
  using SafeMath for uint256;

  function getAmountsFromPosition(
    uint128 liquidity,
    int24 tickLower,
    int24 tickUpper,
    int24 poolTick
  ) internal pure returns (uint256 amount0, uint256 amount1) {
    amount0 = TokensAmount.token0Amount(liquidity, poolTick, tickLower, tickUpper);
    amount1 = TokensAmount.token1Amount(liquidity, poolTick, tickLower, tickUpper);
    return (amount0, amount1);
  }

  function token0Amount(
    uint128 liquidity,
    int24 currentTick,
    int24 tickLower,
    int24 tickUpper
  ) internal pure returns (uint256 amount) {
    if (currentTick < tickLower) {
      return
        SqrtPriceMath.getAmount0Delta(
          TickMath.getSqrtRatioAtTick(tickLower),
          TickMath.getSqrtRatioAtTick(tickUpper),
          liquidity,
          false
        );
    } else if (currentTick < tickUpper) {
      return
        SqrtPriceMath.getAmount0Delta(
          TickMath.getSqrtRatioAtTick(currentTick),
          TickMath.getSqrtRatioAtTick(tickUpper),
          liquidity,
          false
        );
    } else {
      return 0;
    }
  }

  function token1Amount(
    uint128 liquidity,
    int24 currentTick,
    int24 tickLower,
    int24 tickUpper
  ) internal pure returns (uint256 amount) {
    if (currentTick < tickLower) {
      return 0;
    } else if (currentTick < tickUpper) {
      return
        SqrtPriceMath.getAmount1Delta(
          TickMath.getSqrtRatioAtTick(tickLower),
          TickMath.getSqrtRatioAtTick(currentTick),
          liquidity,
          false
        );
    } else {
      return
        SqrtPriceMath.getAmount1Delta(
          TickMath.getSqrtRatioAtTick(tickLower),
          TickMath.getSqrtRatioAtTick(tickUpper),
          liquidity,
          false
        );
    }
  }

  function getPoolAddress(
    address tokenA,
    address tokenB,
    address factory,
    uint24 _fee
  ) internal pure returns (address) {
    PoolAddress.PoolKey memory poolKey = PoolAddress.PoolKey({
      token0: tokenA,
      token1: tokenB,
      fee: _fee
    });
    return PoolAddress.computeAddress(factory, poolKey);
  }
}
