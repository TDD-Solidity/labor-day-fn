// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract LaborDay {
    uint256 public counter = 1;

    function greet() external pure returns (string memory) {
        return "Happy Labor Day!";
    }

    function greet2(string memory name) external pure returns (string memory) {
        if (
            keccak256(abi.encodePacked((name))) ==
            keccak256(abi.encodePacked(("Santa Claus")))
        ) {
            return "OMG I am so glad you called this function, Santa!";
        }

        return string(abi.encodePacked("Happy Labor Day ", name, "!"));
    }
}
