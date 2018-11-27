pragma solidity ^0.4.24;

import "./DataStorage.sol";

// @TODO either do it like this for current laziness or use signatures? so we can use like ABI encoded

contract DataStorageWithRemoval {

    function isValid(bytes input) external returns (bool);
    function submit(bytes input) external returns (uint);
    function remove(uint index) external;

}
