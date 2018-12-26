pragma solidity ^0.5.0;

// @TODO either do it like this for current laziness or use signatures? so we can use like ABI encoded

interface DataStorage {

    function isValid(bytes calldata input) external view returns (bool);
    function submit(bytes calldata input) external;

}
