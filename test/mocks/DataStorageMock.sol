pragma solidity ^0.4.24;

import "../../contracts/DataStorage.sol";

contract DataStorageMock is DataStorage {

    function isValid(bytes input) external returns (bool) {
        return input[0] == 1;
    }

    function submit(bytes input) external {
        // @todo
    }
}
