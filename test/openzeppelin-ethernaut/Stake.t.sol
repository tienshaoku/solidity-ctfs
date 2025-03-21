// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/openzeppelin-ethernaut/Stake.sol";

import "src/openzeppelin-ethernaut/ERC20Impl.sol";

contract StakeTest is Test {
    Stake instance;
    ERC20Impl weth;
    address alice = makeAddr("alice");

    function setUp() public {
        weth = new ERC20Impl("WETH", "WETH");
        instance = new Stake{value: 1 ether}(address(weth));
    }

    function test() public {
        assertEq(address(instance).balance, 1 ether);

        vm.startPrank(alice);
        weth.approve(address(instance), 0.5 ether);
        instance.StakeWETH(0.5 ether);
        instance.Unstake(0.5 ether);
        vm.stopPrank();

        assertEq(address(instance).balance, 0.5 ether);
        assertEq(address(alice).balance, 0.5 ether);
        assertEq(instance.UserStake(alice), 0);
        assertEq(instance.Stakers(alice), true);
    }
}
