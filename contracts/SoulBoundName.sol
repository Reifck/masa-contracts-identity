// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/ISoulBoundNameResolver.sol";
import "./utils/Utils.sol";
import "./SoulBoundIdentity.sol";

contract SoulBoundName is
    ERC721,
    ERC721Enumerable,
    Pausable,
    AccessControl,
    ERC721Burnable,
    ISoulBoundNameResolver
{
    using Counters for Counters.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    SoulBoundIdentity public soulBoundIdentity;
    string public extension; // suffix of the names (.sol?)

    mapping(uint256 => string) tokenIdToName; // used to sort through all names (name in lowercase)
    mapping(string => SoulBoundNameData) soulBoundNames; // register of all soulbound names (name in lowercase)

    struct SoulBoundNameData {
        address owner;
        string name; // Name with lowercase and uppercase
        uint256 tokenId;
    }

    constructor(address owner, SoulBoundIdentity _soulBoundIdentity, string memory _extension)
        ERC721("Masa Identity Name", "MIN")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, owner);
        _grantRole(PAUSER_ROLE, owner);
        _grantRole(MINTER_ROLE, owner);

        soulBoundIdentity = _soulBoundIdentity;
        extension = _extension;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function setSoulBoundIdentity(SoulBoundIdentity _soulBoundIdentity)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(soulBoundIdentity != _soulBoundIdentity, "SAME_VALUE");
        soulBoundIdentity = _soulBoundIdentity;
    }

    function setExtension(string memory _extension)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(
            keccak256(abi.encodePacked((extension))) !=
                keccak256(abi.encodePacked((_extension))),
            "SAME_VALUE"
        );
        extension = _extension;
    }

    function nameExists(string memory name)
        public
        override
        returns (bool exists)
    {
        string memory lowercaseName = Utils.toLowerCase(name);
        return (soulBoundNames[lowercaseName].owner != address(0));
    }

    function resolveName(string memory name)
        external
        override
        returns (
            address owner,
            string memory sbtName,
            uint256 tokenId
        )
    {
        return (address(0), "", 0);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        // TODO: return json with nft data
        return "";
    }

    function safeMint(address to, string memory name)
        public
        onlyRole(MINTER_ROLE)
    {
        // TODO: require that the name is not already used
        // TODO: require tokenId exist

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        string memory lowercaseName = Utils.toLowerCase(name);
        tokenIdToName[tokenId] = lowercaseName;

        soulBoundNames[lowercaseName].owner = to;
        soulBoundNames[lowercaseName].name = name;
        soulBoundNames[lowercaseName].tokenId = tokenId;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
