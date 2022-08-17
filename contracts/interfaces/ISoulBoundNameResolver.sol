// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

interface ISoulBoundNameResolver {
    function nameExists(string memory name) external returns (bool exists);

    function getData(string memory name)
        external
        returns (
            address owner,
            string memory sbtName,
            uint256 identityId
        );

    function getIdentityName(uint256 identityId)
        external
        view
        returns (string memory sbtName);

    function getIdentityNames(uint256 identityId)
        external
        view
        returns (string[] memory sbtNames);
}
