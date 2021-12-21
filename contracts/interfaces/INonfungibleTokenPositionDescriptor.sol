// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Describes position NFT tokens via URI
interface INonfungibleTokenPositionDescriptor {
  function flipRatio(
    address token0,
    address token1,
    uint256 chainId
  ) external view returns (bool);
}
