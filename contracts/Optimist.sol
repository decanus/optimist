pragma solidity ^0.4.24;

interface Optimist {

    event Submitted(address indexed sender, uint256 index, bytes input);
    event Challenged(address indexed challenger, uint256 index);

    function submit(bytes input) external payable;
    function challenge(uint256 id) external;

}
