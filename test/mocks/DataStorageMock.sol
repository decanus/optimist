pragma solidity ^0.5.0;

import "../../contracts/DataStorage.sol";

contract DataStorageMock is DataStorage {

    function isValid(bytes calldata input) external view returns (bool) {
        return input[0] == 0x01;
    }

    function submit(bytes calldata ) external {
        // @todo
    }
}
