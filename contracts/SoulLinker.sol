// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./interfaces/ISoulboundIdentity.sol";
import "./interfaces/ISoulLinker.sol";

/// @title Soul linker
/// @author Masa Finance
/// @notice Soul linker smart contract that let add links to a Soulbound token.
contract SoulLinker is AccessControl, ISoulLinker {
    /* ========== STATE VARIABLES =========================================== */

    ISoulboundIdentity public soulboundIdentity;

    // Identity.tokenId => NFT/SBT address => tokenId
    mapping(uint256 => mapping(address => SoulLink)) private soulLinks;

    // NFT/SBT address => tokenId = Identity.tokenId
    mapping(address => mapping(uint256 => LinkToSoul)) private linksToSoul;

    /* ========== INITIALIZE ================================================ */

    /// @notice Creates a new soul linker
    /// @param admin Administrator of the smart contract
    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    /* ========== RESTRICTED FUNCTIONS ====================================== */

    /// @notice Sets the SoulboundIdentity contract address linked to this soul name
    /// @dev The caller must have the admin role to call this function
    /// @param _soulboundIdentity Address of the SoulboundIdentity contract
    function setSoulboundIdentity(ISoulboundIdentity _soulboundIdentity)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(address(_soulboundIdentity) != address(0), "ZERO_ADDRESS");
        require(soulboundIdentity != _soulboundIdentity, "SAME_VALUE");
        soulboundIdentity = _soulboundIdentity;
    }

    /* ========== MUTATIVE FUNCTIONS ======================================== */

    function createLink(
        uint256 identityId,
        address token,
        uint256 tokenId,
        uint256 expirationDate
    ) external {
        require(
            _isIdentityApprovedOrOwner(_msgSender(), identityId),
            "CALLER_NOT_IDENTITY_OWNER"
        );
        require(!soulLinks[identityId][token].exists, "LINK_EXISTS");
        require(!linksToSoul[token][tokenId].exists, "LINK_EXISTS");
        soulLinks[identityId][token] = SoulLink(true, tokenId, expirationDate);
        linksToSoul[token][tokenId] = LinkToSoul(true, identityId);
    }

    /* ========== VIEWS ===================================================== */

    /// @notice Query if the contract has links for the given token id
    /// @param token Address of the token linked to the soul
    /// @param tokenId Id of the token linked to the soul
    /// @return `true` if the contract has links, `false` otherwise
    function hasLinks(address token, uint256 tokenId)
        external
        view
        override
        returns (bool)
    {
        return linksToSoul[token][tokenId].exists;
    }

    /* ========== PRIVATE FUNCTIONS ========================================= */

    function _isIdentityApprovedOrOwner(address caller, uint256 identityId)
        internal
        view
        virtual
        returns (bool)
    {
        address owner = IERC721(soulboundIdentity).ownerOf(identityId);
        return (caller == owner ||
            IERC721(soulboundIdentity).isApprovedForAll(owner, caller) ||
            IERC721(soulboundIdentity).getApproved(identityId) == caller);
    }

    /* ========== MODIFIERS ================================================= */

    /* ========== EVENTS ==================================================== */
}
