pragma solidity ^0.4.24;

// @TODO either do it like this for current laziness or use signatures? so we can use like ABI encoded

interface DataStorage {

    function validate(bytes input) external returns (bool);
    function submit(bytes input) external;

}
