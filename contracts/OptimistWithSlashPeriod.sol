pragma solidity ^0.4.18;

contract Optimist {

    uint256 public stake;
    uint256 public slashPeriod;

    struct Data {
        bytes input;
        uint256 submitted;
        address sender;
    }

    constructor(uint256 _stake, uint256 _slashPeriod) {
        stake = _stake;
        slashPeriod = _slashPeriod;
    }

    function commit(bytes input) external {

    }

    function submit() external {
        
    }

    function challenge() external {
        
    }

}
